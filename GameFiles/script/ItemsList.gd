extends ItemList

var item
var interact = false
var slotdata = {"ID":0}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func searchtext(searchquery):
	#reset each time
	
	for items in self.item_count: # resets items
		set_item_icon_modulate(items,Color(1.0,1.0,1.0,0.25))
		#set_item_disabled(items,true)
		
	searchquery = str(searchquery).to_lower()
	if searchquery == "":
		for items in self.item_count: # resets items
			set_item_icon_modulate(items,Color(1.0,1.0,1.0,1.0))
		
	
	for items in self.item_count: # for items in list
		var contained = false # reset contained
		var itemdict = get_item_metadata(items) # set dictionary 
		for datavalues in itemdict: # for keys in dictionary
			if !contained: #if search query hasn't been found yet
				var data = str(itemdict[datavalues]).to_lower() #find value, get lowercase
				if data.contains(searchquery): #if contains query
					#set_item_disabled(items,false)
					set_item_icon_modulate(items,Color(1.0,1.0,1.0,1.0))
					move_item(items,0)
					contained = true

func _get_drag_data(_pos):
	var data = {}
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.set_size(Vector2(50,50))
	if is_anything_selected():
		data = get_item_metadata(get_selected_items()[0])
		drag_texture.texture = get_item_icon(get_selected_items()[0])
		remove_item(get_selected_items()[0])
	data["item_texture"] = drag_texture.texture
	
	
		
	
	var ctrl = Control.new()
	ctrl.add_child(drag_texture)
	drag_texture.position = -0.5 * drag_texture.size
	
	set_drag_preview(ctrl)
	return data
	
func _can_drop_data(_pos, data):
	if data.get("ID") != null:
		return true
	return false
	
func _drop_data(_pos, data):
	add_icon_item(data["item_texture"], true)
	data["EquipSlot"] = null
	set_item_metadata(item_count-1,data) # index, value
	#print("{")
	for i in range(0,Game.equipped_items.size()): # for each index in the item list ( 0 to size-1)
		#print(i)
		if Game.equipped_items[i].get("ID") != null: # if that index has an ID
			#print("data: " + str(data["ID"]) + " equipped item: " + str(Game.equipped_items[i]["ID"]))
			if Game.equipped_items[i]["ID"] == data.get("ID"): # if the ID is the same as the dropped ID
				Game.items_list.append(data) #Append the dropped item to the equipped list
				Game.equipped_items.remove_at(i) # And remove the original from the item list
				break
	#for i in Game.equipped_items:
		#print("Equipped:" + str(i["ID"]))
	#for i in Game.items_list:
		#print("Inventory:" + str(i["ID"]))
	#print("}")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !interact and is_anything_selected():
		deselect_all()
	if Input.is_action_just_pressed("ui_I"):
		get_node("../../../../CanvasLayer").visible = false
		
	if is_anything_selected():
		if Input.is_action_just_pressed("ui_left_click") and Input.is_action_pressed("ui_shift"):
			var breakout = false
			for slots in get_node("../../../dragdroplayer").get_children():
				if slots.name.left(5) == "Major" and !breakout:
					if slots.slotdata["ID"] == 0:
						breakout = true
						var data = get_item_metadata(get_selected_items()[0])
						if data.get("Ability") == null: # make sure it's not ability
							data["item_texture"] = get_item_icon(get_selected_items()[0])
							slots._drop_data(1,data)
					
		elif Input.is_action_just_pressed("ui_left_click") and Input.is_action_pressed("ui_ctrl"):
			var breakout = false
			for slots in get_node("../../../dragdroplayer").get_children():
				if slots.name.left(5) == "Minor" and !breakout:
					if slots.slotdata["ID"] == 0:
						breakout = true
						var data = get_item_metadata(get_selected_items()[0])
						if data.get("Ability") == null: # make sure it's not an ability
							data["item_texture"] = get_item_icon(get_selected_items()[0])
							slots._drop_data(1,data)
		if Input.is_action_just_pressed("ui_left_click") and get_item_metadata(get_selected_items()[0]).get("Ability") != null:
			# if an ability and left click and hotkey pressed
			if Input.is_action_pressed("ui_1"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "Abili1" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
			if Input.is_action_pressed("ui_2"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "Abili2" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
			if Input.is_action_pressed("ui_3"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "Abili3" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
			if Input.is_action_pressed("ui_4"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "Abili4" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
			if Input.is_action_pressed("ui_5"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "Abili5" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
			if Input.is_action_pressed("ui_6"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "Abili6" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
			if Input.is_action_pressed("ui_shift"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "AbiliS" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
			if Input.is_action_pressed("ui_R"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "AbiliR" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
			if Input.is_action_pressed("ui_F"):
				for slots in get_node("../../../dragdroplayer").get_children():
					if slots.name.left(6) == "AbiliF" and slots.slotdata["ID"] == 0: # if empty
						var data = get_item_metadata(get_selected_items()[0]) 
						data["item_texture"] = get_item_icon(get_selected_items()[0])
						slots._drop_data(1,data)
				
			
	
func _on_ItemList_gui_input(event: InputEvent) -> void:
	item = get_item_at_position(get_local_mouse_position(), true)
	var current
	if event is InputEventMouseMotion:
		interact = true
		if item != -1 or (current != null and current != item):
			select(item, true)
			current = item
			item = -1
		else:
			deselect_all()
			current = null
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if item != -1:
			pass

func _on_gui_input(event):
	_on_ItemList_gui_input(event)
