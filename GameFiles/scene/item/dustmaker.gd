extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_dust(switch):
	if switch == true:
		get_node("dustmaker").emitting = true
	else:
		get_node("dustmaker").emitting = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
