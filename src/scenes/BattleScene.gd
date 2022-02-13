extends Node2D

signal change_scene(new_scene_key)

# References of scenes to instanciate with the battle
var combatant_reference = load("res://src/entities/Combatant.tscn")

var enemy_target_button_reference = load("res://src/ui/EnemyTargetButton.tscn")
var ally_target_button_reference = load("res://src/ui/AllyTargetButton.tscn")
var health_bar_reference = load("res://src/ui/HealthBar.tscn")

var damage_label_reference = load("res://src/effects/DamageLabel.tscn")

# Players
var player = null
var opponent = null

# Array of the combatants, sorted by the turn initiative, which is
# the combatant speed value plus a random value between 1 and 6
var initiative_order = []

# Turn count
var turn_count = 0

func _ready():
	
	# Signal connection
	EventBus.connect("ai_action_chosen", self, "execute_action")
	EventBus.connect("create_popup_at", self, "create_combatant_popup_at")
	EventBus.connect("create_damage_label", self, "create_damage_label")
	EventBus.connect("show_enemy_action", self, "show_text")
	
	EventBus.connect("remove_combatant_from_queue", self, "remove_combatant_from_queue")
	EventBus.connect("remove_combatant_ui", self, "remove_combatant_ui")
	
	randomize()
	
	# Create the enemy position references, delete the scene after retrieving the data
	# (this function should be called externally)
	var new_battle_data_scene = load("res://src/battle_data/battle_test_003.tscn").instance()
	add_child(new_battle_data_scene)
	var enemy_data = new_battle_data_scene.get_battle_data()
	new_battle_data_scene.queue_free()
	
	# Prepare the battle, passing the battle the players combatant and the enemies from the reference scene
	# (this function should be called externally)
	prepare_battle({
		"id": Constants.PlayerId_Player,
		"combatants": [{
			"id": "knight",
			"position": $PlayerCombatantPositions/Pos1.global_position,
			"current_hp": null
		}, {
			"id": "butcher",
			"position": $PlayerCombatantPositions/Pos2.global_position,
			"current_hp": null
		}, {
			"id": "knight",
			"position": $PlayerCombatantPositions/Pos3.global_position,
			"current_hp": null
		}],
		"type": Constants.PlayerType.Player
	}, {
		"id": Constants.PlayerId_Enemy,
		"combatants": enemy_data,
		"type": Constants.PlayerType.AI
	})

# ------------------------------
# Battle preparation
# ------------------------------

# DATA STRUCTURE
# var player_team = {
# "id": "player",
# "combatants": [{"id": "butcher", "position": Vector2(100, 100), "current_hp": 30}],
# "type": Constants.PlayerType.Player
# }
#
# var enemy_team = {
# "id": "enemy",
# "combatants": [{"combatant": "wax_slug", "position": Vector2(100, 100)}],
# "type": Constants.PlayerType.AI
# }
func prepare_battle(player_team, enemy_team):
	
	# Create the player object, necessary to identifing the combatant ownership and make the ai act up
	player = Player.new(player_team.id, player_team.type)
	opponent = Player.new(enemy_team.id, enemy_team.type)
	
	$Players.add_child(player)
	$Players.add_child(opponent)
	
	# Create the players combatant, using the fixed position in $PlayerCombatantPositions,
	# Also create their respective healthbars
	var combatant_position_id = 1
	var player_combatants = []
	for combatant in player_team.combatants:
		var new_combatant = create_combatant(combatant.id, combatant.position, combatant.current_hp)
		new_combatant.player_id = player_team.id
		player_combatants.append(new_combatant)
		# HealthBar
		var new_health_bar = health_bar_reference.instance()
		new_health_bar.init(new_combatant)
		new_combatant.connect("combatant_hp_changed", self, "combatant_hp_changed", [new_health_bar])
		new_combatant.connect("status_changed", self, "status_changed", [new_health_bar])
		$UI/PlayerHealthBars.add_child(new_health_bar)
		
		combatant_position_id += 1
	
	# Create the enemy combatant,
	# Also create their respective healthbars
	var enemy_combatants = []
	for combatant in enemy_team.combatants:
		var new_combatant = create_combatant(combatant.id, combatant.position)
		new_combatant.player_id = enemy_team.id
		new_combatant.scale.x = - new_combatant.scale.x
		enemy_combatants.append(new_combatant)
		# HealthBar
		var new_health_bar = health_bar_reference.instance()
		new_health_bar.init(new_combatant)
		new_combatant.connect("combatant_hp_changed", self, "combatant_hp_changed", [new_health_bar])
		new_combatant.connect("status_changed", self, "status_changed", [new_health_bar])
		$UI/EnemyHealthBars.add_child(new_health_bar)
	
	# Give the combatants references to the two players
	player.combatants = player_combatants
	player.opponent_combatants = enemy_combatants
	
	opponent.combatants = enemy_combatants
	opponent.opponent_combatants = player_combatants
	
	# Start the first turn
	start_turn()

# Create a combatant, using the id as a reference to use in the Database.gd
# If the current_hp is null, then the combatant hp are full
func create_combatant(combatant_id, combatant_position, current_hp = null):
	
	var new_combatant = combatant_reference.instance()
	if (Database.combatant_data.has(combatant_id)):
		var data = Database.combatant_data[combatant_id]
		new_combatant.init({
			"name": data.name,
			"max_hp": data.max_hp,
			"current_hp": data.max_hp if current_hp == null else current_hp,
			"min_attack": data.min_attack,
			"max_attack": data.max_attack,
			"speed": data.speed,
			"protection": data.protection,
			"animations": data.animations,
			"actions": data.actions
		}, combatant_position)
	
	$Combatants/Ysort.add_child(new_combatant)
	
	return new_combatant
	

# ------------------------------
# Turn Management
# ------------------------------

func start_turn():
	
	# Increse the turn counter
	turn_count += 1
	$UI/TurnCounter.text = str("Turn: ", turn_count)
	
	show_text(str("Turn ", turn_count, " starts!"))
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	reset_text()
	
	# Roll and assigned initiative to every active combatant
	for combatant in $Combatants/Ysort.get_children():
		if combatant.is_ko():
			continue
		var initiative = combatant.get_initiative()
		initiative_order.append({
			"combatant": combatant,
			"initiative": initiative
		})
	initiative_order.sort_custom(self, "sort_initiative")
	
	# the first combatant Acts
	go_to_next_combatant()

# Sort initiative
func sort_initiative(comb_1, comb_2):
	if comb_1.initiative > comb_2.initiative:
		return true
	return false

# Make the next combatant in the inititive_queue act, then removes it from the queue
# if its a player combatant, the ui will be displayed
# if its an enemy combatant, the ai will choose an avaiable move
# if there are no combatant left in the queue, start a new turn
func go_to_next_combatant():
	
	# Hides previous initiative hint
	for combatant in $Combatants/Ysort.get_children():
		combatant.set_current_hint(false)
	if (initiative_order.size() > 0):
		
		# get the current combatant
		var current_combatant = initiative_order.pop_front().combatant
		
		# show that combatant initiative hint
		current_combatant.set_current_hint(true)
		
		# Check DoT status and apply them
		var totalDOTDamage = 0
		for status in current_combatant.get_status():
			if status.status_type == Constants.StatusType_Bleed:
				totalDOTDamage += status.amount
				status.apply_status(current_combatant)
			if status.status_type == Constants.StatusType_Poison:
				totalDOTDamage += status.amount
				status.apply_status(current_combatant)
		
		if totalDOTDamage != 0:
			current_combatant.inflict_damage(totalDOTDamage)
			# if the combatant has been freed or has been ko between a status, pass the turn
			if !weakref(current_combatant).get_ref() || current_combatant.is_ko():
				go_to_next_combatant()
				return
			yield(get_tree().create_timer(1.2), "timeout")
			current_combatant.emit_signal("status_changed")
		
		
		if current_combatant.player_id == player.id:
			# if it's a player combatant, show the ui
			show_combatant_actions(current_combatant)
		else:
			# if it's a enemy combatant, the player ai, chooses an action
			opponent.choose_action(current_combatant)
	else:
		# if no other combatant is left, start a new turn
		start_turn()

# Creates a button for each player action, plus a pass turn action
func show_combatant_actions(current_combatant):
	for action in current_combatant.get_actions():
		var new_action_button = Button.new()
		new_action_button.text = action.action_name
		# each button is connected to the function that shows the available targets for it
		new_action_button.connect("pressed", self, "show_action_targets", [current_combatant, action])
		$UI/Actions.add_child(new_action_button)
	
	var pass_action_button = Button.new()
	pass_action_button.text = "Pass"
	pass_action_button.connect("pressed", self, "execute_action", [current_combatant, null, []])
	$UI/Actions.add_child(pass_action_button)

# Show the available targets for a players move
func show_action_targets(acting_combatant, action):
	# erase previous targets
	erase_targets_ui()
	match(action.target):
		# if its a enemy targetting action, show the targets on the enemies
		Constants.ActionTarget_EnemySingle:
			for combatant in $Combatants/Ysort.get_children():
				if combatant.player_id != acting_combatant.player_id:
					var new_target = enemy_target_button_reference.instance()
					new_target.connect("pressed", self, "execute_action", [acting_combatant, action, [combatant]])
					new_target.connect("mouse_enter", self, "update_target_info", [combatant])
					new_target.connect("mouse_enter", self, "focus_target_hover", [new_target])
					new_target.global_position = combatant.get_target_position()
					$UI/Targets.add_child(new_target)
		# if its a ally targetting action, show the targets on the players combatants
		Constants.ActionTarget_AllySingle:
			for combatant in $Combatants/Ysort.get_children():
				if combatant.player_id == acting_combatant.player_id:
					var new_target = ally_target_button_reference.instance()
					new_target.connect("pressed", self, "execute_action", [acting_combatant, action, [combatant]])
					new_target.connect("mouse_enter", self, "update_target_info", [combatant])
					new_target.connect("mouse_enter", self, "focus_target_hover", [new_target])
					new_target.global_position = combatant.get_target_position()
					$UI/Targets.add_child(new_target)

# Executes an action over an array of targets
func execute_action(acting_combatant, action, targets):
	
	clear_target_info()
	
	erase_actions_ui()
	erase_targets_ui()
	reset_text()
	
	# If no action or targets are passed, skip the turn
	if action == null or targets.size() == 0:
		create_damage_label("Pass", acting_combatant.get_target_position(), Color("3d3d3d"))
		if !is_battle_over():
			go_to_next_combatant()
		return
	
	for target in targets:
		# if the action has damage, deal it to all the targets
		if action.damage_percentage != null:
			var flat_damage = randi()%(acting_combatant.max_attack - acting_combatant.min_attack) + acting_combatant.min_attack
			var action_damage = int(float(flat_damage) * float(action.damage_percentage) / 100.0 * float(100.0 - target.protection) / 100.0)
			
			create_effect(target.global_position, load("res://src/effects/HitEffect001.tscn"))
			
			target.inflict_damage(action_damage)
		
		# if the action has effects, apply them to all the targets
		for effect in action.get_effects():
			effect.apply_to_target(target)
	
	# Check if the battle is over, otherwise go to the next combatant
	if !is_battle_over():
		go_to_next_combatant()
	
	yield(get_tree().create_timer(1.2), "timeout")

# Removes a Ko-ed combatant
func remove_combatant_from_queue(combatant):
	for initiative_object in initiative_order:
		if initiative_object.combatant == combatant:
			initiative_order.erase(initiative_object)

# Check if one of the parties has been defeated
func is_battle_over():
	# Check player team
	var player_team_is_defeated = true
	for combatant in $Combatants/Ysort.get_children():
		if combatant.player_id == player.id && !combatant.is_ko():
			player_team_is_defeated = false
	
	# Check enemy team
	var enemy_team_is_defeated = true
	for combatant in $Combatants/Ysort.get_children():
		if combatant.player_id != player.id && !combatant.is_ko():
			enemy_team_is_defeated = false
	
	if player_team_is_defeated && enemy_team_is_defeated:
		show_text("That's a tie!")
	elif enemy_team_is_defeated:
		show_text("You won, enjoy this screen until you close it!")
	elif player_team_is_defeated:
		show_text("You lost lmao")
	
	return player_team_is_defeated || enemy_team_is_defeated

# ------------------------------
# UI and Effects Controls
# ------------------------------

# Clear the action buttons
func erase_actions_ui():
	for target_button in $UI/Actions.get_children():
		target_button.queue_free()

# Clear the target buttons
func erase_targets_ui():
	for target_button in $UI/Targets.get_children():
		target_button.queue_free()

# Instanciate a rigidbody damage label
func create_damage_label(damage, starting_position, color):
	
	var new_damage_effect = damage_label_reference.instance()
	new_damage_effect.global_position = starting_position
	new_damage_effect.set_number(str(damage), color)
	$UI/Effects.add_child(new_damage_effect)

# Display some text using a cool tween to move the text around
func show_text(text):
	$UI/Text/EnemyAction.text = text
	
	$UI/Text/EnemyAction/Tween.interpolate_property($UI/Text/EnemyAction, "rect_global_position", 
			$UI/Text/EnemyAction.rect_global_position, Vector2(0, 100), 0.5)
	$UI/Text/EnemyAction/Tween.start()

# Removes the text from the screen
func reset_text():
	$UI/Text/EnemyAction.rect_global_position = Vector2(0, -100)

# Instanciate a visual effect that disappears after the animation
func create_effect(starting_position, effect_reference):
	var new_effect = effect_reference.instance()
	new_effect.global_position = starting_position
	$UI/Effects.add_child(new_effect)

# Show a combatant stats on the screen
func update_target_info(combatant):
	$UI/TargetInfo/Name.text = combatant.combatant_name
	$UI/TargetInfo/HPValue.text = str(combatant.current_hp, " / ", combatant.max_hp)
	$UI/TargetInfo/ProtValue.text = str(combatant.protection)
	$UI/TargetInfo/AtkValue.text = str(combatant.min_attack, " - ", combatant.max_attack)
	$UI/TargetInfo/SpeedValue.text = str(combatant.speed)

# Removes the currrent combatant stats on the screen
func clear_target_info():
	$UI/TargetInfo/Name.text = "//"
	$UI/TargetInfo/HPValue.text = "//"
	$UI/TargetInfo/ProtValue.text = "//"
	$UI/TargetInfo/AtkValue.text = "//"
	$UI/TargetInfo/SpeedValue.text = "//"

# Makes one unique target as if it was hovered
func focus_target_hover(current_target):
	for target in $UI/Targets.get_children():
		if target != current_target:
			target.set_hover_sprite(false)

# Change the HP of a combatant healthbar
func combatant_hp_changed(current_hp, max_hp, health_bar):
	health_bar.update_hp(current_hp, max_hp)
	health_bar.set_hp_display(current_hp, max_hp)

# Add or update a status icon on a health bar
func status_changed(health_bar):
	health_bar.change_status()

# Removes a healthbar after the relative combatant has been ko-ed
func remove_combatant_ui(combatant):
	for health_bar in $UI/PlayerHealthBars.get_children():
		if health_bar.combatant == combatant:
			health_bar.queue_free()
	for health_bar in $UI/EnemyHealthBars.get_children():
		if health_bar.combatant == combatant:
			health_bar.queue_free()
