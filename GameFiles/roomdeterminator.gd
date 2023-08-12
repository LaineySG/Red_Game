extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func randomroom():
	var randfloat = rng.randf()
	if randfloat < 0.25 + ( + (Game.playerstats["Luck"] * 0.005)):
		changeroom("item")
	elif randfloat < 0.85 - ( + (Game.playerstats["Luck"] * 0.005)):
		changeroom("fight")
	else:
		changeroom("shop")
	
func get_room():
	var randfloat = rng.randf()
	if Game.roomcount >= 10 and !Variables.grimm_conversation_tracker.has("grimm_1") and randfloat < 0.10 + ((Game.roomcount - 10) / 10.0):
		return "meeting"
	elif Game.roomcount >= 20 and !Variables.grimm_conversation_tracker.has("grimm_2") and randfloat < 0.10 + ((Game.roomcount - 20) / 10.0):
		return "meeting"
		
	if randfloat < 0.25 + ( + (Game.playerstats["Luck"] * 0.005)):
		return "item"
	elif randfloat < 0.85 - ( + (Game.playerstats["Luck"] * 0.005)):
		return "fight"
	else:
		return "shop"

func changeroom(type):
	Game.roomcount += 1
	if type == "item":
		var randfloat = rng.randf()
		if randfloat < 0.8 -  + (Game.playerstats["Luck"] * 0.01):
			get_tree().change_scene_to_file("res://scene/levels/item_room.tscn")
		else:
			get_tree().change_scene_to_file("res://scene/levels/item_choice_room.tscn")
	elif type == "fight":
		var randfloat = rng.randf()
		if randfloat < 0.25:
			if randfloat < 0.8:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_1.tscn")
			elif randfloat < 0.16:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_1_var1.tscn")
			else:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_1_var2.tscn")
		elif randfloat < 0.50:
			if randfloat < 0.33:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_2.tscn")
			elif randfloat < 0.41:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_2_var1.tscn")
			else:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_2_var2.tscn")
		elif randfloat < 0.75:
			if randfloat < 0.58:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_3.tscn")
			elif randfloat < 0.66:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_3_var1.tscn")
			else:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_3_var2.tscn")
		else:
			if randfloat < 0.83:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_4.tscn")
			elif randfloat < 0.91:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_4_var1.tscn")
			else:
				get_tree().change_scene_to_file("res://scene/levels/fight_room_1_4_var2.tscn")
				
	elif type == "meeting":
		if Game.roomcount >= 10 and !Variables.grimm_conversation_tracker.has("grimm_1"):
			get_tree().change_scene_to_file("res://scene/levels/meeting_room.tscn")
		elif Game.roomcount >= 20 and  !Variables.grimm_conversation_tracker.has("grimm_2"):
			get_tree().change_scene_to_file("res://scene/levels/boss_fight_1.tscn")
		
	else: #shop
		get_tree().change_scene_to_file("res://scene/levels/shop_room.tscn")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
