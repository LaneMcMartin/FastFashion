extends Control

@onready var selector = $Selector
@onready var ui_notifications = $UINotifications

func _ready() -> void:
	hide_ui()
	
func hide_ui() -> void:
	selector.hide_selector()
	ui_notifications.hide()
	
func show_ui() -> void:
	selector.show_selector()
	ui_notifications.show()
