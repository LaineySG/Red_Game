extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 2.5)
	await get_tree().create_timer(2.6).timeout
	queue_free()
	#get_node("wireholder").linear_velocity.x = 0
	#get_node("wireholder").linear_velocity.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#get_node("wireholder").linear_velocity.x = 0
	#get_node("wireholder").linear_velocity.y = 0
	#get_node("wireholder").velocity.x = get_parent().velocity.x
	#get_node("wireholder").velocity.y = get_parent().velocity.y
	pass
