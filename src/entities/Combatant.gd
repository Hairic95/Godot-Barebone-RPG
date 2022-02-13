extends Node2D

var action_reference = load("res://src/entities/Action.tscn")
var status_reference = load("res://src/entities/Status.tscn")
var buff_reference = load("res://src/entities/Buff.tscn")

var combatant_name = "Missing string"

var current_hp = 1
var max_hp = 1

var min_attack = 1
var max_attack = 1

var protection = 0
var speed = 1

var player_id = ""

var fixed_position = Vector2.ZERO

signal combatant_hp_changed()
signal status_changed()
signal buffs_changed()

func _ready():
	randomize()
	fixed_position = get_global_position()

# Uses a dictionary value from the list combatant_data in Database.gd
func init(data, starting_position):
	
	combatant_name = data.name
	max_hp = int(data.max_hp)
	current_hp = int(data.current_hp)
	min_attack = int(data.min_attack)
	max_attack = int(data.max_attack)
	speed = int(data.speed)
	protection = int(data.protection)
	if (data.has("animations")):
		$Animations.add_child(data.animations.instance())
	
	for action in data.actions:
		var new_action = action_reference.instance()
		if Database.action_data.has(action):
			var action_data = Database.action_data[action]
			new_action.init(action_data)
			
			$Actions.add_child(new_action)
	
	global_position = starting_position

func get_initiative():
	return (randi()%6 + 1) + get_speed()

func get_actions():
	return $Actions.get_children()

func get_status():
	return $Status.get_children()

func get_buffs():
	return $Buffs.get_children()

func is_ko():
	return current_hp <= 0

func set_current_hint(value):
	$CurrentHint.visible = value

func get_maximum_attack():
	return max(1, apply_buff(max_attack, Constants.StatType_Attack))
func get_minimum_attack():
	return max(1, apply_buff(min_attack, Constants.StatType_Attack))
func get_protection():
	return clamp(apply_buff(protection, Constants.StatType_Protection), 0, 99)
func get_speed():
	return apply_buff(speed, Constants.StatType_Speed)

func apply_buff(starting_amount, stat_type):
	var result = starting_amount
	for buff in get_buffs():
		if buff.stat_type == stat_type:
			if buff.buff_amount_type == Constants.BuffAmountType_Flat:
				result += buff.amount
			elif buff.buff_amount_type == Constants.BuffAmountType_Percentage:
				result += int(float(result) * float(buff.amount) / 100.0)
	return result

func roll_attack_damage():
	return randi()%(get_maximum_attack() - get_minimum_attack()) + get_minimum_attack()

# Battle Effects

# Let player reach negative health, so that you can heal them
func inflict_damage(damage):
	if player_id == Constants.PlayerId_Player:
		current_hp = max(-50, current_hp - damage)
		if current_hp <= 0:
			toggle_ko_sprite(true)
			EventBus.emit_signal("remove_combatant_from_queue", self)
	elif player_id == Constants.PlayerId_Enemy:
		current_hp = max(0, current_hp - damage)
		if current_hp == 0:
			die()
	EventBus.emit_signal("create_damage_label", damage, get_target_position(), Color("b72c69"))
	emit_signal("combatant_hp_changed", current_hp, max_hp)

func heal_hp(amount):
	var was_ko = current_hp <= 0
	current_hp = min(max_hp, current_hp + amount)
	if current_hp > 0:
		toggle_ko_sprite(false)
		if was_ko:
			EventBus.emit_signal("combatant_revived", self)
	EventBus.emit_signal("create_damage_label", amount, global_position + Vector2(0, -20), Color("2cb744"))
	emit_signal("combatant_hp_changed", current_hp, max_hp)

func add_status(status_data):
	var new_status = status_reference.instance()
	new_status.init(status_data)
	$Status.add_child(new_status)
	
	emit_signal("status_changed")

func clear_status(status_type):
	for status in $Status.get_children():
		if status.status_type == status_type:
			status.queue_free()
	emit_signal("status_changed")

func add_buff(buff_data):
	var new_buff = buff_reference.instance()
	new_buff.init(buff_data)
	$Buffs.add_child(new_buff)
	
	emit_signal("buffs_changed")

func consume_buffs():
	for buff in $Buffs.get_children():
		buff.consume()
		yield(get_tree().create_timer(.01), "timeout")
	
	emit_signal("buffs_changed")

func die():
	EventBus.emit_signal("remove_combatant_from_queue", self)
	EventBus.emit_signal("remove_combatant_ui", self)
	queue_free()

# Misc

func get_target_position():
	if $Animations.get_child_count() > 0:
		return $Animations.get_child(0).get_target_position()
	else:
		return global_position

func toggle_ko_sprite(value):
	if $Animations.get_child_count() > 0:
		$Animations.get_child(0).toggle_ko(value)
