extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.play("Neutral")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	

