extends Control

var status_icon_reference = load("res://src/ui/StatusIcon.tscn")

var combatant = null

func _ready():
	pass

func init(combatant):
	self.combatant = combatant
	$Name.text = combatant.combatant_name
	$TextureProgress.min_value = 0
	$TextureProgress.max_value = combatant.max_hp
	$TextureProgress.value = combatant.current_hp
	$HPCount.text = str(combatant.current_hp, "/", combatant.max_hp)

func update_hp(current_hp, max_hp):
	$Tween.interpolate_property($TextureProgress, "value", $TextureProgress.value, current_hp, .6)
	$Tween.interpolate_property($TextureProgress, "max_value", $TextureProgress.max_value, max_hp, .6)
	$Tween.start()


func _on_TextureProgress_value_changed(_value):
	pass
	#$HPCount.text = str(value, "/", $TextureProgress.max_value)

func set_hp_display(current_hp, max_hp):
	$HPCount.text = str(current_hp, "/", max_hp)

func change_status():
	# TODO Remove this: momentary fix
	for child in $StatusList.get_children():
		child.queue_free()
	yield(get_tree().create_timer(.01), "timeout")
	
	for status in combatant.get_status():
		
		# Remove status if duration is over
		if status.turn_duration == 0:
			continue
		var new_status_icon = status_icon_reference.instance()
		new_status_icon.init(status.get_description(), status.icon_texture)
		$StatusList.add_child(new_status_icon)

func get_status_icon(status):
	for child in $StatusList.get_children():
		if child.status_type == status.status_type:
			return child
	return null
