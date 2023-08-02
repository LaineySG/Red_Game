extends Node2D
var Items = []
var can_sell = false
var inventory_size = 0
@onready var itemlist = get_node("Tutorial UI/dragdroplayer/ScrollContainer/ItemList")
@onready var icon_common = preload("res://assets/item/idea_common.png")
@onready var icon_uncommon = preload("res://assets/item/idea.png")
@onready var icon_rare = preload("res://assets/item/idea_purple.png")
@onready var icon_epic = preload("res://assets/item/idea_orange.png")
@onready var icon_insane = preload("res://assets/item/idea_pink.png")
@onready var icon_perfect = preload("res://assets/item/idea_beige.png")
var icon

# Called when the node enters the scene tree for the first time.
func _ready():
	check_inventory()
	get_node("Tutorial UI").visible = false
	get_node("CanvasLayer").visible = false

func check_inventory():
	
	for item in Game.equipped_items:
		var slot = item["EquipSlot"]
		#print(slot)
		var slotname = slot.left(6)
		var slotdirectory = "Tutorial UI/dragdroplayer/" + slotname
		get_node(slotdirectory)._drop_data(1, item)
	
	for item in Game.equipped_items:
		var missingitem = false
		for j in range(0, get_node("Tutorial UI/dragdroplayer").get_child_count() - 1):
			var currentslot = get_node("Tutorial UI/dragdroplayer").get_child(j)
			if currentslot.name != "ScrollContainer":
				currentslot = currentslot.slotdata["ID"]
				#print("\nEquipped:" +  str(Game.equipped_items))
				var currentequip = item["ID"]
				if currentequip == currentslot: # if the ID is the same as the dropped ID for any square
					missingitem = true
		if !missingitem:
			Game.items_list.append(item) #Append the dropped item to the equipped list
			Game.equipped_items.erase(item) # And remove the original from the item list
			

	
	inventory_size = 0	
	for item in Game.items_list:
		if item.get("EquipSlot") != null:
			Game.equipped_items.append(item)
			Game.items_list.erase(item) 
			
	for items in Game.equipped_items:
		if items["Rarity"] == "Common":
			icon = icon_common
		elif items["Rarity"] == "Uncommon":
			icon = icon_uncommon
		elif items["Rarity"] == "Rare":
			icon = icon_rare
		elif items["Rarity"] == "Epic":
			icon = icon_epic
		elif items["Rarity"] == "Insane":
			icon = icon_insane
		elif items["Rarity"] == "Perfect":
			icon = icon_perfect
			
		var slot = items["EquipSlot"]
		var slotname = slot.left(6)
		var slotdirectory = "Tutorial UI/dragdroplayer/" + slotname
		get_node(slotdirectory)._drop_data(1, items)
		#get_node(slotdirectory).set_item_metadata(inventory_size, Game.items_list[inventory_size])
		inventory_size += 1
			
	
	inventory_size = 0
	itemlist.clear()		
	for items in Game.items_list:
		if items["Rarity"] == "Common":
			icon = icon_common
		elif items["Rarity"] == "Uncommon":
			icon = icon_uncommon
		elif items["Rarity"] == "Rare":
			icon = icon_rare
		elif items["Rarity"] == "Epic":
			icon = icon_epic
		elif items["Rarity"] == "Insane":
			icon = icon_insane
		elif items["Rarity"] == "Perfect":
			icon = icon_perfect
		itemlist.add_icon_item(icon,true) # icon link, selectable
		itemlist.set_item_metadata(inventory_size, Game.items_list[inventory_size])
		inventory_size += 1
		
	#print("inventory:" +  str(Game.items_list))
	#print("\nEquipped:" +  str(Game.equipped_items))
				
				
				
				


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if can_sell:
		get_node("Tutorial UI/dragdroplayer/ScrollContainer/ItemList").can_sell = true
		get_node("CanvasLayer/TextureRect/MarginContainer/RichTextLabel2").can_sell = true
	else:
		get_node("Tutorial UI/dragdroplayer/ScrollContainer/ItemList").can_sell = false
		get_node("CanvasLayer/TextureRect/MarginContainer/RichTextLabel2").can_sell = false
		
	if get_node("Tutorial UI").visible:
		get_node("Tutorial UI/GUI/background/statlayer").visible = true
	else:
		get_node("Tutorial UI/GUI/background/statlayer").visible = false
	
	if Input.is_action_just_pressed("ui_I"):
		check_inventory()
		
	if get_node("Tutorial UI").visible == false:
		if Input.is_action_just_pressed("ui_I"):
			var a = InputEventMouseButton.new()
			a.set_button_index(1)
			a.set_pressed(false)
			Input.parse_input_event(a)
		
	if itemlist.is_anything_selected(): #if something is hovered
			get_node("CanvasLayer").visible = true
			get_node("CanvasLayer/TextureRect").position = get_global_mouse_position() + Vector2(15,15)
			get_node("CanvasLayer/TextureRect/MarginContainer/RichTextLabel2").item_info_parser(itemlist.get_item_metadata(itemlist.get_selected_items()[0]),false)
			
	if Game.items_list.size() != inventory_size:
		check_inventory()
		if get_node("Tutorial UI/LineEdit").text != "":
			get_node("Tutorial UI/dragdroplayer/ScrollContainer/ItemList").searchtext(get_node("Tutorial UI/LineEdit").text)
			
		
	if Input.is_action_just_pressed("ui_I"):
		get_node("CanvasLayer").visible = false
		itemlist.deselect_all()
		check_inventory()
	if Input.is_action_pressed("ui_left_click"):
		get_node("CanvasLayer").visible = false


func _on_texture_rect_on_hover(slotdata):
	#if !get_node("CanvasLayer").visible and slotdata.get("Name") != null: # and the tooltip is hidden
		#get_node("CanvasLayer").visible = true
	if slotdata.get("Name") != null:
		get_node("CanvasLayer").visible = true
		get_node("CanvasLayer/TextureRect").position = get_global_mouse_position() + Vector2(15,15)
		get_node("CanvasLayer/TextureRect/MarginContainer/RichTextLabel2").item_info_parser(slotdata,false)
	#else: 
		#pass #do nothing



func _on_dragdroplayer_mouse_entered():
		get_node("CanvasLayer").visible = false
		itemlist.deselect_all()





func _on_line_edit_text_changed(search_query):
	get_node("Tutorial UI/dragdroplayer/ScrollContainer/ItemList").searchtext(search_query)
