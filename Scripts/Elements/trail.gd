extends Line2D # Tells the script what type of node it's under, providing you with node-specific functions and parameters

##==========================================================================================##
## VARIABLE INITIALIZATION                                                                  ##
##==========================================================================================##

##==[Exported Variables]=======================================##
@export var default_trail_color: Color # Exporting variables makes them accessible in the inspector.
@export var trail_length: float = 70

var point: Vector2 = Vector2.ZERO

##==========================================================================================##
## RUNTIME FUNCTIONS                                                                        ##
##==========================================================================================##

func _ready() -> void:
	change_color(default_trail_color)

func _process(_delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	
	point = get_parent().global_position
	
	add_point(point)
	while get_point_count() > trail_length:
		remove_point(0)

##==========================================================================================##
## INITIALIZED FUNCTIONS                                                                    ##
##==========================================================================================##

func change_color(color: Color) -> void:
	gradient.set_color(1, color) # parameter 1 is the point on the gradient.

# Fun Fact #6. I learned how to do this for THIS workshop. Probably not the best way to do it though. I mostly work in 3D so now going back to 2D is lowk a treat
