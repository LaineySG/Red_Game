extends Area2D
var mischief = 0
var DoT = 0
var dmg = 0
var MoT = 0
var length
var targetedbodies = []
var frequency = 3
var amplitude = 0.3
var time = 0
var breakout = false
var cast1 = false
var cast2 = false
var cast3 = false
@onready var raycast1 = $RayCast2D
@onready var raycast2 = $RayCast2D2
@onready var raycast3 = $RayCast2D3

# Called when the node enters the scene tree for the first time.
func _ready():
	$lifetime.start()
	var tickspeed = (Game.playerstats["Shot Speed"] / 200.0)
	$damageticker.wait_time = (0.25 - tickspeed)
	$damageticker.start()
	look_at(get_global_mouse_position())
	scale.x = 8.72 + (Game.playerstats["Bullet Size"] * 1.0 / 15.0)
	scale.y = 3.76 + (Game.playerstats["Bullet Size"] * 1.0 / 15.0)	
	if Game.current_effects.has("Big Shot"):
		var levelmodtest = (Game.current_effects_levels["Big Shot"] / 5.0) + 0.6
		if scale.x < 10:
			scale.x = 10 + (1.5 * levelmodtest)
			scale.y = 5 + (1.5 * levelmodtest)
		else:
			scale.x = 12 + (1.5 * levelmodtest)
			scale.y *= 8 + (1.5 * levelmodtest)
		
func setdmg(input_mischief,input_dmg,input_DoT,input_MoT):
	mischief = input_mischief
	dmg = input_dmg
	DoT = input_DoT
	MoT = input_MoT
	if Game.current_effects.has("Duo-Shot"):
		var levelmodtest = (Game.current_effects_levels["Duo-Shot"] / 5.0)
		var modifier = 1.0 + (0.15 * levelmodtest)
		mischief  *= modifier
		DoT  *= modifier
		dmg  *= modifier
		MoT  *= modifier
	if Game.current_effects.has("Tri-Shot"):
		var levelmodtest = (Game.current_effects_levels["Tri-Shot"] / 5.0)
		var modifier = 1.0 + (0.25 * levelmodtest)
		mischief  *= modifier
		DoT  *= modifier
		dmg  *= modifier
		MoT  *= modifier
	if Game.current_effects.has("Quad-Shot"):
		var levelmodtest = (Game.current_effects_levels["Quad-Shot"] / 5.0)
		var modifier = 1.0 + (0.40 * levelmodtest)
		mischief  *= modifier
		DoT  *= modifier
		dmg  *= modifier
		MoT  *= modifier
		
	if Game.current_effects.has("Flintlock (Gun)") and Game.weapon_equipped == "gun":
		var levelmodtest = (Game.current_effects_levels["Flintlock (Gun)"] / 5.0) + 0.4
		dmg *= (1.0 + (0.4 * levelmodtest))
		
	
func Chargemod(chargetime):
	mischief *=  1.0 + ( 0.1 * chargetime)
	MoT *=  1.0 + ( 0.1 * chargetime)
	chargetime = 0.0

func init(init_position):
	self.global_position = init_position
	look_at(get_global_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible:
		if raycast1.is_colliding() and !cast1:
			if raycast1.get_collider().is_in_group("mob"):
				breakout = true
			elif !breakout:
				mischief -= (mischief * 0.33)
				MoT -= (MoT * 0.33)
				dmg -= (dmg * 0.33)
				DoT -= (DoT * 0.33)
				cast1 = true
		if raycast2.is_colliding() and !cast2:
			if raycast2.get_collider().is_in_group("mob"):
				breakout = true
			elif !breakout:
				mischief -= (mischief * 0.33)
				MoT -= (MoT * 0.33)
				dmg -= (dmg * 0.33)
				DoT -= (DoT * 0.33)
				cast2 = true
		if raycast3.is_colliding() and !cast3:
			if raycast3.get_collider().is_in_group("mob"):
				breakout = true
			
		if raycast3.is_colliding() and raycast2.is_colliding() and raycast1.is_colliding() and !breakout:
			mischief = 0
			MoT = 0
			dmg = 0
			DoT = 0
			breakout = true
			
			


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
