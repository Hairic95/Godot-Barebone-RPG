extends Node

var stat_type = null
var stat_name = "Missing Stat"

var buff_type = ""
var buff_amount_type = ""

var amount = 0
var turn_duration = 1

var icon_texture = null

func _ready():
	pass

func init(data):
	stat_type = data.stat_type
	match(stat_type):
		Constants.StatType_Attack:
			stat_name = "ATK"
		Constants.StatType_Protection:
			stat_name = "PROT"
		Constants.StatType_Speed:
			stat_name = "SPD"
	buff_type = data.buff_type
	buff_amount_type = data.buff_amount_type
	amount = data.amount
	turn_duration = data.turn_duration
	icon_texture = data.icon_texture

func consume():
	turn_duration -= 1
	if turn_duration <= 0:
		queue_free()

func get_description():
	var result = ""
	result += "+" if amount > 0 else "-"
	result += str(abs(amount))
	if (buff_amount_type == Constants.BuffAmountType_Percentage):
		result += "%"
	result += " " + stat_name
	
	if turn_duration != 1:
		result += str(" (", turn_duration, " turns)")
	elif turn_duration == 1:
		result += str(" (", turn_duration, " turn)")
	return result

