extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var poofed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_and_slide()
	velocity.y += gravity * _delta

func add_on_exit():
	Game.playergold += 5
	queue_free()
	

func _on_coin_body_entered(body):
	if body.name == "Player" and !poofed:
		get_node("coin/AnimatedSprite2D").play("poof")
		poofed = true

func _on_animated_sprite_2d_animation_finished():
	if get_node("coin/AnimatedSprite2D").animation == "poof":
		Game.playergold += 5
		queue_free()


func _on_timer_timeout():
	get_node("coin/AnimatedSprite2D").play("poof")
	poofed = true
