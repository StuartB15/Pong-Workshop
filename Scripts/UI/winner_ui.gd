extends CanvasLayer # Tells the script what type of node it's under, providing you with node-specific functions and parameters

##===============================================================================================##
## WINNER UI SCREEN                                                                              ##
## I basically just repurposed my pause ui, swapped some things around and made it work          ##
## I definitely recommend reading that one first, I'll explain things there that I won't here.   ##
##                                                                                               ##
## The shader that provides the tiled splattering of digits in the background of this scene was  ##
## made by ProfesorShader and you can find it/them at:                                           ##
## https://godotshaders.com/shader/tiler-pseudo-splatter/                                        ##
##===============================================================================================##

##==========================================================================================##
## VARIABLE INITIALIZATION                                                                  ##
##==========================================================================================##

##==[Node References]=======================================##
@onready var title: Label = %Title
@onready var background: ColorRect = %Background
@onready var background_tiled1: ColorRect = %BackgroundTiled1 # You could totally refactor the shader to let you have multiple types of tiled images, I just didn't have time, know this is not peak code.
@onready var background_tiled2: ColorRect = %BackgroundTiled2
@onready var element_vbox: VBoxContainer = %VBoxContainer
@onready var black_screen: ColorRect = %BlackScreen # Covers the screen to help transition when the game restarts.

@onready var left_score_label: Label = %LeftScoreLabel
@onready var right_score_label: Label = %RightScoreLabel

##==[Runtime Variables]=====================================##
var title_mat: ShaderMaterial
var title_size: Vector2

var open_tween: Tween
var close_tween: Tween

var open: bool = false

##==========================================================================================##
## RUNTIME FUNCTIONS                                                                        ##
##==========================================================================================##
func _ready() -> void:
	Global.game_won.connect(_open_menu) # Connects the _open_menu function to the global signal that gets emitted when a player wins.
	
	element_vbox.hide()
	background.modulate.a = 0.0
	background_tiled1.modulate.a = 0.0
	background_tiled2.modulate.a = 0.0
	black_screen.modulate.a = 0.0
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu") and open: # If you pressed escape on the winning screen, I'm willing to bet you wanted to close the game :p
		get_tree().quit()

##==========================================================================================##
## INITIALIZED FUNCTIONS                                                                    ##
##==========================================================================================##
# Fun Fact #5. I usually keep my bog-standard functions above the runtimes ones like I do the variables, but I feel like having them first makes it a little easier to understand
func _open_menu(winner: String) -> void:
	show()
	element_vbox.show()
	open = true
	
	left_score_label.text = str(Global.score.x)
	right_score_label.text = str(Global.score.y)
	
	if Global.score.x > Global.score.y:
		left_score_label.set("theme_override_colors/font_color", Color.GOLD)
	else:
		right_score_label.set("theme_override_colors/font_color", Color.GOLD)
	
	PauseUi.can_pause = false # Stops the player from being able to open up the pause menu. I can access the variable here because I made the pause MENU SCENE itself global, meaning that you can open the pause menu from any scene (if there were more)
	
	title.text = winner + " WINS!"
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if open_tween: open_tween.kill()
	if close_tween: close_tween.kill()
	
	open_tween = create_tween().set_parallel(true)
	open_tween.tween_property(background, "modulate:a", 1.0, 0.3)
	open_tween.tween_property(background_tiled1, "modulate:a", 0.7, 0.3)
	open_tween.tween_property(background_tiled2, "modulate:a", 0.7, 0.3)
	

func _reload_game() -> void: # Basically a refactored _close_menu() from my pause ui
	open = false
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Hides the mouse again in its final moments.
	
	if open_tween: open_tween.kill()
	if close_tween: close_tween.kill()
	
	close_tween = create_tween()
	close_tween.tween_property(black_screen, "modulate:a", 1.0, 0.5)
	
	await close_tween.finished         # Waits for the transition (tween) to finish before continuing.
	Global.score = Vector2i.ZERO       # Since the global script is global (shocker) when we reload the main scene of the game its variables don't reset, resetting them here.
	
	await get_tree().process_frame     # For some reason that I'm not smart enough to understand, whenever I try to reload/load a scene without waiting for the next process frame to finish it tweaks out and doesn't look as polished.
	get_tree().reload_current_scene() # Reloads the current scene tree.

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_restart_button_pressed() -> void:
	_reload_game()
