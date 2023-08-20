extends Resource
class_name ResourceDataVariables

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
@export var berserkshotcount = 0
@export var talent_points_gun_unspent = 0
@export var talent_points_magic_unspent = 0
@export var talent_points_pets_unspent = 0
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
@export var meringues = 0
@export var eqptracker2 = []
@export var abilityCDs = {}
@export var current_effects_levels = {}
@export var current_abilities_levels = {}

@export var inputIsDisabled = false
@export var tutorial_tooltip_1 = true
@export var blue_conversation_tracker = []
@export var prof_conversation_tracker = []
@export var bob_conversation_tracker = []
@export var grimm_conversation_tracker = []
@export var shop_conversation_tracker = []
@export var current_room_items = {}
@export var current_room_doors = {}
@export var current_room_enemies = {}

@export var player_talents_current = {
	"Power":0, 
	"Poison":0, 
	"Punish":0, 
	"Profit":0, 
	"Promise":0, 
	"Curse of the Ages":0, 
	"Curse of Dread":0, 
	"Boon of Fortune":0, 
	"Boon of the Ages":0,
	"Hyperactivity":0,
	"Boon of Vigor":0,
	"Boon of Shields":0,
	"Jill of All Trades":0,
	"Vampire's Curse":0,
	"Idealistic":0,
	"Red of All Trades":0,
	"Trickery":0,
	"Lone Wolf":0,
	"Red's Best Friend":0,
	"Gunomancer":0,
	}
@export var talent_points = 0
@export var talent_points_gun = 0
@export var talent_points_magic = 0
@export var talent_points_pets = 0

@export var jill_of_all_trades_stat = [0,1,2,3,4,5,6,7,8,9,10,11]
@export var idealistic_crit_count = 0


#settings
@export var enemy_damage_float_toggle = true
@export var player_damage_float_toggle = false
@export var master_volume_slider_value = 0
@export var sfx_volume_slider_value = 0
@export var music_volume_slider_value = 0
#settings

func denitialize():
	inputIsDisabled = Variables.inputIsDisabled
	tutorial_tooltip_1 = Variables.tutorial_tooltip_1
	blue_conversation_tracker = Variables.blue_conversation_tracker
	prof_conversation_tracker = Variables.prof_conversation_tracker
	grimm_conversation_tracker = Variables.grimm_conversation_tracker
	bob_conversation_tracker = Variables.bob_conversation_tracker
	shop_conversation_tracker = Variables.shop_conversation_tracker
	current_room_items = Variables.current_room_items
	current_room_doors = Variables.current_room_doors
	current_room_enemies = Variables.current_room_enemies
	
	
	
	#settings
	enemy_damage_float_toggle = Variables.enemy_damage_float_toggle
	player_damage_float_toggle = Variables.player_damage_float_toggle
	master_volume_slider_value = Variables.master_volume_slider_value
	sfx_volume_slider_value = Variables.sfx_volume_slider_value
	music_volume_slider_value = Variables.music_volume_slider_value
	#settings
	
	
	jill_of_all_trades_stat = Game.jill_of_all_trades_stat
	idealistic_crit_count = Game.idealistic_crit_count
	player_talents_current = Game.player_talents_current
	talent_points = Game.talent_points
	talent_points_gun = Game.talent_points_gun
	talent_points_magic = Game.talent_points_magic
	talent_points_pets = Game.talent_points_pets
	
	playerhp = Game.playerhp
	playerhpmax = Game.playerhpmax
	playergold = Game.playergold
	has_gun = Game.has_gun 
	meringues = Game.meringues
	toy_kill_counter = Game.toy_kill_counter
	givenabilities = Game.givenabilities
	gun_kill_counter = Game.gun_kill_counter
	grimm_gun_kill_counter = Game.grimm_gun_kill_counter
	grimm_toy_kill_counter = Game.grimm_toy_kill_counter
	ammomax = Game.ammomax
	runs = Game.runs
	
	talent_points_gun_unspent = Game.talent_points_gun_unspent
	talent_points_magic_unspent = Game.talent_points_magic_unspent
	talent_points_pets_unspent = Game.talent_points_pets_unspent
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
	abilityCDs = Game.abilityCDs
	current_effects_levels = Game.current_effects_levels
	current_abilities_levels = Game.current_abilities_levels

func initialize():
	Variables.inputIsDisabled= inputIsDisabled
	Variables.tutorial_tooltip_1 = tutorial_tooltip_1
	Variables.blue_conversation_tracker = blue_conversation_tracker
	Variables.prof_conversation_tracker = prof_conversation_tracker
	Variables.grimm_conversation_tracker = grimm_conversation_tracker
	Variables.bob_conversation_tracker = bob_conversation_tracker
	Variables.shop_conversation_tracker = shop_conversation_tracker
	Variables.current_room_items = current_room_items
	Variables.current_room_doors = current_room_doors
	Variables.current_room_enemies = current_room_enemies
	
	
	#settings
	Variables.enemy_damage_float_toggle = enemy_damage_float_toggle
	Variables.player_damage_float_toggle = player_damage_float_toggle
	Variables.master_volume_slider_value = master_volume_slider_value
	Variables.sfx_volume_slider_value = sfx_volume_slider_value
	Variables.music_volume_slider_value = music_volume_slider_value
	#settings
	
	
	
	Game.jill_of_all_trades_stat = jill_of_all_trades_stat
	Game.idealistic_crit_count = idealistic_crit_count
	Game.player_talents_current = player_talents_current 
	Game.talent_points = talent_points
	Game.talent_points_gun = talent_points_gun
	Game.talent_points_magic = talent_points_magic
	Game.talent_points_pets = talent_points_pets
	
	#initialize settings
	var master_bus = AudioServer.get_bus_index("Master")
	var music_bus = AudioServer.get_bus_index("Music")
	var SFX_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(master_bus, master_volume_slider_value)
	AudioServer.set_bus_volume_db(music_bus, music_volume_slider_value)
	AudioServer.set_bus_volume_db(SFX_bus, sfx_volume_slider_value)
	
	#initialize settings
	
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
	Game.meringues = meringues
	Game.berserkshotcount=berserkshotcount
	Game.tutorial_area2count=tutorial_area2count
	Game.roomcount=roomcount
	Game.playershottimer=playershottimer
	Game.inventorylock=inventorylock
	Game.modifications=modifications
	Game.playerstats =playerstats
	Game.current_abilities =current_abilities
	
	
	Game.talent_points_gun_unspent = talent_points_gun_unspent
	Game.talent_points_magic_unspent = talent_points_magic_unspent
	Game.talent_points_pets_unspent = talent_points_pets_unspent
	Game.gun_list=gun_list
	Game.weapon_equipped=weapon_equipped
	Game.items_list=items_list
	Game.equipped_items=equipped_items
	Game.current_effects=current_effects
	Game.eqptracker=eqptracker
	Game.eqptracker2=eqptracker2
	Game.abilityCDs=abilityCDs
	Game.current_effects_levels=current_effects_levels
	Game.current_abilities_levels=current_abilities_levels


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
