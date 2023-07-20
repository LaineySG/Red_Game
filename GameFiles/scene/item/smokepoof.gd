extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	get_node("AnimatedSprite2D").play("poof")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animated_sprite_2d_animation_finished():
	self.queue_free()
