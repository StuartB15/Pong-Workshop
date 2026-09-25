extends Node2D

@onready var left_paddle: CharacterBody2D = %WorkshopPaddle
@onready var right_paddle: CharacterBody2D = %OpponentPaddle
@onready var ball_spawn: Node2D = %BallSpawn

@export var ball_scene: PackedScene

@export var score_to_win: int = 5
@export var time_between_rounds: float = 2.0

var current_ball: CharacterBody2D

var winner: String

func _ready() -> void:
	Global.score_to_win = score_to_win
	_start_round()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _start_round() -> void:
	if current_ball == null:
		current_ball = ball_scene.instantiate()
		current_ball.global_position = ball_spawn.global_position
		add_child(current_ball)
		
		
		var wait_time: float = randf_range(1.5, 3.0)
		await get_tree().create_timer(wait_time).timeout
		
		current_ball.launch()


func _on_left_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		current_ball.set_physics_process(false)
		current_ball.queue_free()
		current_ball = null
		Global.ball_pos = Vector2.ZERO
		
		
		Global.score.y += 1
		Global.score_changed.emit("RIGHT")
		if Global.score.y >= score_to_win:
			Global.game_won.emit("RIGHT")
			
		else:
			await get_tree().create_timer(time_between_rounds).timeout
			_start_round()
	


func _on_right_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		current_ball.set_physics_process(false)
		current_ball.queue_free()
		current_ball = null
		Global.ball_pos = Vector2.ZERO
		
		
		Global.score.x += 1
		Global.score_changed.emit("LEFT")
		if Global.score.x >= score_to_win:
			Global.game_won.emit("LEFT")
		else:
			await get_tree().create_timer(time_between_rounds).timeout
			_start_round()
