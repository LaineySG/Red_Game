extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#play("idle")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible:
		play("poof")
		
