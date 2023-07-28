extends CharacterBody2D


var damage = 65 + (Game.playerstats["Punch"] * 4)
var dot = 3 + (Game.playerstats["Punch"] * 2)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var size = rng.randf()
	if size < 0.3:
		scale*= 0.75
		dot *= 0.75
		damage *= 0.75
	elif size < 0.6:
		scale*= 1
		dot *= 1
		damage *= 1
		get_node("confetti").process_material.initial_velocity_max = 110
		get_node("confetti").amount = 300
	elif size < 0.9:
		scale*= 1.2
		dot *= 1.2
		damage *= 1.2
		get_node("confetti").process_material.initial_velocity_max = 155
		get_node("confetti").amount = 350
	else:
		scale*= 1.5
		dot *= 1.5
		damage *= 1.5
		get_node("confetti").process_material.initial_velocity_max = 250
		get_node("confetti").amount = 400
		
		
		
		var levelmodtest = (Game.current_abilities_levels["Land Mine"] / 5.0) + 0.4

		dot *= levelmodtest
		scale*= levelmodtest
		damage *= levelmodtest
		get_node("confetti").process_material.initial_velocity_max *= levelmodtest
		get_node("confetti").amount *= levelmodtest

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide()
	velocity.y += gravity * delta #gravity
	pass
	
	

func _on_pop_damage_body_entered(body):
	if body.is_in_group("mob") or body.is_in_group("bullets"):
		if body.is_in_group("mob"):
			body.hurt(damage,0,dot,0)
		var rise = get_tree().create_tween()
		rise.tween_property(self,"position",position - Vector2(0,50), 0.6)
		var fade = get_tree().create_tween()
		fade.tween_property(self,"modulate:a",0, 0.6)
		get_node("confetti").emitting = true
		get_node("pop_damage").monitoring = true
		await get_tree().create_timer(0.8).timeout
		queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("mob") or body.is_in_group("bullets"):
		#var rise = get_tree().create_tween()
		#var fade = get_tree().create_tween()
		#rise.tween_property(self,"position",position - Vector2(0,50), 0.6)
		#fade.tween_property(self,"modulate:a",0, 0.6)
		#get_node("confetti").emitting = true
		get_node("pop_damage").monitoring = true

