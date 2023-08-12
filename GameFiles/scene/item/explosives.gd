extends CharacterBody2D


var damage = 65 + (Game.playerstats["Punch"] * 4)
var dot = 3 + (Game.playerstats["Punch"] * 2)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
		get_node("confetti").process_material.initial_velocity_max = 650
		get_node("confetti").amount = 600
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide()
	velocity.y += gravity * delta #gravity
	pass
	
	

func _on_pop_damage_body_entered(body):
	if body.is_in_group("mob") or body.is_in_group("bullets"):
		if body.is_in_group("mob"):
			body.hurt(damage,0,dot,0)
		var fade = get_tree().create_tween()
		fade.tween_property(self,"modulate:a",0, 0.6)
		get_node("confetti").emitting = true
		get_node("pop_damage").monitoring = true
		await get_tree().create_timer(0.8).timeout
		queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("bullets") and (typeof(body.damage) == 2):
		body.queue_free()
		#var rise = get_tree().create_tween()
		#var fade = get_tree().create_tween()
		#rise.tween_property(self,"position",position - Vector2(0,50), 0.6)
		#fade.tween_property(self,"modulate:a",0, 0.6)
		#get_node("confetti").emitting = true
		get_node("pop_damage").monitoring = true

