extends Control

@onready var label = $Text
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	visible = false

# This node can be used to display text that slides across the screen
func print_text(input_string: String) -> void:
	label.text = input_string
	visible = true
	animation_player.play("slide")
