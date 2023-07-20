extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fadein():
	var fadein_tween = get_tree().create_tween()
	fadein_tween.tween_property(self,"modulate:a",1, 0.5)

func fadeout():
	var fadeout_tween = get_tree().create_tween()
	fadeout_tween.tween_property(self,"modulate:a",0, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_tutorialtextbox_2_body_entered(body):
	if body.name == "Player":
		fadein()

func _on_tutorialtextbox_2_body_exited(body):
	if body.name == "Player":
		fadeout()

func _on_tutorialtextbox_body_entered(body):
	if body.name == "Player":
		fadein()


func _on_tutorialtextbox_body_exited(body):
	if body.name == "Player":
		fadeout()

func _on_tutorialtextbox_3_body_entered(body):
	if body.name == "Player":
		fadein()


func _on_tutorialtextbox_3_body_exited(body):
	if body.name == "Player":
		fadeout()


func _on_tutorialtextbox_4_body_entered(body):
	if body.name == "Player":
		fadein()


func _on_tutorialtextbox_4_body_exited(body):
	if body.name == "Player":
		fadeout()


func _on_crouchbox_body_entered(body):
	if body.name == "Player":
		fadein()


func _on_crouchbox_body_exited(body):
	if body.name == "Player":
		fadeout()
