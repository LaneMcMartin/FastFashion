extends Node2D
class_name LevelManager

@export var transition : Transition

@onready var selector: Selector = $CanvasLayer/LevelUI/Selector
@onready var npc_handler: NPCHandler = $NPCHandler
@onready var time_handler: Node2D = $TimeHandler
@onready var ui_notifications = $CanvasLayer/LevelUI/UINotifications
@onready var level_ui = $CanvasLayer/LevelUI
@onready var countdown: Control = $CanvasLayer/LevelUI/Countdown
@onready var ambient_light: DirectionalLight2D = $AmbientLight
@onready var flashlight: PointLight2D = $Flashlight

signal game_ended(score : int)

# Level and Difficulty
var level_difficulty : int = 0
var level_quantity : int = 0
var correct_guesses: int = 0

# Targets
var target_clothing_type: CompositeSprite.TYPE = CompositeSprite.TYPE.HAT
var target_index : int = 0

# Time
enum TIME_OF_DAY {DAY, NIGHT}
var current_time : TIME_OF_DAY = TIME_OF_DAY.DAY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals
	selector.connect("item_selected", _item_selected)
	
	# Make invisible
	hide_all()


func game_start() -> void:
	# Reset parameters
	level_difficulty = 1
	level_quantity = 5
	correct_guesses = 0
	
	# Countdown
	AudioManager.fade_music(3.0)
	await countdown.start_countdown()
	
	# Show all
	show_all()
	
	# Play music
	AudioManager.play_music(AudioManager.BONUSGAME_BY_WOLFGANG_UNDERSCORE_ON_OPENGAMEART)
	
	# Start the level
	level_start()


func level_start() -> void:
	# Set the level difficulty
	level_difficulty += floor(correct_guesses / 10)
	
	# Set the level quantity
	level_quantity += 1
	
	# Set the time of day
	if ((correct_guesses + 1) % 4) == 0:
		toggle_time()
	
	# Set the timer
	time_handler.start_timer(7.5 - (correct_guesses * 0.075))
	
	# Set the sublevel (via the clothing object)
	var random_clothing = randi_range(0, CompositeSprite.TYPE.size() + 1)
	match random_clothing:
		0:
			target_clothing_type = CompositeSprite.TYPE.HAT
		1:
			target_clothing_type = CompositeSprite.TYPE.SHIRT
		2:
			target_clothing_type = CompositeSprite.TYPE.PANTS
	
	# Spawn NPCs
	npc_handler.spawn_characters(level_quantity, 3.0, 30.0, target_clothing_type, level_difficulty)
	
	# Get the most common clothing item
	target_index = npc_handler.get_most_common_index()
	
	# Update the selector with the target clothing type
	selector.update(target_clothing_type)
	
	# Show selector
	await selector.show_selector()
	
	
func level_end() -> void:
	# Stop timer
	time_handler.stop_timer()
	
	# Dismiss NPCs
	npc_handler.dismiss_and_despawn()
	
	# Hide selector
	await selector.hide_selector()
	
	
func game_end() -> void:
	await level_end()
	await ui_notifications.print_text("GAME OVER!")
	transition.close()
	AudioManager.play_sound(AudioManager.CLOSING)
	await transition.transition_completed
	AudioManager.stop_music()
	hide_all()
	game_ended.emit(correct_guesses)


func _item_selected(selected_item: int) -> void:
	# Check if the selected item is a match to the most common item
	if (selected_item == target_index):
		AudioManager.play_sound(AudioManager.SUCCESS)
		correct_guesses += 1
		level_end()
		await ui_notifications.print_text(str(correct_guesses))
		level_start()
	else:
		AudioManager.play_sound(AudioManager.GAME_OVER)
		game_end()


func _on_time_handler_timer_expired() -> void:
	AudioManager.play_sound(AudioManager.GAME_OVER)
	game_end()


func _on_title_screen_start_pressed():
	AudioManager.play_sound(AudioManager.OPENING)
	transition.open()
	show()
	set_day()
	await transition.transition_completed
	game_start()

func hide_all() -> void:
	hide()
	level_ui.hide_ui()
	time_handler.hide_timebar()
	
func show_all() -> void:
	show()
	level_ui.show_ui()
	time_handler.show_timebar()

func set_day() -> void:
	current_time = TIME_OF_DAY.DAY
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(ambient_light, "energy", 0, 1).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(flashlight, "scale", Vector2(0.01, 0.01), 1).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(flashlight, "energy", 0, 1).set_trans(Tween.TRANS_EXPO)
	tween.chain().tween_callback(flashlight.stop_pulse)

func set_night() -> void:
	current_time = TIME_OF_DAY.NIGHT
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(ambient_light, "energy", 1, 1).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(flashlight, "scale", Vector2(3, 3), 1).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(flashlight, "energy", 1.5, 1).set_trans(Tween.TRANS_EXPO)
	tween.chain().tween_callback(flashlight.start_pulse)

func toggle_time() -> void:
	match current_time:
		TIME_OF_DAY.DAY:
			set_night()
		TIME_OF_DAY.NIGHT:
			set_day()
