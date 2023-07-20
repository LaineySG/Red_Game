extends Timer


var cherry = preload("res://scene/item/cherry.tscn")

func _on_timeout():
	var cherrytemp = cherry.instantiate()
	var rng = RandomNumberGenerator.new()
	var rand = rng.randi_range(0,1500)
	cherrytemp.position = Vector2(rand,250)
	get_parent().add_child(cherrytemp)
