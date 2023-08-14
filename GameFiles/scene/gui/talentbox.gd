extends Sprite2D
signal has_mouse_focus
var buyable = true
var purchaseicon = preload("res://assets/gui/Button06.png")
var whiteicon = preload("res://assets/gui/Button02.png")
var defaulticon = preload("res://assets/gui/Button03.png")
var gunomancy_talent_tree_info = {
	"Power" : {
		"currentlvl":0,
		"maxlvl":5,
		"desc":"Increase Punch by 2% per tier",
		"currentbonus":"Increase Punch by 0%.",
		"requirements":"None."
	},
	"Poison" : {
		"currentlvl":0,
		"maxlvl":5,
		"desc":"Deals 1% of Punch as damage/mischief over time, per tier.",
		"currentbonus":"DoT/MoT = 0%.",
		"requirements":"None."
	},
	"Punish" : {
		"currentlvl":0,
		"maxlvl":5,
		"desc":"3 seconds after a shot hits an enemy, deals 3% bonus damage/mischief per tier.",
		"currentbonus":"Bonus delayed damage = 0%.",
		"requirements":"None."
	},
	"Profit" : {
		"currentlvl":0,
		"maxlvl":5,
		"desc":"3% chance per tier to gain an additional 50% CIA Coins whenever CIA Coins are gained.",
		"currentbonus":"Bonus Coin Chance = 0%.",
		"requirements":"None."
	},
	"Promise" : {
		"currentlvl":0,
		"maxlvl":5,
		"desc":"Punch increases by +0.2% per room, per tier (eg. On 10th room in a run with tier 5 Promise, Punch would be increased by (0.2%)(5)(10) = 10%.",
		"currentbonus":"Additonal Punch per room = 0%.",
		"requirements":"None."
	},
	"Curse of the Ages" : {
		"currentlvl":0,
		"maxlvl":1,
		"desc":"All DoT and MoT increases by 10%.",		
		"currentbonus":"Bonus applied: No",
		"requirements":"4 Points in [Poison]. 5 Points in Gunomancy."
	},
	"Curse of Dread" : {
		"currentlvl":0,
		"maxlvl":1,
		"desc":"Damage/mischief increases +2% on consecutive shots on the same enemy, increasing up to +10%. If another enemy is hit, this resets.",
		"currentbonus":"Bonus applied: No",
		"requirements":"4 Points in [Punish]. 5 Points in Gunomancy."
	},
	"Boon of Fortune" : {
		"currentlvl":0,
		"maxlvl":1,
		"desc":"Time Trial rooms become 15% more common. time trial rewards increase by 25%. Red begins her run with +1 luck.",
		"currentbonus":"Bonus applied: No",
		"requirements":"4 Points in [Profit]. 5 Points in Gunomancy."
	},
	"Boon of the Ages" : {
		"currentlvl":0,
		"maxlvl":1,
		"desc":"Every 5 seconds spent in a room, Punch increases by 2% for that room. Caps at +12% after 60 seconds.",
		"currentbonus":"Bonus applied: No",
		"requirements":"4 Points in [Promise]. 5 Points in Gunomancy."
	},
	"Hyperactivity" : {
		"currentlvl":0,
		"maxlvl":3,
		"desc":"+5% reload speed per tier, +5% movement speed per tier for 2 seconds after shooting and hitting a target.",
		"currentbonus":"Bonus applied: No",
		"requirements":"4 Points in [Power]. 10 Points in Gunomancy."
	},
	"Boon of Vigor" : {
		"currentlvl":0,
		"maxlvl":3,
		"desc":"Red begins with an additional 5 HP per tier. Red gains +2 health per health stat per tier.",
		"currentbonus":"Current additional HP: 0. Current HP bonus per stat: 0",
		"requirements":"1 Point in [Boon of Fortune]. 10 Points in Gunomancy."
	},
	"Boon of Shields" : {
		"currentlvl":0,
		"maxlvl":5,
		"desc":"All damage received is reduced by 5% per tier.",
		"currentbonus":"Current damage reduction: 0%",
		"requirements":"10 Points in Gunomancy."
	},
	"Jill of All Trades" : {
		"currentlvl":0,
		"maxlvl":12,
		"desc":"Gain +1 to a random stat when beginning a new run per tier. Once a stat gains the +1, it will not gain another +1.",
		"currentbonus":"Current +1 bonuses: 0",
		"requirements":"15 Points in Gunomancy."
	},
	"Vampire's Curse" : {
		"currentlvl":0,
		"maxlvl":3,
		"desc":"Heal 1 HP per shot that hits an enemy, per tier.",
		"currentbonus":"Current healing per shot: 0",
		"requirements":"3 Points in [Boon of Vigor]. 5 points in [Boon of shields]. 15 Points in Gunomancy."
	},
	"Idealistic" : {
		"currentlvl":0,
		"maxlvl":3,
		"desc":"Once per run, per tier, you can upgrade an item effect's level.",
		"currentbonus":"Current available upgrades per run: 0",
		"requirements":"3 Points in [Boon of Vigor]. 5 points in [Boon of shields]. 20 Points in Gunomancy."
	},
	"Red of All Trades" : {
		"currentlvl":0,
		"maxlvl":1,
		"desc":"Begin runs with +1 to all skills.",
		"currentbonus":"Bonus Applied: No",
		"requirements":"12 Points in [Jill of All Trades]. 20 Points in Gunomancy."
	},
	"Trickery" : {
		"currentlvl":0,
		"maxlvl":3,
		"desc":"Increase crit chance by 3% per tier for 5 seconds after using an ability.",
		"currentbonus":"Crit chance increase: 0%",
		"requirements":"25 Points in Gunomancy."
	},
	"Lone Wolf" : {
		"currentlvl":0,
		"maxlvl":1,
		"desc":"Gain +15% Punch if Red has no Abilities or Summons equipped.",
		"currentbonus":"Bonus Applied: No",
		"requirements":"25 Points in Gunomancy."
	},
	"Red's Best Friend" : {
		"currentlvl":0,
		"maxlvl":3,
		"desc":"When Red shoots, summons gain 10% attack speed. This stacks up to (10 * tier)%.",
		"currentbonus":"Bonus: +0% atttack speed, stacking up to 0 times.",
		"requirements":"25 Points in Gunomancy."
	},
	"Gunomancy" : {
		"currentlvl":0,
		"maxlvl":1,
		"desc":"All gun effects gain 1 level. Red gains 2% crit chance for each level V effect she has equipped.",
		"currentbonus":"Bonus Applied: No.",
		"requirements":"30 Points in Gunomancy."
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(gunomancy_talent_tree_info["Poison"]["desc"])
	get_node("Control").mouse_entered.connect(_on_mouse_entered)
	get_node("Control").mouse_exited.connect(_on_mouse_exited)
	if texture == whiteicon:
		buyable = true
	else:
		buyable = false
	
	
func _on_mouse_entered():
	has_mouse_focus.emit(self.name,gunomancy_talent_tree_info[self.name])
	if buyable:
		texture = purchaseicon
	
func _on_mouse_exited():
	if buyable:
		texture=whiteicon
	else:
		texture=defaulticon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
