extends Node2D

@onready var timer: Timer = $Timer
@onready var time_bar: TextureProgressBar = $CanvasLayer/TimeBar

signal timer_expired

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_bar.value = ((timer.time_left / timer.wait_time) * 100)
	
func start_timer(limit: int) -> void:
	timer.wait_time = limit
	var tween = get_tree().create_tween()
	tween.tween_property(time_bar, "value", 100, 1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func(): timer.start())

func stop_timer() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	timer_expired.emit()
