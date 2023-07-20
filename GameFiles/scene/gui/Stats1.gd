extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var output = ""
	output += "Shot Speed: " + str(Game.playerstats["Shot Speed"]) + "\n"
	output += "Shot Weight: " + str(Game.playerstats["Shot Weight"]) + "\n"
	output += "Punch: " + str(Game.playerstats["Punch"]) + "\n"
	output += "Magazine Size: " + str(Game.playerstats["Magazine Size"]) + "\n"
	text = output
				
				
			

