extends AnimatedSprite2D

var fumble = false

# Called when the node enters the scene tree for the first time.
func _ready():
	play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	
	
	

