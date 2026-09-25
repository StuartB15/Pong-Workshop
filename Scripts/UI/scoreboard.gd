extends CanvasLayer # Tells the script what type of node it's under, providing you with node-specific functions and parameters

##==========================================================================================##
## VARIABLE INITIALIZATION                                                                  ##
##==========================================================================================##

##==[Node References]=======================================##
# Initializes variables pointing to the various child nodes that we need as soon as all children of whatever node this is under have loaded in.
@onready var left_score_label: Label = %LeftScoreLabel
@onready var right_score_label: Label = %RightScoreLabel

@onready var left_p_emitter: CPUParticles2D = %LeftChangeParticles
@onready var right_p_emitter: CPUParticles2D = %RightChangeParticles

##==========================================================================================##
## RUNTIME FUNCTIONS                                                                        ##
##==========================================================================================##
# This runs as soon as all children nodes have finished loading in.
func _ready() -> void:
	Global.score_changed.connect(_on_score_changed)   # If you check the global script you'll see where it makes the signal this is referencing. ".connect" allows you to make a function run whenever the signal detects an emission,
	left_score_label.text = str(Global.score.x)      # Changes the text of our score labels to the initial value when the game first starts.
	right_score_label.text = str(Global.score.y)

##==========================================================================================##
## SIGNAL CONNECTIONS                                                                       ##
##==========================================================================================##

# Remember that connect in _ready()? This is the function it connected the signal to.
func _on_score_changed(side: String) -> void:
	if side == "LEFT":                                   # If the lefthand player/cpu's score changes. This updates the text's values and runs effects.
		left_score_label.text = str(Global.score.x)
		
		left_p_emitter.emitting = true                                    # Makes the particle emitter in question start emitting. It has the value "one_shot" so there's no need to turn it off.
		
		# Makes the color flicker for a sec when when the score changes.
		left_score_label.set("theme_override_colors/font_color", Color.GREEN)    # Changes the color of the text label
		await get_tree().create_timer(0.4).timeout                               # Creates a timer and the await, basically pauses here and waits until said timer has timed out ".timeout"
		left_score_label.set("theme_override_colors/font_color", Color.WHITE)
		
		if Global.score.x+1 == Global.score_to_win:                               # Runs some other effects if the left side is one away from winning.
			left_score_label.set("theme_override_colors/font_color", Color.GOLD)
			left_p_emitter.color = Color.DARK_GOLDENROD
			left_p_emitter.one_shot = false
			left_p_emitter.explosiveness = 0.0               # Fun Fact #3. You can hover over properties like this to get a better explanation than I could give.
			left_p_emitter.emitting = true
			
	elif side == "RIGHT":                                 # Does the same thing as the left side when the score changes, but specifically for the right-hand nodes. There's probably a better way to do this where you only need one function you reuse for both sides but I don't have that kind of time.
		right_score_label.text = str(Global.score.y)
		
		right_p_emitter.emitting = true
		
		right_score_label.set("theme_override_colors/font_color", Color.GREEN)
		await get_tree().create_timer(0.4).timeout
		right_score_label.set("theme_override_colors/font_color", Color.WHITE)
		
		if Global.score.y+1 == Global.score_to_win:
			right_score_label.set("theme_override_colors/font_color", Color.GOLD)
			right_p_emitter.color = Color.DARK_GOLDENROD
			right_p_emitter.one_shot = false
			right_p_emitter.explosiveness = 0.0
			right_p_emitter.emitting = true
	
	else: # If the parameter passed on by the signal to tell the scoreboard which side to change doesn't match either side, mostly a precaution.
		push_error("Side: ", side, ", does not exist.")
