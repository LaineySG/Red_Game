extends AnimatedSprite2D

var opened = false
var rng = RandomNumberGenerator.new()
var roomtype = ""
var door_theme = "blue_1"
signal open_door(x)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Itemroom").visible = false
	get_node("Mysteryroom").visible = false
	get_node("Coinroom").visible = false
	get_node("Fightroom").visible = false
	get_node("Meetingroom").visible = false
	get_node("Fightroom_Skull").visible = false
	if Variables.current_room_doors.has(self.name):
		roomtype = Variables.current_room_doors[self.name]
	else:
		roomtype = get_node("Roomdeterminator").get_room()
		
		
	var mysteryroom = rng.randf()
	var mystery = false
		
	if	Variables.current_room_doors.has(str(name)+"mystery"):
		mystery = Variables.current_room_doors[str(name)+"mystery"]
	else:
		if mysteryroom > 0.9:
			mystery = true
		
		
	if roomtype == "item":
		get_node("Itemroom").visible = true
	elif roomtype == "fight":
		get_node("Fightroom").visible = true
	elif roomtype == "shop":
		get_node("Coinroom").visible = true
	elif roomtype == "meeting" or roomtype == "cyberpub":
		get_node("Meetingroom").visible = true
	elif roomtype == "skull":
		get_node("Fightroom_Skull").visible = true
	if mystery:
		get_node("Mysteryroom").visible = true
		get_node("Itemroom").visible = false
		get_node("Coinroom").visible = false
		get_node("Fightroom").visible = false
		get_node("Fightroom_Skull").visible = false
		get_node("Meetingroom").visible = false
		
	
	Variables.current_room_doors[self.name] = roomtype
	Variables.current_room_doors[str(name)+"mystery"] = mystery
		
func img_refresh():	
	get_node("Mysteryroom").visible = false
	get_node("Itemroom").visible = false
	get_node("Coinroom").visible = false
	get_node("Fightroom").visible = false
	get_node("Fightroom_Skull").visible = false
	get_node("Meetingroom").visible = false
	
	if roomtype == "item":
		get_node("Itemroom").visible = true
	elif roomtype == "fight":
		get_node("Fightroom").visible = true
	elif roomtype == "shop":
		get_node("Coinroom").visible = true
	elif roomtype == "skull":
		get_node("Fightroom_Skull").visible = true
	elif roomtype == "meeting":
		get_node("Meetingroom").visible = true

func open():
	if door_theme == "blue_1":
		play("open")
	elif door_theme == "white_1":
		play("open_white")
	elif door_theme == "gradient_1":
		play("open_gradient")
	elif door_theme == "cyberbar":
		play("open_cyberbar")
		
	get_node("door_light/Shadow").color = Color.LIGHT_BLUE
	get_node("door_light/TextureLight").color = Color.LIGHT_BLUE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if door_theme == "blue_1" and !opened:
		play("closed")
	elif door_theme == "white_1" and !opened:
		play("closed_white")
	elif door_theme == "gradient_1" and !opened:
		play("closed_gradient")
	elif door_theme == "cyberbar" and !opened:
		play("closed_cyberbar")		
		
	if get_node("Area2D").open and !opened:
		opened = true
		open()
		
func changeroom():
	get_node("Roomdeterminator").changeroom(roomtype)




func _on_area_2d_opendoor(_chosendoor):
	open_door.emit(self)
