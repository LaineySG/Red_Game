
extends CharacterBody2D



var speed = 150.0
var direction
var bubble = preload("res://scene/player/rainbubble.tscn")
var shroom = preload("res://scene/player/fluzar_shroom.tscn")
var first = true
var damage = true
var bubble_emitted = false
var hypno = false
var DoT = 0
var dmg = 0
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("default")
	get_node("Timer").start()
	
func hypnoset():
	hypno = true
	modulate = Color.FOREST_GREEN
	
func setdamage(x):
	dmg = x
	DoT = x / 3
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity * delta #gravity
	var collision = move_and_collide(velocity * delta)	
		
	if collision and collision.get_collider().name == "Player" and !hypno:
		collision.get_collider().hurt(dmg,DoT)
		queue_free()
	elif collision and collision.get_collider().is_in_group("mob") and collision.get_collider().name.left(6) != "fluzar" and collision.get_collider().name.left(7) != "@fluzar" and hypno:
		collision.get_collider().hurt(0,dmg,0,(dmg - 1))
		queue_free()
	elif collision and !collision.get_collider().is_in_group("mob") and collision.get_collider().name.left(6) != "fluzar" and collision.get_collider().name.left(7) != "@fluzar" :
		var shroomspawn = shroom.instantiate()
		shroomspawn.global_position = self.global_position
		shroomspawn.setdamage(dmg,DoT)
		if hypno:
			shroomspawn.hypnoset()
		get_parent().add_child(shroomspawn)
		queue_free()
		


func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.1)
	await get_tree().create_timer(0.1).timeout
	queue_free()
