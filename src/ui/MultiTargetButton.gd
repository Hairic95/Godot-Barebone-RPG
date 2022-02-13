extends Node2D

export (PackedScene) var target_button_reference = load("res://src/ui/EnemyTargetButton.tscn")

signal pressed()

func _ready():
	pass # Replace with function body.

# targets is a Array of Vector2
func init(targets):
	for target in targets:
		var new_target_button = target_button_reference.instance()
		new_target_button.global_position = target
		new_target_button.connect("pressed", self, "press")
		new_target_button.connect("mouse_entered", self, "mouse_entered")
		new_target_button.connect("mouse_exited", self, "mouse_exited")
		add_child(new_target_button)

func press():
	emit_signal("pressed")

func mouse_entered():
	for child in get_children():
		child.set_hover_sprite(true)
func mouse_exited():
	for child in get_children():
		child.set_hover_sprite(false)
