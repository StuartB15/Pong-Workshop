extends Node

func _input(event: InputEvent) -> void:
	if event.is_action("Fullscreen"):
		var window_state = DisplayServer.window_get_mode()
		
		if window_state == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
