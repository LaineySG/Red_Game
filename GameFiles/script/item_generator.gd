extends Node

var effects = ["Burn Shot (Gun)", "Flame Shot (Gun)", "Berserk (Gun)", "Frenzy (Gun)", "Vampire (Gun)", "Flintlock (Gun)", "Ricochet (Gun)", "Piercing Shot (Gun)", "Split Shot (Gun)", "Duo-Shot", "Tri-Shot", "Quad-Shot", "Big Shot", "Freeze-Ray (Toygun)", "Shrink-Ray (Toygun)", "Confetti Cannon (Toygun)", "Web Shot (Toygun)", "Pump-action (Toygun)", "Hypno-Ray (Toygun)", "Heart-Shot (Toygun)", "Rainbubble Blaster (Toygun)", "Bounce Blaster (Toygun)", "Poison Spray (Gun)"]
var modifications = ["Shot Speed", "Shot Weight", "Punch", "Magazine Size", "Reload Speed", "Fire Rate", "Bullet Size", "Scope", "HP", "Regeneration", "Luck", "Alacrity"]
var abilities = ["Dash", "Teleport", "Camoflague", "Sprint", "Summon", "Shield", "Land Mine", "Balloon"]
var summons = ["Green Aliens"]
var rolleditem: Dictionary = {}
# Called when the node enters the scene tree for the first time.
var rarecount = []
func _ready():
	pass
	
func _itemgen(x):
	for k in x:
		rolleditem = {} # resets item each time
		var rng = RandomNumberGenerator.new()
		var type = rng.randf()
		var rarity = 0
		if type < 0.85: # 85% chance of an idea
			var effect_or_not = rng.randf() + (Game.playerstats["Luck"] * 0.01)
			if effect_or_not > 0.5:
				var randeffect = rng.randi_range(0, len(effects) - 1)
				rolleditem["Effect"] = str(effects[randeffect])
				rarity += 4
			else:
				pass #do nothing (No effect only modifications)
				
			var modnum = rng.randf() + (Game.playerstats["Luck"] * 0.01)
			if modnum < 0.50:
				modnum = 1
			elif modnum < 0.75:
				modnum = 2
			elif modnum < 0.90:
				modnum = 3
			else:
				modnum = 4
			rarity += modnum
			var modtracker = [-1,-1,-1,-1]
			var randmod
			for i in modnum:
				randmod = rng.randi_range(0, len(modifications) - 1)
				
				for p in range(modtracker.size()):
					while modtracker[p] == randmod:
						randmod = rng.randi_range(0, len(modifications) - 1)
				
				modtracker[i] = randmod
					
						
				var modbonus = rng.randf() + (Game.playerstats["Luck"] * 0.01)
				if modbonus < 0.50:
					modbonus = 1			 # +
				elif modbonus < 0.75:
					modbonus = 2			 # ++
				elif modbonus < 0.90:
					modbonus = 3 			# +++
				else:
					modbonus = 4 			# ++++
				rolleditem["mod"+str(i)+"bonus"] = modbonus
				rarity += modbonus
				var bonus = ""
				for j in modbonus:
					bonus += "+"
				var currentmod = "Mod_" + str(i)
				rolleditem[str(currentmod)] = str(modifications[randmod] + bonus) # final string
				rolleditem["mod" + str(i) + "raw"] =  str(modifications[randmod])
			rolleditem["RarityNum"] = rarity
			rolleditem["Rarity"] = get_rarity(rarity)
			rolleditem["Name"] = get_item_name(rolleditem,rarity)
			rolleditem["ID"] = rng.randi() + rng.randi()
			return rolleditem
			#print(rolleditem)
			#rarecount.append(rolleditem["Rarity"])
		else: #15% chance of ability
			rarity = 9
			var abilitynum = rng.randi_range(0, len(abilities) - 1)
			var counter = 0
			var max_abilities = len(abilities)
			while Game.givenabilities.has(abilitynum) and counter < max_abilities:
				#print("itemcycle")
				abilitynum = rng.randi_range(0, len(abilities) - 1)
				counter += 1
			Game.givenabilities.append(abilitynum)
			if abilities[abilitynum] == "Summon":
				var summontype = rng.randi_range(0, len(summons) - 1)
				rolleditem["Ability"] = str(abilities[abilitynum]) + "(" + str(summons[summontype]) + ")"
			else:
				rolleditem["Ability"] = str(abilities[abilitynum])
			rolleditem["RarityNum"] = rarity
			rolleditem["Rarity"] = get_rarity(rarity)
			rolleditem["Name"] = get_item_name(rolleditem,rarity)
			rolleditem["ID"] = rng.randi() + rng.randi() 
			return rolleditem
		
func get_rarity(rarity):
	if rarity <= 6:
		return "Common"
	elif rarity <= 9:
		return "Uncommon"
	elif rarity <= 13:
		return "Rare"
	elif rarity <= 16:
		return "Epic"
	elif rarity <= 23:
		return "Insane"
	elif rarity == 24:
		return "Perfect"
		
func get_item_name(rolleditemname,rarity):
	var output = ""
	var rng = RandomNumberGenerator.new()
	var nameseed = rng.randf()
	var prefixseed = rng.randf()
	var ability = rolleditemname.get("Ability")
	var effect = rolleditemname.get("Effect")
	
	if rarity <= 6:
		if prefixseed < 0.1:
			output += "Briggs' "
		elif prefixseed < 0.2:
			output += "Yates' "
		elif prefixseed < 0.3:
			output += "Djikstra's "
		elif prefixseed < 0.4:
			output += "Kruskal's "
		elif prefixseed < 0.5:
			output += "Carroll's "
		elif prefixseed < 0.6:
			output += "Fermat's "
		elif prefixseed < 0.7:
			output += "Jung's "
		elif prefixseed < 0.8:
			output += "Pascal's "
		elif prefixseed < 0.9:
			output += "Pythag's "
		else:
			output += "Cantor's "
	elif rarity <= 9:
		if prefixseed < 0.5:
			output += "Red's "
		else:
			output += "Agent's "
	elif rarity <= 13:
		if prefixseed < 0.5:
			output += "Blue's "
		else:
			output += "Sergeant's "
	elif rarity <= 16:
		if prefixseed < 0.5:
			output += "Grimm's "
		else:
			output += "Officer's "
	elif rarity <= 23:
			output += "Reaper's "
	elif rarity == 24:
		output += "Death's "
	#if ability != null:
		#output += ability    #change next row to elif
	if effect == effects[0]: # "Burn Shot (Gun)"
		if nameseed < 0.33:
			output += "Ash"
		elif nameseed < 0.66:
			output += "Ember"
		else:
			output += "Cinder"
	elif effect == effects[1]: # "Flame Shot (Gun)"
		if nameseed < 0.25:
			output += "Flint"
		elif nameseed < 0.50:
			output += "Fire"
		elif nameseed < 0.75:
			output += "Inferno"
		else:
			output += "Blaze"
	elif effect == effects[2]: # "Berserk (Gun)"
		if nameseed < 0.25:
			output += "Rage"
		elif nameseed < 0.50:
			output += "Fury"
		elif nameseed < 0.75:
			output += "Rampage"
		else:
			output += "Furor"
	elif effect == effects[3]: #"Frenzy (Gun)"
		if nameseed < 0.33:
			output += "Dilemma"
		elif nameseed < 0.66:
			output += "Mania"
		else:
			output += "Madness"
	elif effect == effects[4]: # "Vampire (Gun)"
		if nameseed < 0.33:
			output += "Gore"
		elif nameseed < 0.66:
			output += "Pulse"
		else:
			output += "Carnage"
	elif effect == effects[5]: #"Flintlock (Gun)"
		if nameseed < 0.5:
			output += "Blaster"
		else:
			output += "Piece"
	elif effect == effects[6]: #"Ricochet (Gun)"
		if nameseed < 0.5:
			output += "Backlash"
		else:
			output += "Whiplash"
	elif effect == effects[7]: #"Piercing Shot (Gun)"
		if nameseed < 0.33:
			output += "Piercer"
		elif nameseed < 0.66:
			output += "Cleaver"
		else:
			output += "Gash"
	elif effect == effects[8]: # "Split Shot (Gun)"
		if nameseed < 0.33:
			output += "Hew"
		elif nameseed < 0.66:
			output += "Splitter"
		else:
			output += "Splinter"
	elif effect == effects[9]: #"Duo-Shot"
		if nameseed < 0.33:
			output += "Repeater"
		elif nameseed < 0.66:
			output += "Dyad"
		else:
			output += "Twin"
	elif effect == effects[10]: #"Tri-shot"
		if nameseed < 0.33:
			output += "Triplet"
		elif nameseed < 0.66:
			output += "Triad"
		else:
			output += "Trifecta"
	elif effect == effects[11]: #"Quad-shot"
		if nameseed < 0.33:
			output += "Quadruplet"
		elif nameseed < 0.66:
			output += "Quartet"
		else:
			output += "Quadrivium"
	elif effect == effects[12]: #"Big Shot"
		if nameseed < 0.33:
			output += "Cannon"
		elif nameseed < 0.66:
			output += "Blitzer"
		else:
			output += "Nuke"
	elif effect == effects[13]: #"Freeze-Ray (Toygun)"
		if nameseed < 0.33:
			output += "Frost"
		elif nameseed < 0.66:
			output += "Ice"
		else:
			output += "Rime"
	elif effect == effects[14]: #"Shrink-Ray (Toygun)"
		if nameseed < 0.33:
			output += "Equalizer"
		elif nameseed < 0.66:
			output += "Constrictor"
		else:
			output += "Miniaturizer"
	elif effect == effects[15]: #"Confetti Cannon (Toygun)"
		if nameseed < 0.33:
			output += "Party Cannon!"
		elif nameseed < 0.66:
			output += "Confetterizer"
		else:
			output += "Celebration"
	elif effect == effects[16]: #"Web Shot (Toygun)"
		if nameseed < 0.33:
			output += "Arachno-Blaster"
		elif nameseed < 0.66:
			output += "Gossamer"
		else:
			output = "Cobb's Web" # Removes rarity thing
	elif effect == effects[17]: #"Pump-action (Toygun)"
		if nameseed < 0.33:
			output += "Charger"
		elif nameseed < 0.66:
			output += "Consolidator"
		else:
			output += "Rouser"
	elif effect == effects[18]: #"Hypno-Ray (Toygun)"
		if nameseed < 0.33:
			output += "Talker"
		elif nameseed < 0.66:
			output += "Charisma"
		else:
			output += "Charm"
	elif effect == effects[19]: #"Heart-Shot (Toygun)"
		if nameseed < 0.33:
			output += "Love"
		elif nameseed < 0.66:
			output += "Heart"
		else:
			output += "Kindness"
	elif effect == effects[20]: #"Rainbubble Blaster (Toygun)"
		if nameseed < 0.33:
			output += "Rainbow"
		elif nameseed < 0.66:
			output += "Spectacle"
		else:
			output += "Aurora"
	elif effect == effects[21]: #"Bounce Blaster (Toygun)"
		if nameseed < 0.50:
			output += "Bouncer"
		else:
			output += "Elasticator"
	elif effect == effects[22]: #"Poison Spray (Gun)"
		if nameseed < 0.33:
			output += "Serpent"
		elif nameseed < 0.66:
			output += "Toxicity"
		else:
			output += "Fang"
	elif effect == null and ability == null: #no effect or ability only mods
		if nameseed < 0.2:
			output += "Enigma"
		elif nameseed < 0.4:
			output += "Riddle"
		elif nameseed < 0.6:
			output += "Theorem"
		elif nameseed < 0.8:
			output += "Quandary"
		else:
			output += "Law"
	elif ability != null:
		if nameseed < 0.2:
			output += "Boon"
		elif nameseed < 0.4:
			output += "Favor"
		elif nameseed < 0.6:
			output += "Blessing"
		elif nameseed < 0.8:
			output += "Gift"
		else:
			output += "Virtue"
		
	
		
		
	return output
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
