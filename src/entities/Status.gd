extends Node

var status_name = "Missing String"
var status_type = ""

var amount = null
var turn_duration = 1

var icon_texture = null

func init(status_name, status_type, amount, turn_duration, icon_texture):
	self.status_name = status_name
	self.status_type = status_type
	self.amount = amount
	self.turn_duration = turn_duration
	self.icon_texture = icon_texture

func apply_status(target):
	
	turn_duration -= 1
	
	if turn_duration <= 0:
		queue_free()

func get_description():
	if amount == null && turn_duration != 1:
		return str(status_name, " (", turn_duration, " turns)")
	elif amount == null && turn_duration == 1:
		return str(status_name, " (", turn_duration, " turn)")
	elif turn_duration != 1:
		return str(status_name, " ", amount, " (", turn_duration, " turns)")
	elif turn_duration == 1:
		return str(status_name, " ", amount, " (", turn_duration, " turn)")
