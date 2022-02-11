extends Node

var scenes = {
	"battle_scene": load("res://src/scenes/BattleScene.tscn")
}

func _ready():
	_load_scene("battle_scene")

func _load_scene(new_scene_key):
	if scenes.has(new_scene_key):
		for scene in $CurrentScene.get_children():
			scene.queue_free()
		var new_scene = scenes[new_scene_key].instance()
		new_scene.connect("change_scene", self, "_load_scene")
		$CurrentScene.add_child(new_scene)
