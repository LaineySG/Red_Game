extends TextureRect

signal on_hover(slotdata)
var slotdata = {"ID": 0}
var mouse_is_in = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _gui_input(event):
	if event is InputEventMouseMotion:
		on_hover.emit(slotdata)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_left_click") and mouse_is_in and (Input.is_action_pressed("ui_shift") or Input.is_action_pressed("ui_ctrl")) :
		get_node("../../dragdroplayer")._drop_data(1,slotdata)
		slotdata = {"ID": 0}
		texture = null
		
	
	
func _get_drag_data(_pos):
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	slotdata["item_texture"] = texture
	drag_texture.texture = texture
	drag_texture.set_size(Vector2(50,50))
	texture = null
	
	var ctrl = Control.new()
	ctrl.add_child(drag_texture)
	drag_texture.position = -0.5 * drag_texture.size
	
	set_drag_preview(ctrl)
	var temp = slotdata
	slotdata = {"ID": 0}
	return temp
	
func _can_drop_data(_pos, data):
	if self.name.left(5) == "Major" or self.name.left(5) == "Minor":
		if data.get("Ability") == null:
			return true
		else:
			return false
	elif self.name.left(5) == "Abili":
		if data.get("Ability") == null:
			return false
		else:
			return true
	
func _drop_data(_pos, data):
	#print("{")
	if texture != null and slotdata != null: #replaces block if already has data in it
		get_node("../../dragdroplayer")._drop_data(1,slotdata)
	slotdata["EquipSlot"] = null
	texture = data["item_texture"] # chance item in block 
	data["EquipSlot"] = str(self)
	slotdata = data # set slot's data to item's data
	
	
	for i in range(0,Game.items_list.size()): # for each index in the item list ( 0 to size-1)
		#print(i)
		if Game.items_list[i].get("ID") != null: # if that index has an ID
			#print("data: " + str(data["ID"]) + " inventory item: " + str(Game.items_list[i]["ID"]))
			if Game.items_list[i]["ID"] == data.get("ID"): # if the ID is the same as the dropped ID
				Game.items_list[i]["EquipSlot"] = str(self)
				Game.equipped_items.append(data) #Append the dropped item to the equipped list
				Game.items_list.remove_at(i) # And remove the original from the item list
				break
				
	Game.refreshEffects()
#		print("}")
#	for i in Game.equipped_items:
#		print("Equipped:" + str(i["ID"]) + ":" + str(i["EquipSlot"]))
#	for i in Game.items_list:
#		print("Inventory:" + str(i["ID"]))
#	print("}")

func _on_mouse_entered():
	mouse_is_in = true


func _on_mouse_exited():
	mouse_is_in = false
