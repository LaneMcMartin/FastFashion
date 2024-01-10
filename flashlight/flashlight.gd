extends PointLight2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Attach the flashlight to the cursor
func _process(delta):
	position = get_viewport().get_mouse_position()

func start_pulse():
	animation_player.play("pulse")
	
func stop_pulse():
	animation_player.pause()
