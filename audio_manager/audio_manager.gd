extends Node

const SUCCESS: AudioStreamWAV = preload("res://audio_manager/success.wav")
const FAIL: AudioStreamWAV = preload("res://audio_manager/fail.wav")
const GAME_OVER: AudioStreamWAV = preload("res://audio_manager/game_over.wav")

@onready var audioplayer_sfx: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var audioplayer_music: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

func _ready() -> void:
	add_child(audioplayer_sfx)
	audioplayer_sfx.bus = "SFX"
	add_child(audioplayer_music)
	audioplayer_music.bus = "Music"

func play_sound(sound: AudioStreamWAV) -> void:
	audioplayer_sfx.stream = sound
	audioplayer_sfx.play()

func change_volume_db(new_volume_db: float, bus: String):
	match bus:
		"SFX":
			audioplayer_sfx.volume_db = new_volume_db
		"Music":
			audioplayer_music.volume_db = new_volume_db
