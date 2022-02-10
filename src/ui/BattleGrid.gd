extends GridContainer


export (String, "right", "left") var grid_side = "left"
func _ready():
	
	var x = 1 if grid_side == "left" else 4
	var y = 1
	for grid_button in get_children():
		grid_button.grid_position = Vector2(x, y)
		
		if grid_side == "left":
			if x == 4:
				x = 1
				y += 1
			else:
				x += 1
		else:
			if x == 1:
				x = 4
				y += 1
			else:
				x -= 1
		

