extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var output = ""
	output += "Reload Speed: " + str(Game.playerstats["Reload Speed"]) + "\n"
	output += "Fire Rate: " + str(Game.playerstats["Fire Rate"]) + "\n"
	output += "Bullet Size: " + str(Game.playerstats["Bullet Size"]) + "\n"
	output += "Scope: " + str(Game.playerstats["Scope"]) + "\n"
	text = output
