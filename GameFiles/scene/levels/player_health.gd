extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	value = Game.playerhp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	max_value = Game.playerhpmax
	value = Game.playerhp
