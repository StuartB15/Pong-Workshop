extends Label # Tells the script what type of node it's under, providing you with node-specific functions and parameters

##==========================================================================================##
## This script is a very modified apply script to a shader made by Siekwie.                 ##
## You can find it/them on GodotShaders.com at:                                             ##
## https://godotshaders.com/shader/universal-text-shine-bitmap-font-compatible-360-angle/   ##
##==========================================================================================##

# Fun Fact #4. The community has some incredible shaders that usually get used without credit, they deserve more credit.

@export var shine_wait: float = 3.0 # Exporting the variable allows you to change it in the inspector.

func _shine() -> void:
	material.set_shader_parameter("shine_progress", 0.0)
	
	var s_tween := create_tween()
	s_tween.tween_property(material, "shader_parameter/shine_progress", 1.0, 0.7)

func _ready():
	material.set_shader_parameter("text_size", size)
	
	resized.connect(func():
		if material:
			material.set_shader_parameter("text_size", size)
	)
	
	# I basically made it to where it shines on a loop forever, creating the timer within the script so you can drop the text_shine shader on pretty much any text.
	var shine_timer := Timer.new()
	add_child(shine_timer)
	
	shine_timer.wait_time = shine_wait
	shine_timer.one_shot = false
	
	shine_timer.timeout.connect(_shine)
	shine_timer.start()
