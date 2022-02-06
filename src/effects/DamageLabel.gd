extends RigidBody2D

func _ready():
	var angle = clamp(randf() * PI + PI, PI / 4.0 * 5.0, PI / 4.0 * 7.0)
	apply_central_impulse(Vector2(cos(angle), sin(angle)) * 450.0)

func set_number(damage, color):
	$Label.text = str(damage)
	$Label.add_color_override("font_color", color)


func _on_Timer_timeout():
	var alpha = $Label.modulate
	alpha.a = 0
	$Tween.interpolate_property($Label, "modulate", $Label.modulate, alpha, .6)
	$CollisionShape2D.queue_free()
	$Tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
