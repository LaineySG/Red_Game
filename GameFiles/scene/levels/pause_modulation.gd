extends CanvasLayer

var allowexit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible:
		await get_tree().create_timer(0.05).timeout
		allowexit = true
	if Input.is_action_just_pressed("ui_cancel") and self.visible and allowexit:
		allowexit = false
		self.visible = false
		Utils.unpausegame()
