extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var output = ""
	output += "Shot Speed: " + str(Game.playerstats["Shot Speed"]) + "\n"
	output += "Fire Rate: " + str(Game.playerstats["Fire Rate"]) + "\n"
	output += "Bullet Size: " + str(Game.playerstats["Bullet Size"]) + "\n"
	output += "Alacrity: " + str(Game.playerstats["Alacrity"]) + "\n"
	text = output
