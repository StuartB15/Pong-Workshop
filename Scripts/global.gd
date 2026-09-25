extends Node # Tells the script what type of node it's under, providing you with node-specific functions and parameters

##==========================================================================================##
## GLOBAL SCRIPT                                                                            ##
## By adding this script under the menu: Project > Project Settings > Globals it becomes    ##
## accessible globally, and runs when the game launches. You'll find that you can reference ##
## it in other scripts by typing the name from the global menu. this one is "Global."       ##
##==========================================================================================##

##==[Signal Initializations]=======================================##
@warning_ignore("unused_signal")
signal game_won(winner: String) # If you don't know what a signal is I recommend looking it up, this line makes one.

@warning_ignore("unused_signal")
signal score_changed(side: String)

##==[Runtime Variable Initialization]=======================================##
var score_to_win: int 
var score: Vector2i
var ball_pos: Vector2

# Runs any time the game recieves an input from the player
# I feel like this one is fairly self explanatory on how it works.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fullscreen"):
		var window_state = DisplayServer.window_get_mode()
		
		if window_state == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# Fun Fact #2. This one is really boring.
