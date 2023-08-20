extends Area2D

var bodies = []
var given = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.meringues += 1
	var rise = get_tree().create_tween()
	rise.tween_property(self,"position",position - Vector2(0,90), 2.0)

func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_timer_timeout():
	get_node("Sprite2D").visible = false
	get_node("AnimatedSprite2D").visible = true
