extends AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready():
	play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	
	
	if Input.is_action_just_pressed("ui_left_click"):
		play("Fire")
