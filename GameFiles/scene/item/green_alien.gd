extends CharacterBody2D

@onready var anim = get_node("AnimationPlayer")
@onready var navi = get_node("NavigationAgent2D") as NavigationAgent2D
var speed = 130
var target_bodies = []
var current_target = null
var reached = false
@onready var player = get_node("../Player")
var laser = preload("res://scene/player/laser.tscn")

#var mischief = 45 + (Game.playerstats["Punch"] * 6)

# Called when the node enters the scene tree for the first time.
func _ready():
	#var rng = RandomNumberGenerator.new()
	#var color = rng.randf()
	anim.play("hover")
	get_node("lifetime").start()

func setPlayer(x):
	player = x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var dir = to_local(navi.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	
	if current_target != null and current_target.global_position.x > self.global_position.x:
		get_node("AnimatedSprite2D").flip_h = false
	else:
		get_node("AnimatedSprite2D").flip_h = true
		

func get_nav_path():
	navi.target_position = current_target.global_position + Vector2(0,-100)

func _on_target_area_body_entered(body):
	if body.is_in_group("mob") or body.name == "Player":
		target_bodies.append(body)


func _on_target_area_body_exited(body):
	if body.is_in_group("mob") or body.name == "Player":
		target_bodies.erase(body)


func _on_navtimer_timeout():
	current_target = null
	if target_bodies != []:
		for i in target_bodies:
			if i.is_in_group("mob") and !(i.dead or i.frozen or i.nopatience):
				current_target = i
	if current_target == null or abs(global_position.x - player.global_position.x) > 300:
		current_target = player
		if abs(global_position.x - player.global_position.x) > 450:
			speed = 500
		else:
			var levelmodtest = (Game.current_abilities_levels["Summon(Green Aliens)"] / 5.0) + 0.4
			speed = 130 * levelmodtest
				
	get_nav_path()


func _on_navigation_agent_2d_target_reached():
	
	
	var rng = RandomNumberGenerator.new()
	var randposx = rng.randi_range(-50,50)
	var randposy = rng.randi_range(-110,-95)
	
	reached = true
	navi.target_position += Vector2(randposx,randposy)
	
	
	
	
	


func _on_zap_timer_timeout():
	if current_target.is_in_group("mob"):
		var spawn = laser.instantiate()
		get_parent().add_child(spawn)
		spawn.position = self.global_position
		spawn.shoot_at_target(self.global_position,player.accuracy,current_target)
		
		var rng = RandomNumberGenerator.new()
		var levelmodtest = (Game.current_abilities_levels["Summon(Green Aliens)"] / 5.0) + 0.4
		var zaptime = rng.randf_range(-1.0,0.5)
		if zaptime > 0:
			zaptime -= 0.1 * levelmodtest
		else:
			zaptime *= levelmodtest
		if zaptime < 0.1:
			zaptime = 0.1
		get_node("zap_timer").wait_time = 1.3 + zaptime
	
	


func _on_lifetime_timeout():
		var rise = get_tree().create_tween()
		rise.tween_property(self,"position",position - Vector2(0,1000), 0.6)
		var fade = get_tree().create_tween()
		fade.tween_property(self,"modulate:a",0, 0.6)
		await get_tree().create_timer(0.6).timeout
		queue_free()
