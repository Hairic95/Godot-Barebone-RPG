extends Control

var battle_icon_reference = load("res://src/ui/BattleIcon.tscn")

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

func change_icons():
	
	for child in $IconList.get_children():
		child.queue_free()
	yield(get_tree().create_timer(.01), "timeout")
	
	# Update all buff icons
	for buff in combatant.get_buffs():
		# Remove status if duration is over
		if buff.turn_duration == 0:
			continue
		var new_buff_icon = battle_icon_reference.instance()
		new_buff_icon.init(buff.get_description(), buff.icon_texture)
		$IconList.add_child(new_buff_icon)
	
	# Update all status icons
	for status in combatant.get_status():
		# Remove status if duration is over
		if status.turn_duration == 0:
			continue
		var new_status_icon = battle_icon_reference.instance()
		new_status_icon.init(status.get_description(), status.icon_texture)
		$IconList.add_child(new_status_icon)
	
	

