extends Resource
class_name Variables_to_load

@export var playerhp = 100
@export var playerhpmax = 100
@export var playergold = 0
@export var has_gun = 1
@export var toy_kill_counter = 0
@export var givenabilities = [] # ensures player doesn't get same ability item twice/run
@export var gun_kill_counter = 0
@export var grimm_gun_kill_counter = 0
@export var grimm_toy_kill_counter = 0
@export var ammomax: int
@export var runs = 0
@export var has_toy_gun = 1
@export var playerDied = false
@export var currentammo = 7
@export var currenttoyammo = 7
@export var berserkshotcount = 0
@export var tutorial_area2count = 0
@export var roomcount = 0
@export var playershottimer = 0.4
@export var inventorylock = false
@export var modifications = ["Shot Speed", "Shot Weight", "Punch", "Magazine Size", "Reload Speed", "Fire Rate", "Bullet Size", "Scope", "HP","Regeneration"]
@export var playerstats = {
	"Shot Speed":0, 
	"Shot Weight":0, 
	"Punch":0, 
	"Magazine Size":0, 
	"Reload Speed":0, 
	"Fire Rate":0, 
	"Bullet Size":0, 
	"Scope":0, 
	"HP":0,
	"Regeneration":0
	}
@export var current_abilities = {}
@export var gun_list = ["gun", "toygun"]
@export var weapon_equipped = "gun"
@export var items_list = []
@export var equipped_items = []
@export var current_effects = []
@export var eqptracker = 0
@export var eqptracker2 = []

@export var inputIsDisabled = false
@export var tutorial_tooltip_1 = true
@export var blue_conversation_tracker = []
@export var prof_conversation_tracker = []
@export var grimm_conversation_tracker = []
@export var shop_conversation_tracker = []

func denitialize():
	inputIsDisabled = Variables.inputIsDisabled
	tutorial_tooltip_1 = Variables.tutorial_tooltip_1
	blue_conversation_tracker = Variables.blue_conversation_tracker
	prof_conversation_tracker = Variables.prof_conversation_tracker
	grimm_conversation_tracker = Variables.grimm_conversation_tracker
	shop_conversation_tracker = Variables.shop_conversation_tracker
	
	playerhp = Game.playerhp
	playerhpmax = Game.playerhpmax
	playergold = Game.playergold
	has_gun = Game.has_gun 
	toy_kill_counter = Game.toy_kill_counter
	givenabilities = Game.givenabilities
	gun_kill_counter = Game.gun_kill_counter
	grimm_gun_kill_counter = Game.grimm_gun_kill_counter
	grimm_toy_kill_counter = Game.grimm_toy_kill_counter
	ammomax = Game.ammomax
	runs = Game.runs
	has_toy_gun = Game.has_toy_gun
	playerDied = Game.playerDied
	currentammo = Game.currentammo
	berserkshotcount = Game.berserkshotcount
	tutorial_area2count = Game.tutorial_area2count
	roomcount = Game.roomcount
	playershottimer = Game.playershottimer
	inventorylock = Game.inventorylock
	modifications = Game.modifications
	playerstats = Game.playerstats
	current_abilities = Game.current_abilities
	gun_list = Game.gun_list
	weapon_equipped = Game.weapon_equipped
	items_list = Game.items_list
	equipped_items = Game.equipped_items
	current_effects = Game.current_effects
	eqptracker = Game.eqptracker
	eqptracker2 = Game.eqptracker2
	currenttoyammo = Game.currenttoyammo

func initialize():
	Variables.inputIsDisabled= inputIsDisabled
	Variables.tutorial_tooltip_1 = tutorial_tooltip_1
	Variables.blue_conversation_tracker = blue_conversation_tracker
	Variables.prof_conversation_tracker = prof_conversation_tracker
	Variables.grimm_conversation_tracker = grimm_conversation_tracker
	Variables.shop_conversation_tracker = shop_conversation_tracker
	
	Game.playerhp = playerhp
	Game.playerhpmax = playerhpmax
	Game.playergold = playergold
	Game.has_gun = has_gun
	Game.toy_kill_counter = toy_kill_counter
	Game.givenabilities = givenabilities
	Game.gun_kill_counter = gun_kill_counter
	Game.grimm_gun_kill_counter = grimm_gun_kill_counter
	Game.grimm_toy_kill_counter = grimm_toy_kill_counter
	Game.ammomax=ammomax
	Game.runs=runs
	Game.has_toy_gun=has_toy_gun
	Game.playerDied=playerDied
	Game.currentammo=currentammo
	Game.berserkshotcount=berserkshotcount
	Game.tutorial_area2count=tutorial_area2count
	Game.roomcount=roomcount
	Game.playershottimer=playershottimer
	Game.inventorylock=inventorylock
	Game.modifications=modifications
	Game.playerstats =playerstats
	Game.current_abilities =current_abilities
	Game.gun_list=gun_list
	Game.weapon_equipped=weapon_equipped
	Game.items_list=items_list
	Game.equipped_items=equipped_items
	Game.current_effects=current_effects
	Game.eqptracker=eqptracker
	Game.eqptracker2=eqptracker2
	Game.currenttoyammo=currenttoyammo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
