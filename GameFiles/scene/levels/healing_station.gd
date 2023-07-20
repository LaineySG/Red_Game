extends Node2D
var cost = 0
var rng = RandomNumberGenerator.new()
var allowinput = false
var fivefingerdiscount = false
var is_player_in
var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	cost = int(round( 0.25 * (Game.playerhpmax - Game.playerhp))) #how much there is to heal
	if fivefingerdiscount:
		cost = 0
	get_node("cost").text = str(cost)
	is_player_in = false
	for body in bodies:
		if body.name == "Player":
			is_player_in = true
	if is_player_in:
		allowinput = true
	else:
		allowinput = false
	
	if allowinput:
		if Input.is_action_just_pressed("ui_E") and Game.playergold >= cost:
			Game.playergold -= cost
			for body in bodies:
				if body.name == "Player":
					body.heal(Game.playerhpmax - Game.playerhp)
		elif Input.is_action_just_pressed("ui_E") and Game.playergold < cost:
			for body in bodies:
				if body.name == "Player":
					body.heal(4 * Game.playergold)
			Game.playergold = 0
	
func fivefingerdiscountset():
	fivefingerdiscount = true
	cost = 0
	
func _on_area_2d_body_entered(body):
	bodies.append(body)


func _on_area_2d_body_exited(body):
	bodies.erase(body)
