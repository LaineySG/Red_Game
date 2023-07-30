extends Node2D
var rng = RandomNumberGenerator.new()
@onready var frog = preload("res://scene/mob/frog.tscn")
@onready var boo = preload("res://scene/mob/boo.tscn")
@onready var fluzar = preload("res://scene/mob/fluzar.tscn")

#base stats:
#health, patience, speed, damage, level
var boo_base = [105,75,65,5,1]
var fluzar_base = [85,115,65,5,1]
var frog_base = [140,105,150,15,1]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func instantiate(level,floornum):
	if floornum == 1:
		if level == 1:
			var mobspawnnummax = min(ceil(Game.roomcount / 3.0), 6.0)
			if mobspawnnummax > get_child_count():
				mobspawnnummax = get_child_count()
			var spawn_position
			var enemycount
			if Variables.current_room_enemies.has(str(self.name) + "_enemycount"):
				enemycount = Variables.current_room_enemies[str(self.name) + "_enemycount"]
			else:
				enemycount = rng.randi_range((max(1,mobspawnnummax)), (max(3,mobspawnnummax)))
			Variables.current_room_enemies[str(self.name) + "_enemycount"] = enemycount
			for i in enemycount:
				var which_enemy
				if Variables.current_room_enemies.has(str(self.name) + str(i) + "_enemy"):
					which_enemy = Variables.current_room_enemies[str(self.name) + str(i) + "_enemy"]
				else:
					which_enemy = rng.randf()
				Variables.current_room_enemies[str(self.name) + str(i) + "_enemy"] = which_enemy
				if which_enemy < 0.4:
					spawn_position = get_children()[i].global_position
					var mob = frog.instantiate()
					mob.global_position = spawn_position
					mob.health = frog_base[0] + (Game.roomcount * rng.randf_range(3.0,5.0))
					mob.patience = frog_base[1] + (Game.roomcount * rng.randf_range(2.0,4.0))
					mob.speed = frog_base[2] + (Game.roomcount * rng.randf_range(2.0,4.0))
					mob.damage = frog_base[3] + (Game.roomcount * rng.randf_range(0.7,1.50))
					mob.level = frog_base[4] + floor(Game.roomcount/20.0)
					get_parent().call_deferred("add_child", mob)
				elif which_enemy < 0.8:
					spawn_position = get_children()[i].global_position
					var mob = fluzar.instantiate()
					mob.global_position = spawn_position
					mob.health = fluzar_base[0] + (Game.roomcount * rng.randf_range(2.0,4.0))
					mob.patience = fluzar_base[1] + (Game.roomcount * rng.randf_range(4.0,6.0))
					mob.speed = fluzar_base[2] + (Game.roomcount * rng.randf_range(3.0,5.0))
					mob.damage = fluzar_base[3] + (Game.roomcount * rng.randf_range(0.75,1.25))
					mob.level = fluzar_base[4] + floor(Game.roomcount/10.0)
					get_parent().call_deferred("add_child", mob)
				else:
					spawn_position = get_children()[i].global_position
					var mob = boo.instantiate()
					mob.global_position = spawn_position
					mob.health = boo_base[0] + (Game.roomcount * rng.randf_range(7.0,9.0))
					mob.patience = boo_base[1] + (Game.roomcount * rng.randf_range(3.0,5.0))
					mob.speed = boo_base[2] + (Game.roomcount * rng.randf_range(4.0,6.0))
					mob.damage = boo_base[3] + (Game.roomcount * rng.randf_range(0.75,1.75))
					mob.level = boo_base[4] + floor(Game.roomcount/10.0)
					get_parent().call_deferred("add_child", mob)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
