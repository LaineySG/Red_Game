extends Area2D
var mischief = 0
var DoT = 0
var dmg = 0
var MoT = 0
var targetedbodies = []
var frequency = 3
var amplitude = 0.3
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$lifetime.start()
	$damageticker.start()
	look_at(get_global_mouse_position())
		
func setdmg(input_mischief,input_dmg,input_DoT,input_MoT):
	mischief = input_mischief
	dmg = input_dmg
	DoT = input_DoT
	MoT = input_MoT
	if Game.current_effects.has("Duo-Shot"):
		mischief *= 1.25
		DoT *= 1.25
		dmg *= 1.25
		MoT *= 1.25
	if Game.current_effects.has("Tri-Shot"):
		mischief *= 1.40
		DoT *= 1.40
		dmg *= 1.40
		MoT *= 1.40
	if Game.current_effects.has("Quad-Shot"):
		mischief *= 1.75
		DoT *= 1.75
		dmg *= 1.75
		MoT *= 1.75
	
func Chargemod(chargetime):
	mischief *=  1.0 + ( 0.1 * chargetime)
	MoT *=  1.0 + ( 0.1 * chargetime)
	chargetime = 0.0

func init(init_position):
	self.global_position = init_position
	look_at(get_global_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#wave function
		time += delta
		var bubbling = cos(time * frequency) * amplitude
		get_node("Sprite2D").scale.x += bubbling * delta
		get_node("Sprite2D").scale.y += bubbling * delta
	#wave function


func _on_body_entered(body):
	if body.is_in_group("mob") and $damageticker.timeout and self.visible == true:
		targetedbodies.append(body)
		body.hurt(dmg,mischief,DoT,MoT)
		



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
				i.hurt(dmg,mischief,DoT,MoT)
