extends ItemList

var item
var interact = false
var slotdata = {"ID":0}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



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
