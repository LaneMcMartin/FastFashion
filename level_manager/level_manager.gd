extends Node2D
class_name LevelManager

@export var transition : Transition

@onready var selector: Selector = $CanvasLayer/LevelUI/Selector
@onready var npc_handler: NPCHandler = $NPCHandler
@onready var time_handler: Node2D = $TimeHandler
@onready var ui_notifications = $CanvasLayer/LevelUI/UINotifications
@onready var level_ui = $CanvasLayer/LevelUI

signal game_ended

# Level and Difficulty
var level_difficulty: int = 1
var level_quantity: int = 5

# Targets
var target_clothing_type: CompositeSprite.TYPE = CompositeSprite.TYPE.HAT
var target_index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals
	selector.connect("item_selected", _item_selected)
	
	# Make invisible
	hide_all()


func game_start() -> void:
	# Reset parameters
	level_difficulty = 1
	level_quantity = 10
	
	# Make visible
	show_all()
	
	# Start the level
	level_start()


func level_start() -> void:
	# TODO: Set the level difficulty
	# TODO: Set the level variant
	
	# Set the timer
	time_handler.start_timer(5)
	
	# Set the sublevel (via the clothing object)
	var random_clothing = randi_range(0, CompositeSprite.TYPE.size() + 1)
	match random_clothing:
		0:
			target_clothing_type = CompositeSprite.TYPE.HAT
		1:
			target_clothing_type = CompositeSprite.TYPE.SHIRT
		2:
			target_clothing_type = CompositeSprite.TYPE.PANTS
		#3:
			#target_clothing_type = CompositeSprite.TYPE.BODY
	
	# Spawn NPCs
	npc_handler.spawn_characters(level_quantity, 3.0, 30.0, target_clothing_type, level_difficulty)
	
	# Get the most common clothing item
	target_index = npc_handler.get_most_common_index()
	
	# Update the selector with the target clothing type
	selector.update(target_clothing_type)
	
	# Show selector
	selector.show_selector()
	
	
func level_end() -> void:
	# Stop timer
	time_handler.stop_timer()
	
	# Dismiss NPCs
	npc_handler.dismiss_and_despawn()
	
	# Hide selector
	selector.hide_selector()
	
	
func game_end() -> void:
	await level_end()
	await ui_notifications.print_text("GAME OVER!")
	await hide_all()
	transition.close()
	await transition.transition_completed
	game_ended.emit()


func _item_selected(selected_item: int) -> void:
	# Check if the selected item is a match to the most common item
	if (selected_item == target_index):
		print("True!")
		AudioManager.play_sound(AudioManager.SUCCESS)
		level_quantity += 1
		level_difficulty += 0.25
		level_end()
		await get_tree().create_timer(1.0).timeout
		level_start()
	else:
		print("False!")
		AudioManager.play_sound(AudioManager.FAIL)
		game_end()


func _on_time_handler_timer_expired() -> void:
	game_end()


func _on_title_screen_start_pressed():
	transition.open()
	game_start()

func hide_all() -> void:
	hide()
	level_ui.hide_ui()
	time_handler.hide_timebar()
	
func show_all() -> void:
	show()
	level_ui.show_ui()
	time_handler.show_timebar()
