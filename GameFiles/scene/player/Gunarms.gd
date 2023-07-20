extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var children = get_node("Confettichildren").get_children()
	for i in children:
		if i.is_visible_in_tree() == false:
			i.queue_free()
