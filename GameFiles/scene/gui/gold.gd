extends AnimatedSprite2D

var shine = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("starting")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print("test1")
	if !shine:
		shine = true
		await get_tree().create_timer(5.0).timeout
		play("default")
		print("test")
