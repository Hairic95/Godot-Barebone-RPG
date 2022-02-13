extends Node

var effect_reference = load("res://src/entities/Effect.tscn")

var action_name = "Missing string"
var action_type = "physical"
var damage_percentage
var target = "enemy_single"

var max_uses
var current_uses

func _ready():
	pass

# Uses a dictionary value from the list action_data in Database.gd
func init(data):
	action_name = data.name
	target = data.target
	if (data.has("damage_percentage")):
		damage_percentage = data.damage_percentage
		
	if (data.has("max_uses")):
		max_uses = data.max_uses
		current_uses = max_uses
	else:
		max_uses = -1
		current_uses = -1
	
	# If the action has any effects, instanciate them
	if (data.has("effects")):
		for effect in data.effects:
			var new_effect = effect_reference.instance()
			new_effect.init(effect)
			$Effects.add_child(new_effect)
	
	# If the action has any effects, instanciate them
	if (data.has("self_effects")):
		for effect in data.self_effects:
			var new_effect = effect_reference.instance()
			new_effect.init(effect)
			$SelfEffects.add_child(new_effect)

func has_max_uses():
	return max_uses > 0

func get_effects():
	return $Effects.get_children()

func get_self_effects():
	return $SelfEffects.get_children()
