extends Position2D
tool

# ID Used to recognize the combatant from Database.gd
export (String) var enemy_code setget change_anim

func _ready():
	if enemy_code != "":
		print("test")
		return
	if (Database.combatant_data.has(enemy_code)):
		var anim_combatant = Database.combatant_data[enemy_code].animations.instance()
		anim_combatant.scale.x = -anim_combatant.scale.x
		add_child(anim_combatant)
	

func change_anim(new_value):
	enemy_code = new_value
	if Database.combatant_data.has(enemy_code) && get_child_count() == 0:
		var anim_combatant = Database.combatant_data[enemy_code].animations.instance()
		anim_combatant.scale.x = -anim_combatant.scale.x
		add_child(anim_combatant)
	else:
		for child in get_children():
			child.queue_free()
