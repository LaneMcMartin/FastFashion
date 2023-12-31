class_name Transition
extends Control

@onready var color_rect = $ColorRect

signal transition_completed

func open() -> void:
	color_rect.material["shader_parameter/progress"] = 1.0
	var tween : Tween = create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/progress", 0, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(emit_completed_signal)
	
func close() -> void:
	color_rect.material["shader_parameter/progress"] = 0.0
	var tween : Tween = create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/progress", 1, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(emit_completed_signal)

func emit_completed_signal() -> void:
	transition_completed.emit()
