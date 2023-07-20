
extends CharacterBody2D



var speed = 325.0
var direction
var bubble = preload("res://scene/player/rainbubble.tscn")
var shroom = preload("res://scene/player/fluzar_shroom.tscn")
var first = true
var damage = true
var bubble_emitted = false
var hypno = false
var DoT = 8
var dmg = 5
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("default")
	get_node("Timer").start()
	
	
func set_dir(x):
	direction = x
	
func hypnoset():
	hypno = true
	modulate = Color.FOREST_GREEN
	
func setdamage(x):
	dmg = x
	DoT = x / 3
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2(speed * direction.x, speed * direction.y)
	
	var collision = move_and_collide(velocity * delta)		
	if collision and collision.get_collider().name == "Player":
		collision.get_collider().hurt(dmg,DoT)
		queue_free()
	elif collision and collision.get_collider().is_in_group("mob") and hypno:
		collision.get_collider().hurt(0,dmg,0,(dmg - 1))
		queue_free()
	elif collision and !collision.get_collider().is_in_group("mob"):
		queue_free()
		


func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.1)
	await get_tree().create_timer(0.2).timeout
	queue_free()
