extends CharacterBody2D

@onready var anim = get_node("AnimatedSprite2D")
var player = null
var has_conversation = false
var training = false
signal gun_training(training_bool)
signal conversation_bob

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if has_conversation:
		get_node("!").visible = true
		self.add_to_group("interact")
		get_node("Area2D").add_to_group("interact")
	else:
		get_node("!").visible = false

	
	if player != null and Input.is_action_just_pressed("ui_E") and has_conversation:
		conversation_bob.emit()
		player.get_node("doordetector/Interact").visible = false
		has_conversation = false
	elif player != null and Input.is_action_just_pressed("ui_E") and !has_conversation:
		training = true
		gun_training.emit(true)
	if training and player == null:
		gun_training.emit(false)
		
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body


func _on_area_2d_body_exited(_body):
	player = null


func _on_timer_timeout():
	get_node("GPUParticles2D").emitting = true
