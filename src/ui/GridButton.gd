extends TextureButton

var grid_position: Vector2 = Vector2.ZERO
var player = Constants.PlayerId_Player

func _ready():
	pass

func init(grid_position, player):
	self.grid_position = grid_position
	self.player = player

func get_combatant_position():
	return $CombatantPosition.global_position


func _on_GridButton_pressed():
	EventBus.emit_signal("battle_grid_pressed", grid_position, player)
