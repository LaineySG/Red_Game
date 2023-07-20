extends CanvasLayer

signal transitioned

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	$AnimationPlayer.play("fade_to_normal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func transition():
	$AnimationPlayer.play("fade_to_black")
	
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		$AnimationPlayer.play("fade_to_normal")
		transitioned.emit()
	else:
		pass


func _on_was_dtomove_dooropen():
	transition()


func _on_area_2d_opendoor():
	transition()


func _on_area_2d_opendoor_2():
	transition()
