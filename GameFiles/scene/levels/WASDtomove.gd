extends RichTextLabel

@export var inputallowed = false
var step = 0
var player = null
var doorcanopen = false
var bodies = []
signal dooropen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func fadein():
	if step == 0:
		var fadein_tween = get_tree().create_tween()
		fadein_tween.tween_property(self,"modulate:a",1, 0.5)
	if step == 1:
		text = "Press space to jump."
		var fadein_tween2 = get_tree().create_tween()
		fadein_tween2.tween_property(self,"modulate:a",1, 0.5)
	if step == 2:
		text = "Press E to interact."
		var fadein_tween3 = get_tree().create_tween()
		fadein_tween3.tween_property(self,"modulate:a",1, 0.5)

func fadeout():
	var fadeout_tween = get_tree().create_tween()
	fadeout_tween.tween_property(self,"modulate:a",0, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	
	
	if inputallowed:
		if step == 0:
			if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				fadeout()
				await get_tree().create_timer(0.5).timeout
				step = 1
				fadein()
				await get_tree().create_timer(0.5).timeout
		if step == 1:
			if Input.is_action_just_pressed("ui_accept"):
				fadeout()
				await get_tree().create_timer(0.5).timeout
				step = 2
	if step == 2:
		doorcanopen = true
		self.position.x = 305
		self.position.y = 49
		fadein()
		await get_tree().create_timer(0.5).timeout
		inputallowed = true
	
	if Input.is_action_just_pressed("ui_E"):	
		if bodies.has("Player") and inputallowed and doorcanopen:
			emit_signal("dooropen")


func _on_tutorial_area_1_door_body_entered(body):
	#Player walks up to door
	if body.name == "Player":
		bodies.append("Player")


func _on_tutorial_area_1_door_body_exited(body):
	if body.name == "Player":
		bodies.erase("Player")


func _on_transition_screen_transitioned():
	get_tree().change_scene_to_file("res://scene/levels/tutorial_area_2.tscn")
