extends Timer

var booncounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	booncounter = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_timeout():
	if booncounter <= 12:
		booncounter += 1
		
