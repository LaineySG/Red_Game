extends RichTextLabel

var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fadein():
	var fadein_tween = get_tree().create_tween()
	fadein_tween.tween_property(self,"modulate:a",1, 0.5)

func fadeout():
	var fadeout_tween = get_tree().create_tween()
	fadeout_tween.tween_property(self,"modulate:a",0, 0.5)


func _on_collisionbox_body_entered(_body):
	if disabled == false:
		fadein()


func _on_collisionbox_body_exited(_body):
	fadeout()
