class_name TitleScreen
extends Control

@export var transition : Transition

@onready var title : TextureRect = $VBoxContainer/MarginContainerTitle/Title
@onready var start : TextureRect = $VBoxContainer/HBoxContainer/MarginContainerStart/Start
@onready var options : TextureRect = $VBoxContainer/HBoxContainer/MarginContainerStart2/Options
@onready var animation_player = $AnimationPlayer

signal start_pressed
signal options_pressed

func _ready():
	#animation_player.play("enter", -1, 1.5)
	pass

func _process(delta):
	pass
	
	
func rotate_animation(to_animate: TextureRect):
	pass


func _on_start_gui_input(event):
	if event.is_action_pressed("CLICK"):
		print("whee start!")
		#animation_player.play("enter", -1, -1.5, true)
		transition.close()
		start_pressed.emit()


func _on_options_gui_input(event):
	if event.is_action_pressed("CLICK"):
		print("whee option!")
		#animation_player.play("enter", -1, -1.5, true)
		transition.close()
		options_pressed.emit()
		
