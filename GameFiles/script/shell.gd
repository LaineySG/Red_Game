extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Timer").start() # Replace with function body.
	get_node("AnimatedSprite2D").play("init")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.3)
	await get_tree().create_timer(0.3).timeout
	queue_free()
