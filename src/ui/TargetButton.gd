extends Node2D

export (Texture) var normal_texture
export (Texture) var hover_texture

signal pressed()
signal mouse_enter()
signal mouse_exit()


var is_multiple = false

func _ready():
	$AnimationPlayer.play("idle")
	$TextureButton.rect_position.x = -$TextureButton.texture_normal.get_width() / 2.0
	$TextureButton.rect_position.y = -$TextureButton.texture_normal.get_height() / 2.0

func _on_TextureButton_pressed():
	emit_signal("pressed")

func _on_TextureButton_mouse_entered():
	emit_signal("mouse_enter")
	set_hover_sprite(true)

func _on_TextureButton_mouse_exited():
	emit_signal("mouse_exit")

func set_hover_sprite(value):
	if value:
		$TextureButton.texture_normal = hover_texture
	else:
		$TextureButton.texture_normal = normal_texture
