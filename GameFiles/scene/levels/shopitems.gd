extends Node2D
var cost
var rng = RandomNumberGenerator.new()
var fivefingerdiscount = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var rarity = get_node("Idea").itemstats["Rarity"]
	if rarity == "Common":
		cost = 20
	if rarity == "Uncommon":
		cost = 30
	if rarity == "Rare":
		cost = 60
	if rarity == "Epic":
		cost = 100
	if rarity == "Insane":
		cost = 160
	if rarity == "Perfect":
		cost = 0
		
	var randcostmod = rng.randf_range(0.5,1.5)
	cost *= randcostmod
		
	cost = int(round(cost))
	
	if Variables.current_room_items.has(self.name):
		if Variables.current_room_items[self.name].has("Cost"):
			cost = Variables.current_room_items[self.name]["Cost"]
	
	Variables.current_room_items[self.name]["Cost"] = cost
	
	get_node("Idea").cost = cost
	get_node("cost").text = str(cost)
	
func fivefingerdiscountset():
	fivefingerdiscount = true
	cost = 0
	get_node("Idea").cost = cost
	get_node("cost").text = str(cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_node("Idea") == null or !get_node("Idea").visible:
		queue_free()
