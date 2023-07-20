extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rise = get_tree().create_tween()
	rise.tween_property(self,"position",position - Vector2(0,150), 6)
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 6)
	

func settext(text):
	get_node("Label").text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func setcolor(color):
	get_node("Label").modulate = color

func _on_timer_timeout():
	queue_free()
