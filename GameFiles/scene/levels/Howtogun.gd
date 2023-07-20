extends RichTextLabel

@export var inputallowed = false
var step = 0
var player = null
var doorcanopen = false
signal dooropen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func fadein():
		var fadein_tween = get_tree().create_tween()
		fadein_tween.tween_property(self,"modulate:a",1, 0.5)

func fadeout():
	var fadeout_tween = get_tree().create_tween()
	fadeout_tween.tween_property(self,"modulate:a",0, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	pass

func _on_tutorial_area_1_door_body_entered(_body):
	fadein()


func _on_tutorial_area_1_door_body_exited(_body):
	fadeout()


func _on_tutorial_area_3_gunspickedup():
	self.visible = true
	fadein()
