extends Node2D
var Items = []
var can_sell = false
var inventory_size = 0
@onready var itemlist = get_node("Tutorial UI/dragdroplayer/ScrollContainer/ItemList")

var icon = Image.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	check_inventory()
	get_node("Tutorial UI").visible = false
	get_node("Talents").visible = false
	get_node("Stats").visible = false
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
		var squarity = Image.new()
		var icondir = geticonname(items)
		icon = icondir
		if items["Rarity"] == "Common":
			squarity = load("res://assets/gui/icons/squarity_common.png")
		elif items["Rarity"] == "Uncommon":
			squarity = load("res://assets/gui/icons/squarity_uncommon.png")
		elif items["Rarity"] == "Rare":
			squarity = load("res://assets/gui/icons/squarity_rare.png")
		elif items["Rarity"] == "Epic":
			squarity = load("res://assets/gui/icons/squarity_epic.png")
		elif items["Rarity"] == "Insane":
			squarity = load("res://assets/gui/icons/squarity_insane.png")
		elif items["Rarity"] == "Perfect":
			squarity = load("res://assets/gui/icons/squarity_perfect.png")
		
		squarity.blend_rect(icon,Rect2i(0,0,80,80),Vector2(0,0))
			
		var _iconout = ImageTexture.new()
		_iconout = ImageTexture.create_from_image(squarity)
		
		var slot = items["EquipSlot"]
		var slotname = slot.left(6)
		var slotdirectory = "Tutorial UI/dragdroplayer/" + slotname
		get_node(slotdirectory)._drop_data(1, items)
		#get_node(slotdirectory).set_item_metadata(inventory_size, Game.items_list[inventory_size])
		inventory_size += 1
			
	
	inventory_size = 0
	itemlist.clear()		
	for items in Game.items_list:
		var squarity = Image.new()
		var icondir = geticonname(items)
		icon = icondir
		if items["Rarity"] == "Common":
			squarity = load("res://assets/gui/icons/squarity_common.png")
		elif items["Rarity"] == "Uncommon":
			squarity = load("res://assets/gui/icons/squarity_uncommon.png")
		elif items["Rarity"] == "Rare":
			squarity = load("res://assets/gui/icons/squarity_rare.png")
		elif items["Rarity"] == "Epic":
			squarity = load("res://assets/gui/icons/squarity_epic.png")
		elif items["Rarity"] == "Insane":
			squarity = load("res://assets/gui/icons/squarity_insane.png")
		elif items["Rarity"] == "Perfect":
			squarity = load("res://assets/gui/icons/squarity_perfect.png")
		
		squarity.blend_rect(icon,Rect2i(0,0,80,80),Vector2(0,0))
			
		var iconout = ImageTexture.new()
		iconout = ImageTexture.create_from_image(squarity)
		
		itemlist.add_icon_item(iconout,true) # icon link, selectable
		itemlist.set_item_metadata(inventory_size, Game.items_list[inventory_size])
		inventory_size += 1
		
	#print("inventory:" +  str(Game.items_list))
	#print("\nEquipped:" +  str(Game.equipped_items))
				
				
				
				
func geticonname(item):
	if item.get("Effect") != null:
		if item["Effect"] == "Burn Shot (Gun)":
			return load("res://assets/gui/icons/burn.png")
		elif item["Effect"] == "Flame Shot (Gun)":
			return load("res://assets/gui/icons/flame.png")
		elif item["Effect"] == "Berserk (Gun)":
			return load("res://assets/gui/icons/enrage.png")
		elif item["Effect"] == "Frenzy (Gun)":
			return load("res://assets/gui/icons/raccoon-head.png")
		elif item["Effect"] == "Vampire (Gun)":
			return load("res://assets/gui/icons/chewed-heart.png")
		elif item["Effect"] == "Flintlock (Gun)":
			return load("res://assets/gui/icons/cannon-shot.png")
		elif item["Effect"] == "Ricochet (Gun)":
			return load("res://assets/gui/icons/ricochet.png")
		elif item["Effect"] == "Piercing Shot (Gun)":
			return load("res://assets/gui/icons/spiky-wing.png")
		elif item["Effect"] == "Split Shot (Gun)":
			return load("res://assets/gui/icons/split-arrows.png")
		elif item["Effect"] == "Duo-Shot":
			return load("res://assets/gui/icons/duoshot.png")
		elif item["Effect"] == "Tri-Shot":
			return load("res://assets/gui/icons/trishot.png")
		elif item["Effect"] == "Quad-Shot":
			return load("res://assets/gui/icons/quadshot.png")
		elif item["Effect"] == "Big Shot":
			return load("res://assets/gui/icons/bullet-bill.png")
		elif item["Effect"] == "Freeze-Ray (Toygun)":
			return load("res://assets/gui/icons/ice-cube.png")
		elif item["Effect"] == "Shrink-Ray (Toygun)":
			return load("res://assets/gui/icons/ant.png")
		elif item["Effect"] == "Confetti Cannon (Toygun)":
			return load("res://assets/gui/icons/party-popper.png")
		elif item["Effect"] == "Web Shot (Toygun)":
			return load("res://assets/gui/icons/spider-web.png")
		elif item["Effect"] == "Pump-action (Toygun)":
			return load("res://assets/gui/icons/water-gun.png")
		elif item["Effect"] == "Hypno-Ray (Toygun)":
			return load("res://assets/gui/icons/ray-gun.png")
		elif item["Effect"] == "Heart-Shot (Toygun)":
			return load("res://assets/gui/icons/heart-wings.png")
		elif item["Effect"] == "Rainbubble Blaster (Toygun)":
			return load("res://assets/gui/icons/bubbles.png")
		elif item["Effect"] == "Bounce Blaster (Toygun)":
			return load("res://assets/gui/icons/spring.png")
		elif item["Effect"] == "Poison Spray (Gun)":
			return load("res://assets/gui/icons/poison-gas.png")
	elif item.get("Ability") != null:
		if item["Ability"] == "Dash":
			return load("res://assets/gui/icons/sprint.png")
		elif item["Ability"] == "Balloon":
			return load("res://assets/gui/icons/balloons.png")
		elif item["Ability"] == "Teleport":
			return load("res://assets/gui/icons/teleport.png")
		elif item["Ability"] == "Camoflague":
			return load("res://assets/gui/icons/hidden.png")
		elif item["Ability"] == "Sprint":
			return load("res://assets/gui/icons/running-shoe.png")
		elif item["Ability"] == "Shield":
			return load("res://assets/gui/icons/shield.png")
		elif item["Ability"] == "Land Mine":
			return load("res://assets/gui/icons/land-mine.png")
		elif item["Ability"] == "Summon(Green Aliens)":
			return load("res://assets/gui/icons/ufo.png")
		elif item["Ability"] == "Summon(CIA Drone)":
			return load("res://assets/gui/icons/delivery-drone.png")
	else:
		return load("res://assets/gui/icons/light-bulb.png")
		
	#var effects = ["Burn Shot (Gun)", "Flame Shot (Gun)", "Berserk (Gun)", "Frenzy (Gun)", "Vampire (Gun)", "Flintlock (Gun)", "Ricochet (Gun)", "Piercing Shot (Gun)", "Split Shot (Gun)", "Duo-Shot", "Tri-Shot", "Quad-Shot", "Big Shot", "Freeze-Ray (Toygun)", "Shrink-Ray (Toygun)", "Confetti Cannon (Toygun)", "Web Shot (Toygun)", "Pump-action (Toygun)", "Hypno-Ray (Toygun)", "Heart-Shot (Toygun)", "Rainbubble Blaster (Toygun)", "Bounce Blaster (Toygun)", "Poison Spray (Gun)"]
	#var modifications = ["Shot Speed", "Shot Weight", "Punch", "Magazine Size", "Reload Speed", "Fire Rate", "Bullet Size", "Scope", "HP", "Regeneration", "Luck", "Alacrity"]
	#var abilities = ["Dash", "Teleport", "Camoflague", "Sprint", "Summon", "Shield", "Land Mine", "Balloon"]
	#var summons = ["Green Aliens", "CIA Drone"]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if get_node("Tutorial UI").visible or get_node("Stats").visible or get_node("Talents").visible:
		get_node("gui_button_backpack").visible = true
		get_node("gui_button_stats").visible = true
		get_node("gui_button_talents").visible = true
		get_node("gui_label_backpack").visible = true
		get_node("gui_label_stats").visible = true
		get_node("gui_label_talents").visible = true
	else:
		
		get_node("gui_button_backpack").visible = false
		get_node("gui_button_stats").visible = false
		get_node("gui_button_talents").visible = false
		get_node("gui_label_backpack").visible = false
		get_node("gui_label_stats").visible = false
		get_node("gui_label_talents").visible = false
	
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
			a.set_button_index(MOUSE_BUTTON_LEFT)
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


func _on_gui_button_backpack_pressed():
	if !get_node("Tutorial UI").visible:
		get_node("Tutorial UI").visible = true
		get_node("Talents").visible = false
		get_node("Stats").visible = false


func _on_gui_button_talents_pressed():
	if !get_node("Talents").visible:
		get_node("Tutorial UI").visible = false
		get_node("Talents").visible = true
		get_node("Stats").visible = false


func _on_gui_button_stats_pressed():
	if !get_node("Stats").visible:
		get_node("Tutorial UI").visible = false
		get_node("Talents").visible = false
		get_node("Stats").visible = true
