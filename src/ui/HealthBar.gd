extends Control

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
