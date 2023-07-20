extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.name.left(4) == "effe":
		var output = ""
		output += str(Game.current_effects)
		text = output
	else:
		var output = ""
		output += str(Game.current_abilities)
		text = output
