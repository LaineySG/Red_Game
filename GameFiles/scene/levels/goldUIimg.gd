extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func redflash():
	var redflashtween = get_tree().create_tween()
	redflashtween.tween_property(self, "modulate", Color(1,0,0,0.6), 0.2)
	var redscale = get_tree().create_tween()
	redscale.tween_property(self, "scale", Vector2(5,5), 0.2)
	await get_tree().create_timer(0.2).timeout
	var backtonormal = get_tree().create_tween()
	backtonormal.tween_property(self, "modulate", Color(1,1,1,1), 0.1)
	var backtonormal2 = get_tree().create_tween()
	backtonormal2.tween_property(self, "scale", Vector2(2.5,2.5), 0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
