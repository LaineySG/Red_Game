extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		Game.playergold +=1
		Game.playerhp +=5
		var rise = get_tree().create_tween()
		rise.tween_property(self,"position",position - Vector2(0,50), 0.6)
		var fade = get_tree().create_tween()
		fade.tween_property(self,"modulate:a",0, 0.6)
		await get_tree().create_timer(0.6).timeout
		queue_free()
