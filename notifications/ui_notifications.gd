extends Control

@onready var label = $Text
@onready var animation_player = $AnimationPlayer

# This node can be used to display text that slides across the screen
func print_text(input_string: String) -> void:
	label.text = input_string
	animation_player.play("slide")
