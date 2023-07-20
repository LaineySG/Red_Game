extends CharacterBody2D



var mischief = 3 + (Game.playerstats["Punch"] * 1)
var DoT = 0
var MoT = 0.5 + (Game.playerstats["Punch"] * 0.25)
var targetedbodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$lifetime.start()
	$damageticker.start()
	look_at(get_global_mouse_position())

func init(init_position):
	self.global_position = init_position
	look_at(get_global_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("mob") and $damageticker.timeout and self.visible == true:
		targetedbodies.append(body)
		body.hurt(0,mischief,DoT,MoT)
		



func _on_lifetime_timeout():
	self.visible = false


func _on_body_exited(body):
	if body.is_in_group("mob"):
		if targetedbodies.has(body):
			for i in targetedbodies:
				targetedbodies.erase(i)


func _on_damageticker_timeout():
	if targetedbodies != []:
		if self.visible == true:
			$damageticker.start()
			for i in targetedbodies:
				i.hurt(0,mischief,DoT,MoT)
