extends CanvasLayer

@onready var background: ColorRect = %Background

var open := false

func _input(event: InputEvent) -> void:
	if event.is_action("Menu"):
		if not open:
			_open_menu()
		else:
			_close_menu()

func _open_menu() -> void:
	pass

func _close_menu() -> void:
	pass
