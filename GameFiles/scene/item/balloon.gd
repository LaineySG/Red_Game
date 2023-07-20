extends Area2D


var mischief = 85 + (Game.playerstats["Punch"] * 8)
var MoT = 1 + (Game.playerstats["Punch"] * 3)
@onready var anim = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var color = rng.randf()
	if color < 0.3:
		mischief *= 0.75
		anim.play("red_balloon")
	elif color < 0.5:
		mischief *= 1
		anim.play("blue_balloon")
	elif color < 0.7:
		mischief *= 1.4
		anim.play("green_balloon")
	elif color < 0.9:
		mischief *= 1.8
		anim.play("yellow_balloon")
	else:
		mischief *= 2.0
		anim.play("heart_balloon")


	
	

func _on_pop_damage_body_entered(body):
	if body.is_in_group("mob") or body.is_in_group("bullets"):
		if body.is_in_group("mob"):
			body.hurt(0,mischief,0,MoT)
		var rise = get_tree().create_tween()
		rise.tween_property(self,"position",position - Vector2(0,50), 0.6)
		var fade = get_tree().create_tween()
		fade.tween_property(self,"modulate:a",0, 0.6)
		get_node("confetti").emitting = true
		get_node("pop_damage").monitoring = true
		await get_tree().create_timer(0.8).timeout
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("mob") or body.is_in_group("bullets"):
		#var rise = get_tree().create_tween()
		#var fade = get_tree().create_tween()
		#rise.tween_property(self,"position",position - Vector2(0,50), 0.6)
		#fade.tween_property(self,"modulate:a",0, 0.6)
		#get_node("confetti").emitting = true
		get_node("pop_damage").monitoring = true
