extends CanvasLayer # Tells the script what type of node it's under, providing you with node-specific functions and parameters

##==========================================================================================##
## VARIABLE INITIALIZATION                                                                  ##
##==========================================================================================##

##==[Node References]=======================================##
# Initializes variables pointing to the various child nodes that we need as soon as all children have loaded in.
@onready var background: ColorRect = %Background
@onready var element_vbox: VBoxContainer = %VBoxContainer   # Vertical Box Container, I use it to store and sort the ui elements. (See nodes)

##==[Runtime Variables]=====================================##
var can_pause: bool = true
var open: bool = false

var title_mat: ShaderMaterial
var title_size: Vector2

var open_tween: Tween
var close_tween: Tween

##==========================================================================================##
## RUNTIME FUNCTIONS                                                                        ##
##==========================================================================================##
# This runs as soon as all children nodes have finished loading in.
func _ready() -> void:
	element_vbox.hide()
	background.modulate.a = 0.0 # Makes the background fully transparent

# Runs any time the game recieves an input from the player
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		if not open and can_pause:         # If the pause menu isn't open and the player has the ability to pause, it opens the menu and pauses.
			_open_menu()
		else:                             # If the menu is already open, pressed the button again will close it.
			_close_menu()

##==========================================================================================##
## INITIALIZED FUNCTIONS                                                                    ##
##==========================================================================================##

# A function I wrote to actually handle all of the stuff that needs to happen when you open the menu, keeps things neat.
func _open_menu() -> void:
	element_vbox.show()
	open = true
	get_tree().paused = true         #get_tree() is basically the whole game (The heirarchy is the tree)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE    # Makes the mouse free and visible.
	
	if open_tween: open_tween.kill()           # Tweens are essentially animations of properties over time, allows you to smooth things.
	if close_tween: close_tween.kill()         # Here I'm making sure that there are no active transitions (tweens) before starting new ones.
	
	open_tween = create_tween()                                     # Creates a new tween object under the variable
	open_tween.tween_property(background, "modulate:a", 1.0, 0.07)  # The parameters (The object, the property, the new value of the property, duration)
	
# Handles all of the closing stuff.
func _close_menu() -> void:
	element_vbox.hide()
	open = false
	get_tree().paused = false
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED   # Sets the mouse mode to captured so it is no longer movable nor visible.
	
	if open_tween: open_tween.kill()
	if close_tween: close_tween.kill()
	
	close_tween = create_tween()
	close_tween.tween_property(background, "modulate:a", 0.0, 0.07)

##==========================================================================================##
## SIGNAL CONNECTIONS                                                                       ##
##==========================================================================================##

# Fun Fact #1. I spent way longer working on a fancy loading screen for a workshop game than I should've.

func _on_resume_button_pressed() -> void: # Connected to the resume button node's pressed signal, runs whenever the button is pressed.
	if open:
		_close_menu()


func _on_exit_button_pressed() -> void: # Connected to the exit button node's pressed signal, runs whenever the button is pressed.
	get_tree().quit() # Exits the game.
