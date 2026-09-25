extends CharacterBody2D  # I've done this exact same comment for literally every other script than this one, I'm sure you can figure it out.

##==========================================================================================##
## VARIABLE INITIALIZATION                                                                  ##
##==========================================================================================##

##==[Node References]=======================================##
@onready var sprite: Sprite2D = %Sprite2D

# Random enum initialization right here, couldn't decide where to put it.
enum PaddleTypes { PLAYER_TWO, CPU } # Creates a enum type with these two different values.

##==[Exported Variables]=======================================##
@export var current_type: PaddleTypes = PaddleTypes.PLAYER_TWO # I can create a variable with the type set to the enum I initialized and set its values as so.
@export var move_speed: float = 400.0

# Values that tweak the CPU
@export var cpu_acceleration: float = 300.0     # The weight used to determine how quickly the CPU can get to the point it's trying to get to (Higher = Faster)
@export var cpu_deadzone: float = 4.0           # Deadzone so that the CPU doesn't tweak out when it approaches the place it's trying to go. (Higher = Less Accurate)
@export var cpu_slow_zone: float = 40.0         # The zone in which the CPU moves smoother/slows down etc (Higher = Slower more of the time.)

##==[Runtime Variables]=====================================##
var locked_x_pos: float    # Used later to make sure that the paddle can't move left or right at all


##==========================================================================================##
## RUNTIME FUNCTIONS                                                                        ##
##==========================================================================================##
# Fun Fact 7. Did you know there are fun facts like this in every single script (not including shaders). The number is the order I commented these files in.

func _ready() -> void:
	locked_x_pos = global_position.x     # Saves the paddle's global x position whenever it loads in.

# Runs every physics frame
func _physics_process(delta: float) -> void:
	match current_type:                                                       # With enums you can do this fancy little if statement alternative, if you've read this far I assume you know how those work.
		PaddleTypes.PLAYER_TWO:                                               # Runs if the type of the paddle is set to PLAYER_TWO
			var move_direction: float = Input.get_axis("P2_UP", "P2_DOWN")    # This takes the two inputs possible for player two, and depending on what's pressed, turns out a float. In this orientation, P2_UP = -1.0 and P2_DOWN = 1.0. Though if you press both or either it returns zero! Very useful for things like this.
	
			if move_direction:                                   # Runs if the direction it gets back is not zero.
				velocity.y = move_direction * move_speed         # Sets the velocity on the y axis of the paddle to the direction we got from the axis * the move speed.
			else:
				velocity.y = move_toward(velocity.y, 0.0, move_speed)   # If the axis is zero then we want to stop the paddle by pushing its velocity on the y axis down to zero. move_toward is useful when you want smooth incremental changes in values. Hover over it to see explanations about the parameters.
				
		PaddleTypes.CPU:                                                      # Runs if the type of the paddle is set to CPU. The cpu works by settings a y axis position goal for itself and then applying velocity based upon that.
			var goal_y: float = 540.0                                # Initializes the goal, I have it set to 540 because that's the middle of the visible y axis (camera is 1920x1080, 1080 being the height so half of that is 540)
			if Global.ball_pos != Vector2.ZERO:                      # If the ball is in play, it updates Global.ball_pos, but if it isn't there/dies then it gets set to 0.0.
				goal_y = Global.ball_pos.y                           # Sets the CPU's goal to be the height that the ball is at, but since this assignment ONLY runs if the ball's position is 0.0, it only changes goal_y if the ball is in play. This means that when the ball is gone/dead the CPU's goal will always be to return to the middle of the screen.
	
			var diff: float = goal_y - global_position.y             # Finds the distance between itself and where it wants to be.
			var goal_velocity: float = 0.0                           # Now we create a variable to store the CPU's goal velocity
	
			if abs(diff) > cpu_deadzone:                                                   # If the CPU's distance (abs = absolute value - always positive) to its goal is greater than the deadzone, it will try to change its velocity. This is doing a similar thing as the goal_y assignment though where because of this condition, if it's within the deadzone already, it won't keep trying to move. (goal_velocity stays at 0.0)
				var speed_scale: float = clamp(abs(diff) / cpu_slow_zone, 0.0, 1.0)        # Calculates a number (clamped = forced between 0.0 and 1.0) to help judge how fast the CPU can gain velocity.
				goal_velocity = sign(diff) * (move_speed*1.5) * speed_scale                # Sign returns either 1.0, -1.0, or 0.0 depending on the sign of the number fed into it. So this is basically calculating the speed of the paddle * our speed scale, and then multiplying it by the direction it needs to go.
	
			velocity.y = lerp(velocity.y, goal_velocity, 1.0 - exp(-cpu_acceleration * delta))   # Lerp is similar to move_toward() except it's exponential, it changes values incrementally but by using a weight it smooths it out a bit more resembling different easing styles.

	move_and_slide()    # This makes the magic happen, when in _physics_process it does pretty much what it says it does, applying the velocity of the paddle as movement and speed.
	
	global_position.x = locked_x_pos   # By setting the paddle's global x position (left and right) to the value we found when the scene first loaded AFTER running move and slide, we ensure that it never moves from that one x value that it started at. Nobody likes horizontal pong.

##==========================================================================================##
## INITIALIZED FUNCTIONS                                                                    ##
##==========================================================================================##

func blink() -> void:                               # This function is called externally, by the ball when it collides with the paddle, swapping the sprite.
	if sprite.frame == 0:                           # The sprite is made up a couple images I made, pushed together into a sprite sheet. In the sprite's node settings you can tell Godot how many frames your image is made up of. If it's on frame zero this executes.
		sprite.frame = 1                            # Changes the sprite's image to image 2 (1 because indexing starts at 0)
		await get_tree().create_timer(0.1).timeout  # Creates a timer and waits for it to finish
		sprite.frame = 0                            # After 0.1 second it switches back to the original sprite. This makes the blink effect.
