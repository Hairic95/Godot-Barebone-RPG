extends Node

var effect_name = "Missing String"

var effect_type = ""

var amount = 1
var turn_duration = 1

var stat = ""

var icon_texture = preload("res://icon.png")

func _ready():
	pass

func init(data):
	effect_type = data.type
	if (data.has("amount")):
		amount = data.amount
	

func apply_to_target(target):
	match(effect_type):
		Constants.EffectType_Heal:
			target.heal_hp(amount)
