extends Node2D

func _ready():
	pass

# Position where to put the target UI and effects
func get_target_position():
	return $TargetPosition.global_position

# basic KO change of sprites
func toggle_ko(value):
	if has_node("Ko"):
		$Ko.visible = value
