extends CharacterBody2D

@onready var sprite: Sprite2D = %Sprite2D

@export var move_speed: float = 400.0

var locked_x_pos: float

func _ready() -> void:
	locked_x_pos = global_position.x

func _physics_process(_delta: float) -> void:
	var move_direction: float = Input.get_axis("P1_UP", "P1_DOWN")
	
	if move_direction:
		velocity.y = move_direction * move_speed
	else:
		velocity.y = 0.0
	
	move_and_slide()
	
	global_position.x = locked_x_pos

func blink() -> void:
	if sprite.frame == 0:
		sprite.frame = 1
		await get_tree().create_timer(0.1).timeout
		sprite.frame = 0
