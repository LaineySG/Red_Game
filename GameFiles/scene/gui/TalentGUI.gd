extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	for childs in get_node("GUI/background/VBoxContainer/HBoxContainer/VBoxContainer2/gunomancy").get_children():
		if childs.name.left(4) != "Line":
			childs.has_mouse_focus.connect(_on_talent_focused)
			childs.refreshall.connect(_on_refresh_all)
	get_node("reset_button").resetall.connect(_on_refresh_all)

func _on_refresh_all():
	for childs in get_node("GUI/background/VBoxContainer/HBoxContainer/VBoxContainer2/gunomancy").get_children():
		if childs.name.left(4) != "Line":
			childs.refreshnums()
	

func _on_talent_focused(name_of_perk, perk_stats):
	get_node("talent_info").text = "[center][font_size=32]"
	get_node("talent_info").text += str(name_of_perk) + "[/font_size][font_size=32]\n"
	get_node("talent_info").text += str(Game.player_talents_current[name_of_perk]) + "/" + str(perk_stats["maxlvl"]) + "[/font_size]\n\n" # currentperklevel / totalperklevel
	get_node("talent_info").text += str(perk_stats["desc"]) + "\n" #perkdescription
	get_node("talent_info").text += "\n" + str(perk_stats["currentbonus"]) + "\n\n\n\n\n" #perkcurrentbonus
	get_node("talent_info").text +=   str(perk_stats["requirements"]) #perknextbonus
	
	
	
	# check for prerequisites
	#if prerequisites add to end.

	get_node("talent_info").text += "[/center]"




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_node("points").text != ('[img width="30" height="30"]res://assets/gui/icons/electric.png[/img]' + " " + str(Game.talent_points)):
		get_node("points").text = '[img width="30" height="30"]res://assets/gui/icons/electric.png[/img]' + " " + str(Game.talent_points)
