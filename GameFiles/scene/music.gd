extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for kids in get_children():
		kids.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func getcurrentsong():
	if get_node("combat").volume_db > -79:
		return "combat"
	elif get_node("relaxed").volume_db > -79:
		return "relaxed"
	else:
		return null
		
func fadein(song):
	if getcurrentsong() == "relaxed":
		fadeout("relaxed")
	elif getcurrentsong() == "combat":
		fadeout("combat")
		
	var audiostream
	if song == "combat":
		audiostream = get_node("combat")
	elif song == "relaxed":
		audiostream = get_node("relaxed")
	var tween_fadein = get_tree().create_tween()	
	tween_fadein.tween_property(audiostream,"volume_db", -10,2.0)
			
	
func fadeout(song):
	var audiostream
	if song == "combat":
		audiostream = get_node("combat")
	elif song == "relaxed":
		audiostream = get_node("relaxed")
	var tween_fadeout = get_tree().create_tween()
	tween_fadeout.tween_property(audiostream,"volume_db", -80,2.0) 
	
	
func playsong(song):
	if song == "combat" and getcurrentsong() != "combat":
		print("combat")
		fadein("combat")
	elif song == "relaxed" and getcurrentsong() != "relaxed":
		print("relaxed")
		fadein("relaxed")
	else:
		print("no change")
		pass

func stopsongs():
	get_node("combat").stop()
	get_node("relaxed").stop()
	
