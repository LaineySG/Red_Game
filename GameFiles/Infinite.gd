extends TileMap

@onready var player = get_parent().get_node("Player")
var moisture = FastNoiseLite.new()
var temp = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 16
var height = 16


func _ready():
	moisture.seed = randi()
	temp.seed = randi()
	altitude.seed = randi()
	


func _process(delta):
	generate_chunk(player.position)

func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var moisture_tile = moisture.get_noise_2d(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y)
			var temp_tile = temp.get_noise_2d(tile_pos.x + x - width/2, tile_pos.y - height/2 + y)
			var altitude_tile = altitude.get_noise_2d(tile_pos.x + x - width/2, tile_pos.y - height/2 + y)
			set_cell(0,Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y), 0,Vector2i(1,1))
	
