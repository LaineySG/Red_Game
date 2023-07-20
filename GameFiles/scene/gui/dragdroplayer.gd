extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _can_drop_data(_pos, _data):
	return true
	
func _drop_data(_pos, data):
	if data.get("Name") != null:
		get_node("ScrollContainer/ItemList").add_icon_item(data["item_texture"], true)
		get_node("ScrollContainer/ItemList").set_item_metadata(get_node("ScrollContainer/ItemList").item_count-1,data) # index, value
		data["EquipSlot"] = null
		var repeat = false
		for i in range (0,Game.items_list.size()): # For each item in inventory
			#print(i)
			if Game.items_list[i].get("ID") != null: # If the item isn't null
				if Game.items_list[i]["ID"] == data.get("ID"): #If the ID is the same
					repeat = true
		if !repeat: #If no repeat was found (ie the item wasn't already in the inventory)
			Game.items_list.append(data) # Add the item.
			
		#print(Game.equipped_items)
		for i in range(0,Game.equipped_items.size()):
			if data["ID"] == Game.equipped_items[i]["ID"]:
				Game.equipped_items.remove_at(i)
				break
				
#	print("}")
#	for i in Game.equipped_items:
#		print("Equipped:" + str(i["ID"]))
#	for i in Game.items_list:
#		print("Inventory:" + str(i["ID"]))
#	print("}")
