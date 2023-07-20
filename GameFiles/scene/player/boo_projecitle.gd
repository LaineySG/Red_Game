
extends CharacterBody2D



var speed = 75.0
var direction
var bubble = preload("res://scene/player/rainbubble.tscn")
var shroom = preload("res://scene/player/fluzar_shroom.tscn")
var smokepoof = preload("res://scene/item/smokepoof.tscn")
var first = true
var mischief = 15 + (Game.playerstats["Punch"] * 5)
var damage = true
var bubble_emitted = false
var player = null
var target = null
var DoT = 0
var dmg = 0 
var MoT = 0
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("default")
	get_node("Timer").start()
	
func set_player(x):
	player = x
func set_target(x):
	target = x
	modulate = Color.DEEP_PINK
	
func setdamage(x):
	dmg = x
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if !player.camo:
			direction = (player.global_position - self.global_position).normalized()
			velocity = Vector2(speed * direction.x, speed * direction.y)
	if target != null:
		direction = (target.global_position - self.global_position).normalized()
		velocity = Vector2(speed * direction.x, speed * direction.y)
			
	var collision = move_and_collide(velocity * delta)		
	if collision and collision.get_collider().name == "Player" and damage:
		damage = false
		collision.get_collider().hurt(dmg,0)
		var smokespawn = smokepoof.instantiate()
		smokespawn.global_position = self.global_position
		get_parent().call_deferred("add_child", smokespawn)
		queue_free()
	elif collision and collision.get_collider().is_in_group("mob") and damage and target != null:
		damage = false
		collision.get_collider().hurt(0,(dmg),0,0)
		var smokespawn = smokepoof.instantiate()
		smokespawn.global_position = self.global_position
		get_parent().call_deferred("add_child", smokespawn)
		queue_free()
	elif collision:
		var smokespawn = smokepoof.instantiate()
		smokespawn.global_position = self.global_position
		get_parent().call_deferred("add_child", smokespawn)
		queue_free()
		


func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.1)
	await get_tree().create_timer(0.1).timeout
	queue_free()
