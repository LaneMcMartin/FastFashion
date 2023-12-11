extends Node

const SUCCESS: AudioStreamWAV = preload("res://audio_manager/success.wav")
const FAIL: AudioStreamWAV = preload("res://audio_manager/fail.wav")
const GAME_OVER: AudioStreamWAV = preload("res://audio_manager/game_over.wav")

@onready var audioplayer: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

func _ready() -> void:
	add_child(audioplayer)

func play_sound(sound: AudioStreamWAV) -> void:
	audioplayer.stream = sound
	audioplayer.play()
