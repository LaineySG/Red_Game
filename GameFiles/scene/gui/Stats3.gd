extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var output = ""
	output += "HP: " + str(Game.playerstats["HP"]) + "\n"
	output += "Punch: " + str(Game.playerstats["Punch"]) + "\n"
	output += "Luck: " + str(Game.playerstats["Luck"]) + "\n"
	output += "Scope: " + str(Game.playerstats["Scope"]) + "\n"
	text = output
