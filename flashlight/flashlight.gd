extends PointLight2D

# Attach the flashlight to the cursor
func _process(delta):
	position = get_viewport().get_mouse_position()
