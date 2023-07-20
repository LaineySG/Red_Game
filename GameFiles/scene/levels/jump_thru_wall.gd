extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_down"):
		get_node("CollisionShape2D").one_way_collision_margin = 0
	else:
		get_node("CollisionShape2D").one_way_collision_margin = 1
