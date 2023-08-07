extends CanvasLayer

signal transitioned
signal backtoship
var dead = false
var rng = RandomNumberGenerator.new()
@onready var deathmessage = get_node("Label")
@export var animationtracker = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func playerdied():
	dead = true
	self.visible = true
	transition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if animationtracker:
		Utils.pausegame()
		animationtracker = false

func transition():
	$AnimationPlayer.play("fade_to_black")
	var textgen = rng.randf()
	var chosentext = ""
	if textgen < 0.10:
		chosentext = "Do not go gentle into that good night."
	elif textgen < 0.2: 
		chosentext = "Rage, rage against the dying of the light."
	elif textgen < 0.3:
		chosentext = "And death shall have no dominion."
	elif textgen < 0.4:
		chosentext = "Though lovers be lost, love shall not."
	elif textgen < 0.5:
		chosentext = "After the first death, there is no other."
	elif textgen < 0.6:
		chosentext = "Out of her eyes she saw the last light glide."
	elif textgen < 0.7:
		chosentext = "Last sound, the world going out without a breath."
	elif textgen < 0.8:
		chosentext = "A world of ills came down like snow."
	elif textgen < 0.9:
		chosentext = "Where no sea runs, the waters of the heart."
	else:
		chosentext = "Dawn breaks behind the eyes."
		
	deathmessage.text = chosentext
	




func _on_play_button_down():
	if dead:
		backtoship.emit()
