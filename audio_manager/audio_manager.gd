extends Node

const SUCCESS: AudioStreamWAV = preload("res://audio_manager/success.wav")
const FAIL: AudioStreamWAV = preload("res://audio_manager/fail.wav")
const GAME_OVER: AudioStreamWAV = preload("res://audio_manager/game_over.wav")
const SELECTED : AudioStreamWAV = preload("res://audio_manager/selected.wav")
const OPENING : AudioStreamWAV = preload("res://audio_manager/opening.wav")
const CLOSING : AudioStreamWAV = preload("res://audio_manager/closing.wav")
const ADJUSTED : AudioStreamWAV = preload("res://audio_manager/adjusted.wav")
const BONUSGAME_BY_WOLFGANG_UNDERSCORE__ON_OPENGAMEART : AudioStreamWAV = preload("res://audio_manager/bonusgame_by_wolfgang(underscore)_on_opengameart.wav")
const COUNTDOWN_COUNTING : AudioStreamWAV = preload("res://audio_manager/countdown_counting.wav")
const COUNTDOWN_DONE : AudioStreamWAV = preload("res://audio_manager/countdown_done.wav")

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
	await audioplayer_sfx.finished
	audioplayer_sfx.stop()
	
func play_music(sound: AudioStreamWAV) -> void:
	audioplayer_music.stream = sound
	audioplayer_music.play()
	
func stop_music() -> void:
	audioplayer_music.stop()

func change_volume_db(new_volume_db: float, bus: String):
	match bus:
		"SFX":
			audioplayer_sfx.volume_db = new_volume_db
		"Music":
			audioplayer_music.volume_db = new_volume_db
