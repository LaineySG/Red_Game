extends RichTextLabel

var rarity
var gun_icon = "res://assets/environment/scifi/anims/gunicon.png"
var toygun_icon = "res://assets/environment/scifi/anims/toygunicon.png"
var both_icon = "res://assets/environment/scifi/anims/switchgunicon.png"
var ability_icon = "res://assets/gui/abilityicon.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func item_info_parser(x: Dictionary):
	if str(x.get("Name")) != null:
		var output = ""
		var itemname = x["Name"] if (x.get("Name") != null) else null
		rarity = x["Rarity"] if (x.get("Rarity") != null) else null
		var effect = x["Effect"] if (x.get("Effect") != null) else null
		var _RarityNum = x["RarityNum"] if (x.get("RarityNum") != null) else null
		var ability = x["Ability"] if (x.get("Ability") != null) else null
		var level = x["Level"] if (x.get("Level") != null) else null
		var slot = x["EquipSlot"] if (x.get("EquipSlot") != null) else null
		var toygun_img = false
		var gun_img = false
		
		if effect != null:
			if effect.right(8) == "(Toygun)":
				toygun_img = true
				effect = effect.left(-9)
			elif effect.right(5) == "(Gun)":
				gun_img = true
				effect = effect.left(-6)
			
		var mod0 = x["Mod_0"] if (x.get("Mod_0") != null) else null
		var mod1 = x["Mod_1"] if (x.get("Mod_1") != null) else null
		var mod2 = x["Mod_2"] if (x.get("Mod_2") != null) else null
		var mod3 = x["Mod_3"] if (x.get("Mod_3") != null) else null
		var _id = x["ID"] if (x.get("ID") != null) else null
		
		if rarity == "Common":
			var title_color = "LIGHT_GRAY"
			var border_color = "dark_slate_gray"
			var color = "LIGHT_GRAY"
			var desc_color = "light_slate_gray"
			var accent_color = "pale_goldenrod"
			var accent_desc_color = "papaya_whip"
			if slot != null:
				if slot.left(5) == "Major":
					accent_color = "gold"
			output = "[center][table=1][cell border=" + border_color + "] [font_size=32][color=" + title_color + "]" + itemname + "[/color][/font_size][/cell]"
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + ability + " " + level if ability != null else ""
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + effect + " " + level if effect != null else ""
			
			if effect != null:
				if toygun_img:
					output += "  [img=15x15]" + toygun_icon + "[/img]"
				elif gun_img:
					output  += "  [img=15x15]" + gun_icon + "[/img]"
				else:
					output  += "  [img=15x15]" + both_icon + "[/img]"
			elif ability != null:
				output += "  [img=15x15]" + ability_icon + "[/img]"		
			
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_ability_desc(ability))) if ability != null else ""
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_effect_desc(effect))) if effect != null else ""
			output += "[/color][/cell]"
			if mod0 != null:
				output += "[cell border=" + border_color + "][color=" + color + "]" + mod0 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod0) + "[/color]" + "\n"
			if mod1 != null:
				output += "[color=" + color + "]" + mod1 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod1) + "[/color]" + "\n"
			if mod2 != null:
				output += "[color=" + color + "]" + mod2 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod2) + "[/color]" + "\n"
			if mod3 != null:
				output += "[color=" + color + "]" + mod3 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod3) + "[/color]" + "\n"
			if mod1 != null or mod0 != null or mod2 != null or mod3!=null:
				output += "[/cell]"
				
			output += "\n\n" + "[cell border=" + border_color + "]" + "[color=" + desc_color + "]"
			output += "[font_size=16]" + "[KEY] click: Equip to [KEY]" if ability != null else "[font_size=16]" + "[SHIFT] click: Equip to major" + "\n" + "[CTRL] click: Equip to minor"
			output += "\n\n" + str(rarity) + "[/font_size][/color][/cell][/table][/center]"
			
		elif rarity == "Uncommon":
			var title_color = "cornflower_blue"
			var border_color = "cornflower_blue"
			var color = "LIGHT_GRAY"
			var desc_color = "light_slate_gray"
			var accent_color = "pale_goldenrod"
			var accent_desc_color = "papaya_whip"
			if slot != null:
				if slot.left(5) == "Major":
					accent_color = "gold"
			output = "[center][table=1][cell border=" + border_color + "] [font_size=32][color=" + title_color + "]" + itemname + "[/color][/font_size][/cell]"
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + ability + " " + level if ability != null else ""
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + effect + " " + level if effect != null else ""
			if effect != null:
				if toygun_img:
					output += "  [img=15x15]" + toygun_icon + "[/img]"
				elif gun_img:
					output  += "  [img=15x15]" + gun_icon + "[/img]"
				else:
					output  += "  [img=15x15]" + both_icon + "[/img]"
			elif ability != null:
				output += "  [img=15x15]" + ability_icon + "[/img]"
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_ability_desc(ability))) if ability != null else ""
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_effect_desc(effect))) if effect != null else ""
			output += "[/color][/cell]"
			if mod0 != null:
				output += "[cell border=" + border_color + "][color=" + color + "]" + mod0 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod0) + "[/color]" + "\n"
			if mod1 != null:
				output += "[color=" + color + "]" + mod1 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod1) + "[/color]" + "\n"
			if mod2 != null:
				output += "[color=" + color + "]" + mod2 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod2) + "[/color]" + "\n"
			if mod3 != null:
				output += "[color=" + color + "]" + mod3 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod3) + "[/color]" + "\n"
			if mod1 != null or mod0 != null or mod2 != null or mod3!=null:
				output += "[/cell]"
#
			output += "\n\n" + "[cell border=" + border_color + "]" + "[color=" + desc_color + "]"
			output += "[font_size=16]" + "[KEY] click: Equip to [KEY]" if ability != null else "[font_size=16]" + "[SHIFT] click: Equip to major" + "\n" + "[CTRL] click: Equip to minor"
			output += "\n\n" + str(rarity) + "[/font_size][/color][/cell][/table][/center]"
#
#

		elif rarity == "Rare":
			var title_color = "DARK_MAGENTA"
			var border_color = "DARK_MAGENTA"
			var color = "LIGHT_GRAY"
			var desc_color = "light_slate_gray"
			var accent_color = "pale_goldenrod"
			var accent_desc_color = "papaya_whip"
			if slot != null:
				if slot.left(5) == "Major":
					accent_color = "gold"
			output = "[center][table=1][cell border=" + border_color + "] [font_size=32][color=" + title_color + "]" + itemname + "[/color][/font_size][/cell]"
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + ability + " " + level if ability != null else ""
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + effect + " " + level if effect != null else ""
			
			if effect != null:
				if toygun_img:
					output += "  [img=15x15]" + toygun_icon + "[/img]"
				elif gun_img:
					output  += "  [img=15x15]" + gun_icon + "[/img]"
				else:
					output  += "  [img=15x15]" + both_icon + "[/img]"
			elif ability != null:
				output += "  [img=15x15]" + ability_icon + "[/img]"				
			
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_ability_desc(ability))) if ability != null else ""
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_effect_desc(effect))) if effect != null else ""
			output += "[/color][/cell]"
			if mod0 != null:
				output += "[cell border=" + border_color + "][color=" + color + "]" + mod0 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod0) + "[/color]" + "\n"
			if mod1 != null:
				output += "[color=" + color + "]" + mod1 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod1) + "[/color]" + "\n"
			if mod2 != null:
				output += "[color=" + color + "]" + mod2 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod2) + "[/color]" + "\n"
			if mod3 != null:
				output += "[color=" + color + "]" + mod3 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod3) + "[/color]" + "\n"
			if mod1 != null or mod0 != null or mod2 != null or mod3!=null:
				output += "[/cell]"
		
			output += "\n\n" + "[cell border=" + border_color + "]" + "[color=" + desc_color + "]"
			output += "[font_size=16]" + "[KEY] click: Equip to [KEY]" if ability != null else "[font_size=16]" + "[SHIFT] click: Equip to major" + "\n" + "[CTRL] click: Equip to minor"
			output += "\n\n" + str(rarity) + "[/font_size][/color][/cell][/table][/center]"
			
		elif rarity == "Epic":
			var title_color = "peru"
			var border_color = "peru"
			var color = "LIGHT_GRAY"
			var desc_color = "light_slate_gray"
			var accent_color = "pale_goldenrod"
			var accent_desc_color = "papaya_whip"
			if slot != null:
				if slot.left(5) == "Major":
					accent_color = "gold"
			output = "[center][table=1][cell border=" + border_color + "] [font_size=32][color=" + title_color + "]" + itemname + "[/color][/font_size][/cell]"
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + ability + " " + level if ability != null else ""
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + effect + " " + level if effect != null else ""
			
			if effect != null:
				if toygun_img:
					output += "  [img=15x15]" + toygun_icon + "[/img]"
				elif gun_img:
					output  += "  [img=15x15]" + gun_icon + "[/img]"
				else:
					output  += "  [img=15x15]" + both_icon + "[/img]"
			elif ability != null:
				output += "  [img=15x15]" + ability_icon + "[/img]"				
			
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_ability_desc(ability))) if ability != null else ""
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_effect_desc(effect))) if effect != null else ""
			output += "[/color][/cell]"
			if mod0 != null:
				output += "[cell border=" + border_color + "][color=" + color + "]" + mod0 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod0) + "[/color]" + "\n"
			if mod1 != null:
				output += "[color=" + color + "]" + mod1 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod1) + "[/color]" + "\n"
			if mod2 != null:
				output += "[color=" + color + "]" + mod2 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod2) + "[/color]" + "\n"
			if mod3 != null:
				output += "[color=" + color + "]" + mod3 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod3) + "[/color]" + "\n"
			if mod1 != null or mod0 != null or mod2 != null or mod3!=null:
				output += "[/cell]"
			output += "[cell border=" + border_color + "][color=" + desc_color + "]" + "\nCreme de la Creme.\n " + "[/color][/cell]"
			
			output += "\n\n" + "[cell border=" + border_color + "]" + "[color=" + desc_color + "]"
			output += "[font_size=16]" + "[KEY] click: Equip to [KEY]" if ability != null else "[font_size=16]" + "[SHIFT] click: Equip to major" + "\n" + "[CTRL] click: Equip to minor"
			output += "\n\n" + str(rarity) + "[/font_size][/color][/cell][/table][/center]"
			
		elif rarity == "Insane":
			var title_color = "PALE_VIOLET_RED"
			var border_color = "PALE_VIOLET_RED"
			var color = "LIGHT_GRAY"
			var desc_color = "light_slate_gray"
			var accent_color = "pale_goldenrod"
			var accent_desc_color = "papaya_whip"
			if slot != null:
				if slot.left(5) == "Major":
					accent_color = "gold"
			output = "[center][table=1][cell border=" + border_color + "] [font_size=32][color=" + title_color + "][pulse color=DEEP_PINK freq=1.0 ease=-2.0 height=0]" + itemname + "[/pulse][/color][/font_size][/cell]"
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + ability + " " + level if ability != null else ""
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + effect + " " + level if effect != null else ""
			
			if effect != null:
				if toygun_img:
					output += "  [img=15x15]" + toygun_icon + "[/img]"
				elif gun_img:
					output  += "  [img=15x15]" + gun_icon + "[/img]"
				else:
					output  += "  [img=15x15]" + both_icon + "[/img]"
			elif ability != null:
				output += "  [img=15x15]" + ability_icon + "[/img]"				
			
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_ability_desc(ability))) if ability != null else ""
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_effect_desc(effect))) if effect != null else ""
			output += "[/color][/cell]"
			if mod0 != null:
				output += "[cell border=" + border_color + "][color=" + color + "]" + mod0 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod0) + "[/color]" + "\n"
			if mod1 != null:
				output += "[color=" + color + "]" + mod1 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod1) + "[/color]" + "\n"
			if mod2 != null:
				output += "[color=" + color + "]" + mod2 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod2) + "[/color]" + "\n"
			if mod3 != null:
				output += "[color=" + color + "]" + mod3 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod3) + "[/color]" + "\n"
			if mod1 != null or mod0 != null or mod2 != null or mod3!=null:
				output += "[/cell]"
			output += "[cell border=" + border_color + "][color=" + desc_color + "]" + "\nOne in a hundred.\n " + "[/color][/cell]"
			
			output += "\n\n" + "[cell border=" + border_color + "]" + "[color=" + desc_color + "]"
			output += "[font_size=16]" + "[KEY] click: Equip to [KEY]" if ability != null else "[font_size=16]" + "[SHIFT] click: Equip to major" + "\n" + "[CTRL] click: Equip to minor"
			output += "\n\n" + str(rarity) + "[/font_size][/color][/cell][/table][/center]"
			
		elif rarity == "Perfect":
			var title_color = "NAVAJO_WHITE"
			var border_color = "NAVAJO_WHITE"
			var color = "LIGHT_GRAY"
			var desc_color = "light_slate_gray"
			var accent_color = "pale_goldenrod"
			var accent_desc_color = "papaya_whip"
			if slot != null:
				if slot.left(5) == "Major":
					accent_color = "gold"
			output = "[center][table=1][cell border=" + border_color + "] [font_size=32][color=" + title_color + "][ghost freq=3.0 span=3.0]" + itemname + "[/ghost][/color][/font_size][/cell]"
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + ability + " " + level if ability != null else ""
			output += "[cell border=" + border_color + "][color=" + accent_color + "]" + effect + " " + level if effect != null else ""
			
			if effect != null:
				if toygun_img:
					output += "  [img=15x15]" + toygun_icon + "[/img]"
				elif gun_img:
					output  += "  [img=15x15]" + gun_icon + "[/img]"
				else:
					output  += "  [img=15x15]" + both_icon + "[/img]"
			elif ability != null:
				output += "  [img=15x15]" + ability_icon + "[/img]"				
			
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_ability_desc(ability))) if ability != null else ""
			output += ("[/color][/cell][cell border=" + border_color + "][color=" + accent_desc_color + "]" + str(get_effect_desc(effect))) if effect != null else ""
			output += "[/color][/cell]"
			if mod0 != null:
				output += "[cell border=" + border_color + "][color=" + color + "]" + mod0 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod0) + "[/color]" + "\n"
			if mod1 != null:
				output += "[color=" + color + "]" + mod1 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod1) + "[/color]" + "\n"
			if mod2 != null:
				output += "[color=" + color + "]" + mod2 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod2) + "[/color]" + "\n"
			if mod3 != null:
				output += "[color=" + color + "]" + mod3 + "[/color]" + "\n"
				output += "[color=" + desc_color + "]"
				output += get_mod_desc(mod3) + "[/color]" + "\n"
			if mod1 != null or mod0 != null or mod2 != null or mod3!=null:
				output += "[/cell]"
			output += "[cell border=" + border_color + "][color=" + desc_color + "]" + "\nOne in a million.\n " + "[/color][/cell]"
			
			output += "\n\n" + "[cell border=" + border_color + "]" + "[color=" + desc_color + "]"
			output += "[font_size=16]" + "[KEY] click: Equip to [KEY]" if ability != null else "[font_size=16]" + "[SHIFT] click: Equip to major" + "\n" + "[CTRL] click: Equip to minor"
			output += "\n\n" + str(rarity) + "[/font_size][/color][/cell][/table][/center]"
				
		text = output

func get_mod_desc(mod_name):
	if mod_name.left(10) == "Shot Speed":
		return "Increases speed of the projectile."
	elif mod_name.left(11) == "Shot Weight":
		return "Adds knockback to each shot."
	elif mod_name.left(5) == "Punch":
		return "Increases damage for gun or mischief for toy gun."
	elif mod_name.left(13) == "Magazine Size":
		return "Shoot more before needing to reload."
	elif mod_name.left(12) == "Reload Speed":
		return "Increases reload speed."
	elif mod_name.left(9) == "Fire Rate":
		return "Increases rate of fire."
	elif mod_name.left(11) == "Bullet Size":
		return "Increases size of projectile."
	elif mod_name.left(5) == "Scope":
		return "Increases shot accuracy."
	elif mod_name.left(2) == "HP":
		return "Increases health."
	elif mod_name.left(12) == "Regeneration":
		return "Increases health regeneration on kills and on room completion."
	elif mod_name.left(8) == "Alacrity":
		return "Increases movement and decreases ability cooldowns."
	elif mod_name.left(4) == "Luck":
		return "Increases luck, proc chances, and adds critical hit chance."
	else:
		return "Error encountered."
		
		
func get_effect_desc(effect_name):
	if effect_name == "Burn Shot":
		return "Burns the target for damage over time."
	elif effect_name == "Flame Shot":
		return "Leaves a small flame that burns anything it touches."
	elif effect_name == "Berserk":
		return "Fire rate increases with consecutive shots."
	elif effect_name == "Frenzy":
		return "Fire rate increases based on percentage of HP missing."
	elif effect_name == "Vampire":
		return "Heals for a portion of damage dealt."
	elif effect_name == "Flintlock":
		return "Fire rate decreases, punch and shot size sharply increases."
	elif effect_name == "Ricochet":
		return "Bullets richochet off surfaces."
	elif effect_name == "Piercing Shot":
		return "Bullets pierce through the first enemy hit."
	elif effect_name == "Split Shot":
		return "Bullet pierces through the first enemy hit and splits into two."
	elif effect_name == "Duo-Shot":
		return "Shoots two bullets."
	elif effect_name == "Tri-Shot":
		return "Shoots three bullets."
	elif effect_name == "Quad-Shot":
		return "Shoots four bullets."
	elif effect_name == "Big Shot":
		return "Sharply increases bullet size."
	elif effect_name == "Freeze-Ray":
		return "Slows the target, eventually freezing them in place until thawed."
	elif effect_name == "Shrink-Ray":
		return "Shrinks the target to eventual harmlessness."
	elif effect_name == "Confetti Cannon":
		return "Chance to shoot out confetti that stays around, causing mischief to any who pass through it."
	elif effect_name == "Web Shot":
		return "Chance to stick enemies to the floor temporarily."
	elif effect_name == "Pump-action":
		return "Hold fire to charge shot, increasing mischief at the cost of higher ammunition."
	elif effect_name == "Hypno-Ray":
		return "Chance of enemies fighting for you temporarily."
	elif effect_name == "Heart-Shot":
		return "Shoots out a large red heart that sticks to enemies, causing mischief over time."
	elif effect_name == "Rainbubble Blaster":
		return "Chance to create a large rainbow bubble on impact, causing mischief to any who pass through it."
	elif effect_name == "Bounce Blaster":
		return "Adds an extra bounce to bullets."
	elif effect_name == "Poison Spray":
		return "Chance to shoot out poison cloud that stays around, causing damage to any who pass through it."
	
	
func get_ability_desc(ability_name):
	if ability_name == "Dash":
		return "Allows Red to dash a short distance."
	if ability_name == "Teleport":
		return "Allows Red to teleport a short distance, gaining invulnerability during the dash."
	if ability_name == "Camoflague":
		return "Allows Red to camoflague, turning invisible temporarily to avoid detection."
	if ability_name == "Sprint":
		return "Allows Red to sprint, increasing her speed."
	if ability_name == "Summon(Green Aliens)":
		return "Allows Red to summon mischievous green aliens to aid in combat."
	if ability_name == "Summon(CIA Drone)":
		return "Allows Red to summon a dangerous CIA drone to aid in combat."
	if ability_name == "Shield":
		return "Allows Red to gain a small temporary shield."
	if ability_name == "Land Mine":
		return "Allows Red to place a landmine, exploding on enemy contact for a large amount of damage."
	if ability_name == "Balloon":
		return "Allows Red to place a balloon, popping on enemy contact for a large amount of mischief."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
