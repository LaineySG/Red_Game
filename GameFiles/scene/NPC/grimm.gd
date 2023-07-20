extends CharacterBody2D

@onready var anim = get_node("AnimatedSprite2D")
var player = null
var has_conversation = false
signal conversation_grimm

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y -= delta * 10
	pass
#	if player != null and Input.is_action_just_pressed("ui_E") and self.is_in_group("interact"):
#		conversation_blue.emit()
#		player.get_node("doordetector/Interact").visible = false
#		has_conversation = false
#
#	if has_conversation:
#		get_node("!").visible = true
#		self.add_to_group("interact")
#		get_node("Area2D").add_to_group("interact")
#	else:
#		get_node("!").visible = false
#		self.remove_from_group("interact")
#		get_node("Area2D").remove_from_group("interact")

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body


func _on_area_2d_body_exited(_body):
	player = null
