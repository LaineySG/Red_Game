extends Button

signal resetall

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _pressed():
	for items in Game.player_talents_current:
		if Game.player_talents_current[items] != 0:
			Game.talent_points_gun_unspent += Game.player_talents_current[items]
			# add to gun pool
			Game.talent_points_gun -= Game.player_talents_current[items]
			#remove from spent
			Game.player_talents_current[items] = 0
	resetall.emit()
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
