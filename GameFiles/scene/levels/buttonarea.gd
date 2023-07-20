extends Area2D

signal buttonpress
var pressed = false
var locked = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in get_overlapping_bodies():
		if i.name == "Player":
			if Input.is_action_just_pressed("ui_E") and !pressed and !locked:
				#print("pressed")
				buttonpress.emit()
				pressed = true
				#self.remove_from_group("interact")
				
			


