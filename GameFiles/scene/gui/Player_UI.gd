extends CanvasLayer

var shine = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !shine:
		shine = true
		await get_tree().create_timer(15.0).timeout
		get_node("gold").play("default")
		shine = false
