extends Control


func _on_return_gui_input(event):
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value):
	AudioManager.change_volume_db(linear_to_db(value), "SFX")


func _on_music_slider_value_changed(value):
	AudioManager.change_volume_db(linear_to_db(value), "Music")
