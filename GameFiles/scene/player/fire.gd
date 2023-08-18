extends CharacterBody2D
var pain

func _ready():
	get_node("AnimatedSprite2D").play("default")
	var color = get_tree().create_tween()
	color.tween_property(self,"modulate", Color.RED, 3.0)
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 3.0)
	await get_tree().create_timer(3.0).timeout
	queue_free()
	
func _process(_delta):
	velocity.y = 85
	move_and_slide()


func _on_paintimer_timeout():
	pain = true



func _on_rigid_body_2d_body_entered(body):
	var levelmodtest = (Game.current_effects_levels["Flame Shot (Gun)"] / 5.0) + 0.4
	var DoT = 5.0 +  (int(round(Game.playerstats["Punch"] * 0.4)))
	DoT *=levelmodtest
	DoT += (DoT * (Game.player_talents_current["Curse of the Ages"] * 0.1))
	if Game.current_abilities.size() == 0 and Game.player_talents_current["Lone Wolf"]:
			DoT *= 1.15
	if body.is_in_group("mob"):
		body.hurt(0,0,DoT,0)
		pain = false
