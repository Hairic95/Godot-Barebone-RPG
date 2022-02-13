extends Node
class_name Player

var id : String = ""

var type = Constants.PlayerType.Player

var combatants = []

var opponent_combatants = []

func _ready():
	EventBus.connect("remove_combatant_from_queue", self, "remove_combatant")
	EventBus.connect("combatant_revived", self, "combatant_revived")

func _init(player_id, player_type):
	id = player_id
	type = player_type

func choose_action(current_combatant):
	# Check all available actions
	var possible_actions = []
	for action in current_combatant.get_actions():
		if action.has_max_uses() && action.current_uses > 0:
			possible_actions.append(action)
		else:
			possible_actions.append(action)
	var chosen_action
	# Choose a random action
	if possible_actions.size() != 0:
		chosen_action = possible_actions[randi()%possible_actions.size()]
	else:
		# If no action could be chosen, pass the turn
		EventBus.emit_signal("show_enemy_action", str(current_combatant.combatant_name, " has no move available"))
		yield(get_tree().create_timer(1.2), "timeout")
		EventBus.emit_signal("ai_action_chosen", current_combatant, null, [])
		return
	
	# Check all the available targets
	var possible_targets = []
	match chosen_action.target:
		Constants.ActionTarget_AllySingle, Constants.ActionTarget_AllyMultiple:
			for c in combatants:
				if !c.is_ko():
					possible_targets.append(c)
		Constants.ActionTarget_EnemySingle, Constants.ActionTarget_EnemyMultiple:
			for c in opponent_combatants:
				if !c.is_ko():
					possible_targets.append(c)
		Constants.ActionTarget_Self:
			possible_targets.append(current_combatant)
	
	# Show the action text
	yield(get_tree().create_timer(.3), "timeout")
	
	EventBus.emit_signal("show_enemy_action", str(current_combatant.combatant_name, " uses ", chosen_action.action_name, "!"))
	
	yield(get_tree().create_timer(1.2), "timeout")
	
	# Execute the action
	if chosen_action.target.ends_with("single"):
		var chosen_targets = [possible_targets[randi()%possible_targets.size()]]
		EventBus.emit_signal("ai_action_chosen", current_combatant, chosen_action, chosen_targets)
	else:
		EventBus.emit_signal("ai_action_chosen", current_combatant, chosen_action, possible_targets)

func remove_combatant(combatant):
	if combatants.has(combatant):
		combatants.erase(combatant)
	if opponent_combatants.has(combatant):
		opponent_combatants.erase(combatant)

func combatant_revived(combatant):
	if combatant.player_id == id:
		combatants.append(combatant)
	else:
		opponent_combatants.append(combatant)
