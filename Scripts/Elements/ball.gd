extends CharacterBody2D # Tells the script what type of node it's under, providing you with node-specific functions and parameters

@onready var trail: Line2D = %Trail2D
@onready var sprite: Sprite2D = %Sprite2D
@onready var zero_p_emitter: CPUParticles2D = %ZeroParticles
@onready var one_p_emitter: CPUParticles2D = %OneParticles
@onready var debounce_timer: Timer = %DebounceTimer


@export var speed: float = 600.0

var velocity_stage: Vector2

var can_bounce: bool = true


func launch() -> void:
	var launch_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	velocity = launch_direction * speed

func _physics_process(delta: float) -> void:
	Global.ball_pos = global_position
	
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision and can_bounce:
		var normal: Vector2 = collision.get_normal()
		can_bounce = false
		debounce_timer.start()
		
		if sprite.frame == 0:
			sprite.frame = 1
			one_p_emitter.emitting = true
			trail.change_color(Color.GREEN)
		else:
			sprite.frame = 0
			zero_p_emitter.emitting = true
			trail.change_color(Color.WHITE)
		
		velocity = velocity.bounce(normal)
		velocity.x += speed*25.0/velocity.x
		
		var collider = collision.get_collider()
		if collider and collider.is_in_group("Paddle"):
			if collider.has_method("blink"):
				collider.blink()
			
			var tangent: Vector2 = normal.orthogonal()
			
			var collider_sliding_speed: float = collider.velocity.dot(tangent)
			
			var friction_influence: float = 0.45
			velocity += tangent * collider_sliding_speed * friction_influence
	


func _on_debounce_timer_timeout() -> void:
	can_bounce = true
