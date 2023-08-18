extends Sprite2D

var gunomancer_texture_set = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Game.player_talents_current["Gunomancer"] > 0 and !gunomancer_texture_set:
		texture = load("res://assets/gui/Button06.png")
		gunomancer_texture_set = true
		
