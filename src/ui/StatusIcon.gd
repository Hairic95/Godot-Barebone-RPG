extends TextureRect

var status_name = "Missing String"
var status_type = ""
var amount = 0
var turn_duration = 1

func _ready():
	pass

func init(status):
	status_name = status.status_name
	status_type = status.status_type
	amount = status.amount
	turn_duration = status.turn_duration
	texture = status.icon_texture

func get_description():
	if turn_duration != 1:
		return str(status_name, " ", amount, " (", turn_duration, " turns)")
	else:
		return str(status_name, " ", amount, " (", turn_duration, " turn)")

func _on_StatusIcon_mouse_entered():
	hint_tooltip = get_description()
