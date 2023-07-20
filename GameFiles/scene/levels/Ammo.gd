extends TextureProgressBar

var guntexture = preload("res://assets/environment/scifi/anims/bulletbar2.png")
var toytexture = preload("res://assets/environment/scifi/anims/toybulletbar2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	max_value = 21
	if Game.weapon_equipped == "gun":
		self.texture_progress = guntexture
	else:
		self.texture_progress = toytexture
