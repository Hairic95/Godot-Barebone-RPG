extends Node

var status_name = "Missing String"
var status_type = ""

var amount = 0
var turn_duration = 1

var icon_texture = null

func init(status_name, status_type, amount, turn_duration, icon_texture):
	self.status_name = status_name
	self.status_type = status_type
	self.amount = amount
	self.turn_duration = turn_duration
	self.icon_texture = icon_texture

func apply_status(target):
	
	match(status_type):
		Constants.StatusType_Bleed:
			target.inflict_damage(amount)
	
	
	turn_duration -= 1
	target.emit_signal("change_status", self)
	if turn_duration < 0:
		queue_free()
		target.emit_signal("remove_status", self)

func get_description():
	return "Missing String"
