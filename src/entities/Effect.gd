extends Node

var effect_name = "Missing String"

var effect_type = ""
var stat_type = ""
var buff_type = ""
var buff_amount_type = ""

var amount = 1
var turn_duration = 1

var status_type = ""

var stat = ""

var icon_texture = preload("res://icon.png")

func _ready():
	pass

func init(data):
	effect_type = data.type
	if (data.has("name")):
		effect_name = data.name
	if (data.has("amount")):
		amount = data.amount
	if (data.has("status")):
		status_type = data.status
	if (data.has("stat_type")):
		stat_type = data.stat_type
	if (data.has("buff_type")):
		buff_type = data.buff_type
	if (data.has("buff_amount_type")):
		buff_amount_type = data.buff_amount_type
	if (data.has("turn_duration")):
		turn_duration = data.turn_duration
	if (data.has("icon")):
		icon_texture = data.icon

func apply_to_target(target):
	match(effect_type):
		Constants.EffectType_Heal:
			target.heal_hp(amount)
		Constants.EffectType_Status:
			target.add_status({
				"status_name": effect_name, 
				"status_type": status_type, 
				"amount": amount,
				"turn_duration": turn_duration, 
				"icon_texture": icon_texture
			})
		Constants.EffectType_ClearStatus:
			target.clear_status(status_type)
		Constants.EffectType_Buff:
			target.add_buff({
				"stat_type": stat_type,
				"buff_type": buff_type,
				"buff_amount_type": buff_amount_type,
				"amount": amount,
				"turn_duration": turn_duration,
				"icon_texture": icon_texture
			})
