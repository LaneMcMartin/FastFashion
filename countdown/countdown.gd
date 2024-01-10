extends Control

const THREE = preload("res://countdown/three.tres")
const TWO = preload("res://countdown/two.tres")
const ONE = preload("res://countdown/one.tres")
const GO = preload("res://countdown/go.tres")

@onready var texture_rect: TextureRect = $TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Countdown and emit a signal when done
func start_countdown() -> void:
	show()
	texture_rect.texture = THREE
	AudioManager.play_sound(AudioManager.COUNTDOWN_COUNTING)
	await get_tree().create_timer(1.0).timeout
	texture_rect.texture = TWO
	AudioManager.play_sound(AudioManager.COUNTDOWN_COUNTING)
	await get_tree().create_timer(1.0).timeout
	texture_rect.texture = ONE
	AudioManager.play_sound(AudioManager.COUNTDOWN_COUNTING)
	await get_tree().create_timer(1.0).timeout
	texture_rect.texture = GO
	AudioManager.play_sound(AudioManager.COUNTDOWN_DONE)
	await get_tree().create_timer(1.0).timeout
	hide()
