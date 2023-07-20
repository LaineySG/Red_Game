extends RichTextLabel

@export var inputallowed = false
var step = 0
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func fadein():
	if step == 0:
		var fadein_tween = get_tree().create_tween()
		fadein_tween.tween_property(self,"modulate:a",1, 1.0)
	if step == 1:
		text = "Press space to jump."
		var fadein_tween1 = get_tree().create_tween()
		fadein_tween1.tween_property(self,"modulate:a",1, 1.0)
	if step == 2:
		text = "Press E to interact."
		var fadein_tween2 = get_tree().create_tween()
		fadein_tween2.tween_property(self,"modulate:a",1, 1.0)

func fadeout():
	var fadeout_tween = get_tree().create_tween()
	fadeout_tween.tween_property(self,"modulate:a",0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inputallowed:
		if step == 0:
			if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				fadeout()
				await get_tree().create_timer(1.3).timeout
				step = 1
				fadein()
				await get_tree().create_timer(1.3).timeout
		if step == 1:
			if Input.is_action_just_pressed("ui_accept"):
				fadeout()
				await get_tree().create_timer(1.3).timeout
				
	if player != null and inputallowed:
		if Input.is_action_just_pressed("ui_E"):
			get_parent().get_node("TransitionScreen").transition()


func _on_tutorial_area_1_door_body_entered(body):
	#Player walks up to door
	if body.name == "Player":
		player = body
		self.position.x = 305
		self.position.y = 49
		step = 2
		fadein()
		await get_tree().create_timer(1.3).timeout


func _on_tutorial_area_1_door_body_exited(body):
	if body.name == "Player":
		player = null
