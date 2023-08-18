extends Sprite2D
signal has_mouse_focus
var buyable = false
var purchaseicon = preload("res://assets/gui/Button06.png")
var whiteicon = preload("res://assets/gui/Button02.png")
var defaulticon = preload("res://assets/gui/Button03.png")
var falseicon = preload("res://assets/gui/Button05.png")
var purchasedicon = preload("res://assets/gui/Button_violet.png")
var gunomancy_talent_tree_info = {
	"Power" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"Increase damage/mischief by 2% per tier",
		"currentbonus":"Current bonus: 0% increased damage/mischief.",
		"requirements":"Prerequisites: none."
	},
	"Poison" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"Deals 1% of Punch as damage/mischief over time, per tier.",
		"currentbonus":"Current bonus: 0% damage/mischief over time.",
		"requirements":"Prerequisites: none."
	},
	"Punish" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"3 seconds after a shot hits an enemy, deals 3% bonus damage/mischief per tier.",
		"currentbonus":"Current bonus: 0% delayed damage/mischief.",
		"requirements":"Prerequisites: none."
	},
	"Profit" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"3% chance per tier to gain an additional 50% CIA Coins whenever CIA Coins are gained.",
		"currentbonus":"Current bonus: 0% bonus coin chance.",
		"requirements":"Prerequisites: none."
	},
	"Promise" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"damage/mischief increases by +0.2% per room, per tier (eg. On 10th room in a run with tier 5 Promise, damage/mischief would be increased by (0.2%)(5)(10) = 10%.",
		"currentbonus":"Current bonus: 0% additional damage/mischief per room.",
		"requirements":"Prerequisites: none."
	},
	"Curse of the Ages" : {
		"currentlvl":0,
		"tier": 1,
		"maxlvl":1,
		"desc":"All DoT and MoT increases by 10%.",		
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 4 Points in [Poison]. 5 Points in Gunomancy."
	},
	"Curse of Dread" : {
		"currentlvl":0,
		"tier": 1,
		"maxlvl":1,
		"desc":"Damage/mischief increases +2% on consecutive shots on the same enemy, increasing up to +10%. If another enemy is hit, this resets.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 4 Points in [Punish]. 5 Points in Gunomancy."
	},
	"Boon of Fortune" : {
		"currentlvl":0,
		"tier": 1,
		"maxlvl":1,
		"desc":"Time Trial rooms become 15% more common. time trial rewards increase by 25%. Red begins her run with +1 luck.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 4 Points in [Profit]. 5 Points in Gunomancy."
	},
	"Boon of the Ages" : {
		"currentlvl":0,
		"tier": 1,
		"maxlvl":1,
		"desc":"Every 5 seconds spent in a room, Punch increases by 2% for that room. Caps at +12% after 60 seconds.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 4 Points in [Promise]. 5 Points in Gunomancy."
	},
	"Hyperactivity" : {
		"currentlvl":0,
		"tier": 2,
		"maxlvl":3,
		"desc":"+5% reload speed per tier, +5% movement speed per tier for 2 seconds after shooting and hitting a target.",
		"currentbonus":"Current bonus: 0% bonus reload speed, 0% bonus movement speed",
		"requirements":"Prerequisites: 4 Points in [Power]. 10 Points in Gunomancy."
	},
	"Boon of Vigor" : {
		"currentlvl":0,
		"tier": 2,
		"maxlvl":3,
		"desc":"Red begins with an additional 5 HP per tier. Red gains +2 health per health stat per tier.",
		"currentbonus":"Current bonus: 0 additional HP. 0 HP bonus per Health stat increase.",
		"requirements":"Prerequisites: 1 Point in [Boon of Fortune]. 10 Points in Gunomancy."
	},
	"Boon of Shields" : {
		"currentlvl":0,
		"tier": 2,
		"maxlvl":5,
		"desc":"All damage received is reduced by 5% per tier.",
		"currentbonus":"Current bonus: 0% damage reduction.",
		"requirements":"Prerequisites: 10 Points in Gunomancy."
	},
	"Jill of All Trades" : {
		"currentlvl":0,
		"tier": 3,
		"maxlvl":12,
		"desc":"Gain +1 to a random stat when beginning a new run, per tier.",
		"currentbonus":"Current bonus: 0 current bonuses",
		"requirements":"Prerequisites: 15 Points in Gunomancy."
	},
	"Vampire's Curse" : {
		"currentlvl":0,
		"tier": 3,
		"maxlvl":3,
		"desc":"Heal 1 HP per shot that hits an enemy, per tier.",
		"currentbonus":"Current bonus: 0 healing per shot",
		"requirements":"Prerequisites: 3 Points in [Boon of Vigor]. 5 points in [Boon of shields]. 15 Points in Gunomancy."
	},
	"Idealistic" : {
		"currentlvl":0,
		"tier": 4,
		"maxlvl":1,
		"desc":"All gun effects gain 1 level. Red gains 2% crit chance for each level V effect she has equipped.",
		"currentbonus":"Current bonus: Not Applied.",
		"requirements":"Prerequisites: 3 Points in [Boon of Vigor]. 5 points in [Boon of shields]. 20 Points in Gunomancy."
	},
	"Red of All Trades" : {
		"currentlvl":0,
		"tier": 4,
		"maxlvl":1,
		"desc":"Begin runs with +1 to all skills.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 12 Points in [Jill of All Trades]. 20 Points in Gunomancy."
	},
	"Trickery" : {
		"currentlvl":0,
		"tier": 5,
		"maxlvl":3,
		"desc":"Increase crit chance by 3% per tier for 5 seconds after using an ability.",
		"currentbonus":"Current bonus: 0% Crit chance increase.",
		"requirements":"Prerequisites: 25 Points in Gunomancy."
	},
	"Lone Wolf" : {
		"currentlvl":0,
		"tier": 5,
		"maxlvl":1,
		"desc":"Gain +15% Punch if Red has no Abilities or Summons equipped.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 25 Points in Gunomancy."
	},
	"Red's Best Friend" : {
		"currentlvl":0,
		"tier": 5,
		"maxlvl":3,
		"desc":"When Red shoots, summons gain 20% attack speed for 10 seconds. This stacks up to (tier) times.",
		"currentbonus":"Current bonus: 0% summon attack speed, stacking up to 0% after 0 shots.",
		"requirements":"Prerequisites: 25 Points in Gunomancy."
	},
	"Gunomancer" : {
		"currentlvl":0,
		"tier": 6,
		"maxlvl":1,
		"desc":"One minor slot becomes a major slot, allowing for 6 effects to be equipped at once instead of 5.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 30 Points in Gunomancy."
	},
}
signal refreshall

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Control").mouse_entered.connect(_on_mouse_entered)
	get_node("Control").mouse_exited.connect(_on_mouse_exited)
	get_node("Control").gui_input.connect(_on_gui_input)
	refreshnums()
	
func _on_gui_input(e):
	if e.button_mask == 1:
		if Game.talent_points > 0 and buyable:
			if Game.player_talents_current[self.name] == gunomancy_talent_tree_info[self.name]["maxlvl"]:
				pass
			else:
				Game.player_talents_current[self.name] +=1
				Game.talent_points -= 1
				Game.talent_points_gun += 1
				refreshbonuses()
				refreshall.emit()
				has_mouse_focus.emit(self.name,gunomancy_talent_tree_info[self.name])
	
func _on_mouse_entered():
	has_mouse_focus.emit(self.name,gunomancy_talent_tree_info[self.name])
	
	if Game.player_talents_current[self.name] == gunomancy_talent_tree_info[self.name]["maxlvl"]:
		texture=purchasedicon
	elif buyable:
		texture = purchaseicon
	else:
		texture = falseicon
	
func _on_mouse_exited():
	if Game.player_talents_current[self.name] == gunomancy_talent_tree_info[self.name]["maxlvl"]:
		texture=purchasedicon
	elif buyable:
		texture=whiteicon
	else:
		texture=defaulticon

func refreshnums():
	var tiernum = gunomancy_talent_tree_info[self.name]["tier"]
	if Game.talent_points_gun < (tiernum * 5):
		buyable = false
	elif self.name == "Curse of the Ages" and (Game.player_talents_current["Poison"] < 4):
		buyable = false
	elif self.name == "Curse of Dread" and (Game.player_talents_current["Punish"] < 4):
		buyable = false
	elif self.name == "Boon of Fortune" and (Game.player_talents_current["Profit"] < 4):
		buyable = false
	elif self.name == "Boon of the Ages" and (Game.player_talents_current["Promise"] < 4):
		buyable = false
	elif self.name == "Hyperactivity" and (Game.player_talents_current["Power"] < 4):
		buyable = false
	elif self.name == "Boon of Vigor" and (Game.player_talents_current["Boon of Fortune"] < 1):
		buyable = false
	elif self.name == "Idealistic" and (Game.player_talents_current["Hyperactivity"] < 3):
		buyable = false
	elif self.name == "Red of All Trades" and (Game.player_talents_current["Jill of All Trades"] < 12):
		buyable = false
	elif self.name == "Vampire's Curse" and (Game.player_talents_current["Boon of Vigor"] < 3 or Game.player_talents_current["Boon of Shields"] < 5):
		buyable = false
	else:
		buyable = true
	if get_node("Label").text != str(Game.player_talents_current[self.name]):
		get_node("Label").text = str(Game.player_talents_current[self.name])
		
	
	
	if Game.player_talents_current[self.name] == gunomancy_talent_tree_info[self.name]["maxlvl"]:
		texture=purchasedicon
	elif buyable:
		texture=whiteicon
	else:
		texture=defaulticon
		
func resetcurrenttalents():
	gunomancy_talent_tree_info = {
	"Power" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"Increase damage/mischief by 2% per tier",
		"currentbonus":"Current bonus: 0% increased damage/mischief.",
		"requirements":"Prerequisites: none."
	},
	"Poison" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"Deals 1% of Punch as damage/mischief over time, per tier.",
		"currentbonus":"Current bonus: 0% damage/mischief over time.",
		"requirements":"Prerequisites: none."
	},
	"Punish" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"3 seconds after a shot hits an enemy, deals 3% bonus damage/mischief per tier.",
		"currentbonus":"Current bonus: 0% delayed damage/mischief.",
		"requirements":"Prerequisites: none."
	},
	"Profit" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"3% chance per tier to gain an additional 50% CIA Coins whenever CIA Coins are gained.",
		"currentbonus":"Current bonus: 0% bonus coin chance.",
		"requirements":"Prerequisites: none."
	},
	"Promise" : {
		"currentlvl":0,
		"tier": 0,
		"maxlvl":5,
		"desc":"damage/mischief increases by +0.2% per room, per tier (eg. On 10th room in a run with tier 5 Promise, damage/mischief would be increased by (0.2%)(5)(10) = 10%.",
		"currentbonus":"Current bonus: 0% additional damage/mischief per room.",
		"requirements":"Prerequisites: none."
	},
	"Curse of the Ages" : {
		"currentlvl":0,
		"tier": 1,
		"maxlvl":1,
		"desc":"All DoT and MoT increases by 10%.",		
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 4 Points in [Poison]. 5 Points in Gunomancy."
	},
	"Curse of Dread" : {
		"currentlvl":0,
		"tier": 1,
		"maxlvl":1,
		"desc":"Damage/mischief increases +2% on consecutive shots on the same enemy, increasing up to +10%. If another enemy is hit, this resets.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 4 Points in [Punish]. 5 Points in Gunomancy."
	},
	"Boon of Fortune" : {
		"currentlvl":0,
		"tier": 1,
		"maxlvl":1,
		"desc":"Time Trial rooms become 15% more common. time trial rewards increase by 25%. Red begins her run with +1 luck.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 4 Points in [Profit]. 5 Points in Gunomancy."
	},
	"Boon of the Ages" : {
		"currentlvl":0,
		"tier": 1,
		"maxlvl":1,
		"desc":"Every 5 seconds spent in a room, Punch increases by 2% for that room. Caps at +12% after 60 seconds.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 4 Points in [Promise]. 5 Points in Gunomancy."
	},
	"Hyperactivity" : {
		"currentlvl":0,
		"tier": 2,
		"maxlvl":3,
		"desc":"+5% reload speed per tier, +5% movement speed per tier for 2 seconds after shooting and hitting a target.",
		"currentbonus":"Current bonus: 0% bonus reload speed, 0% bonus movement speed",
		"requirements":"Prerequisites: 4 Points in [Power]. 10 Points in Gunomancy."
	},
	"Boon of Vigor" : {
		"currentlvl":0,
		"tier": 2,
		"maxlvl":3,
		"desc":"Red begins with an additional 5 HP per tier. Red gains +2 health per health stat per tier.",
		"currentbonus":"Current bonus: 0 additional HP. 0 HP bonus per Health stat increase.",
		"requirements":"Prerequisites: 1 Point in [Boon of Fortune]. 10 Points in Gunomancy."
	},
	"Boon of Shields" : {
		"currentlvl":0,
		"tier": 2,
		"maxlvl":5,
		"desc":"All damage received is reduced by 5% per tier.",
		"currentbonus":"Current bonus: 0% damage reduction.",
		"requirements":"Prerequisites: 10 Points in Gunomancy."
	},
	"Jill of All Trades" : {
		"currentlvl":0,
		"tier": 3,
		"maxlvl":12,
		"desc":"Gain +1 to a random stat when beginning a new run, per tier.",
		"currentbonus":"Current bonus: 0 current bonuses",
		"requirements":"Prerequisites: 15 Points in Gunomancy."
	},
	"Vampire's Curse" : {
		"currentlvl":0,
		"tier": 3,
		"maxlvl":3,
		"desc":"Heal 1 HP per shot that hits an enemy, per tier.",
		"currentbonus":"Current bonus: 0 healing per shot",
		"requirements":"Prerequisites: 3 Points in [Boon of Vigor]. 5 points in [Boon of shields]. 15 Points in Gunomancy."
	},
	"Idealistic" : {
		"currentlvl":0,
		"tier": 4,
		"maxlvl":1,
		"desc":"All gun effects gain 1 level. Red gains 2% crit chance for each level V effect she has equipped.",
		"currentbonus":"Current bonus: Not Applied.",
		"requirements":"Prerequisites: 3 Points in [Boon of Vigor]. 5 points in [Boon of shields]. 20 Points in Gunomancy."
	},
	"Red of All Trades" : {
		"currentlvl":0,
		"tier": 4,
		"maxlvl":1,
		"desc":"Begin runs with +1 to all skills.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 12 Points in [Jill of All Trades]. 20 Points in Gunomancy."
	},
	"Trickery" : {
		"currentlvl":0,
		"tier": 5,
		"maxlvl":3,
		"desc":"Increase crit chance by 3% per tier for 5 seconds after using an ability.",
		"currentbonus":"Current bonus: 0% Crit chance increase.",
		"requirements":"Prerequisites: 25 Points in Gunomancy."
	},
	"Lone Wolf" : {
		"currentlvl":0,
		"tier": 5,
		"maxlvl":1,
		"desc":"Gain +15% Punch if Red has no Abilities or Summons equipped.",
		"currentbonus":"Current bonus: Not Applied",
		"requirements":"Prerequisites: 25 Points in Gunomancy."
	},
	"Red's Best Friend" : {
		"currentlvl":0,
		"tier": 5,
		"maxlvl":3,
		"desc":"When Red shoots, summons gain 10% attack speed for 10 seconds. This stacks up to (tier) times.",
		"currentbonus":"Current bonus: 0% summon attack speed, stacking up to 0% after 0 shots.",
		"requirements":"Prerequisites: 25 Points in Gunomancy."
	},
	"Gunomancer" : {
		"currentlvl":0,
		"tier": 6,
		"maxlvl":1,
		"desc":"One minor slot becomes a major slot, allowing for 6 effects to be equipped at once instead of 5.",
		"currentbonus":"Current bonus: Not Applied.",
		"requirements":"Prerequisites: 30 Points in Gunomancy."
	},
}
		
func refreshbonuses():
	resetcurrenttalents()
	
	
	if Game.player_talents_current["Power"] > 0:
		gunomancy_talent_tree_info["Power"]["currentbonus"] = "Current bonus: " + str(2 * Game.player_talents_current["Power"]) + "% increased damage/mischief."
	if Game.player_talents_current["Poison"] > 0:
		gunomancy_talent_tree_info["Poison"]["currentbonus"] = "Current bonus: " + str(1 * Game.player_talents_current["Poison"]) + "% damage/mischief over time."
	if Game.player_talents_current["Punish"] > 0:
		gunomancy_talent_tree_info["Punish"]["currentbonus"] = "Current bonus: " + str(3 * Game.player_talents_current["Punish"]) + "% delayed damage/mischief."
	if Game.player_talents_current["Profit"] > 0:
		gunomancy_talent_tree_info["Profit"]["currentbonus"] = "Current bonus: " + str(3 * Game.player_talents_current["Profit"]) + "% bonus coin chance."
	if Game.player_talents_current["Promise"] > 0:
		gunomancy_talent_tree_info["Promise"]["currentbonus"] = "Current bonus: " + str(0.2 * Game.player_talents_current["Promise"]) + "% additional damage/mischief per room."
	var bonus_applied
	if Game.player_talents_current["Curse of the Ages"] == 0:
		bonus_applied="Not Applied."
	else:
		bonus_applied="Applied."
	gunomancy_talent_tree_info["Curse of the Ages"]["currentbonus"] = "Current bonus: " + bonus_applied
	if Game.player_talents_current["Curse of Dread"] == 0:
		bonus_applied="Not Applied."
	else:
		bonus_applied="Applied."
	gunomancy_talent_tree_info["Curse of Dread"]["currentbonus"] = "Current bonus: " + bonus_applied
	if Game.player_talents_current["Boon of Fortune"] == 0:
		bonus_applied="Not Applied."
	else:
		bonus_applied="Applied."
	gunomancy_talent_tree_info["Boon of Fortune"]["currentbonus"] = "Current bonus: " + bonus_applied
	if Game.player_talents_current["Boon of the Ages"] == 0:
		bonus_applied="Not Applied."
	else:
		bonus_applied="Applied."
	gunomancy_talent_tree_info["Boon of the Ages"]["currentbonus"] = "Current bonus: " + bonus_applied
	if Game.player_talents_current["Hyperactivity"] > 0:
		gunomancy_talent_tree_info["Hyperactivity"]["currentbonus"] = "Current bonus: " +  str(5 * Game.player_talents_current["Hyperactivity"]) + "% bonus reload speed, " +  str(5 * Game.player_talents_current["Hyperactivity"]) + "% bonus movement speed."
	if Game.player_talents_current["Boon of Vigor"] > 0:
		gunomancy_talent_tree_info["Boon of Vigor"]["currentbonus"] = "Current bonus: " + str(5 * Game.player_talents_current["Boon of Vigor"]) + " additional HP. " + str(2 * Game.player_talents_current["Boon of Vigor"]) + " HP bonus per Health stat increase"
	if Game.player_talents_current["Boon of Shields"] > 0:
		gunomancy_talent_tree_info["Boon of Shields"]["currentbonus"] = "Current bonus: " + str(5 * Game.player_talents_current["Boon of Shields"]) + "% damage reduction."
	if Game.player_talents_current["Jill of All Trades"] > 0:
		gunomancy_talent_tree_info["Jill of All Trades"]["currentbonus"] = "Current bonus: " + str(1 * Game.player_talents_current["Jill of All Trades"]) + " current bonuses."
	if Game.player_talents_current["Vampire's Curse"] > 0:
		gunomancy_talent_tree_info["Vampire's Curse"]["currentbonus"] = "Current bonus: " + str(1 * Game.player_talents_current["Vampire's Curse"]) + " healing per shot."
	if Game.player_talents_current["Idealistic"] == 0:
		bonus_applied="Not Applied."
	else:
		bonus_applied="Applied."
	gunomancy_talent_tree_info["Idealistic"]["currentbonus"] = "Current bonus: " + bonus_applied
	if Game.player_talents_current["Red of All Trades"] == 0:
		bonus_applied="Not Applied."
	else:
		bonus_applied="Applied."
	gunomancy_talent_tree_info["Red of All Trades"]["currentbonus"] = "Current bonus: " + bonus_applied
	if Game.player_talents_current["Trickery"] > 0:
		gunomancy_talent_tree_info["Trickery"]["currentbonus"] = "Current bonus: " + str(3 * Game.player_talents_current["Trickery"]) + "% Crit chance increase."
	if Game.player_talents_current["Lone Wolf"] == 0:
		bonus_applied="Not Applied."
	else:
		bonus_applied="Applied."
	gunomancy_talent_tree_info["Lone Wolf"]["currentbonus"] = "Current bonus: " + bonus_applied
	if Game.player_talents_current["Red's Best Friend"] > 0:
		gunomancy_talent_tree_info["Red's Best Friend"]["currentbonus"] = "Current bonus: 20% summon attack speed, stacking up to " + str(Game.player_talents_current["Red's Best Friend"]) + " times after " + str(Game.player_talents_current["Red's Best Friend"]) + " shots."
	if Game.player_talents_current["Gunomancer"] == 0:
		bonus_applied="Not Applied."
	else:
		bonus_applied="Applied."
	gunomancy_talent_tree_info["Gunomancer"]["currentbonus"] = "Current bonus: " + bonus_applied
	
		
	
	
