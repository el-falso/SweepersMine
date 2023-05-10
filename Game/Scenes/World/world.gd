extends Node2D

const TILE := preload("res://Game/Scenes/Tile/Tile.tscn")

var tiles : Array[Tile]
var bomb_tiles : Array[Tile]
var numUnopenedTiles : int
var world : Dictionary = {}


@export var height : int = 8
@export var width : int = 8
@export var mines : int = 9

@onready var playfield: GridContainer = %Playfield

func _ready() -> void:
	width = Global.width
	height = Global.height
	mines = Global.mines
	numUnopenedTiles = height * width
	Global.assumed_mines = mines
	
	# Setup playfield
	playfield.columns = width
	#world.resize(width)
	for x in width:
#		#world[x].resize(height)
		for y in height:
#			#world[x][y] = 0
			world[Vector2(x, y)] = 0
#			var tile : Tile = TILE.instantiate()
#			tile.position = Vector2(x, y) * 32
#			playfield.add_child(tile)
#			tiles.append(tile)
#			tile.has_been_revealed.connect(flood_fill)
	
	_setup_bombs()
	_setup_numbers()

	for y in height:
		for x in width:
			var tile : Tile = TILE.instantiate()
			var value = world[Vector2(x, y)]
			match value:
				-1: #bomb
					tile.has_bomb = true
				0: #Empty
					pass
				_: #Number
					tile.number = value
			tile.position = Vector2(x, y) * 32
			playfield.add_child(tile)
			tiles.append(tile)
			tile.has_been_revealed.connect(flood_fill)
	
	#for tile in tiles:
		#tile._set_color()
	
#	for y in height:
#		var array : Array = []
#		for x in width:
#			array.append(world[Vector2(x, y)])
#		printt(array)
		
func _process(_delta: float) -> void:
	if numUnopenedTiles == mines:
		print("You won")
		EventBus.game_won.emit()
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Game/Scenes/StageSelection/StageSelection.tscn")

func flood_fill(starting_tile: Tile) -> void:
	if starting_tile.number > 0:
		return
	var flood_fill_array : Array[Tile] =[]
	flood_fill_array.append(starting_tile)
	while not flood_fill_array.is_empty():
		var current_tile : Tile = flood_fill_array.pop_front()
		for tile in tiles:
			if tile.position == (current_tile.position - Vector2(32, 0)) or \
				tile.position == (current_tile.position + Vector2(32, 0)) or \
				tile.position == (current_tile.position - Vector2(0, 32)) or \
				tile.position == (current_tile.position + Vector2(0, 32)) or \
				tile.position == (current_tile.position + Vector2(32, 32)) or \
				tile.position == (current_tile.position + Vector2(-32, -32)) or \
				tile.position == (current_tile.position + Vector2(-32, 32)) or \
				tile.position == (current_tile.position + Vector2(32, -32)):
					if not tile.is_revealed and not tile.has_bomb:
						await get_tree().create_timer(0.005).timeout
						tile.is_revealed = true
						if tile.number == 0:
							flood_fill_array.append(tile)
						
func _setup_bombs() -> void:
	var index : int = mines
	while index > 0:
		var x: int = randi_range(0, width-1)
		var y: int = randi_range(0, height-1)
		if world[Vector2(x, y)] != -1:
			world[Vector2(x, y)] = -1
			index -= 1
#		var current_tile : Tile = tiles.pick_random()
#		if not current_tile.has_bomb:
#			current_tile.has_bomb = true
#			bomb_tiles.append(current_tile)
#			index -= 1

func _setup_numbers() -> void:
	#FIX: numbers are wrong in a custom game 
	for x in width:
		for y in height:
			if world[Vector2(x, y)] == -1:
				_increment_numer(x, y-1)
				_increment_numer(x+1, y-1)
				_increment_numer(x+1, y)
				_increment_numer(x+1, y+1)
				_increment_numer(x, y+1)
				_increment_numer(x-1, y+1)
				_increment_numer(x-1, y)
				_increment_numer(x-1, y-1)
				
			pass
	for tile in tiles:
		for bomb in bomb_tiles:
			if (tile.position - bomb.position).length() == 32 or (tile.position - bomb.position).length() <= 32 * sqrt(2):
				tile._increment_number()

func _increment_numer(x: int, y: int) -> void:
	if x >= 0 and y >= 0 and x < width and y < height and world[Vector2(x, y)] != -1:
		world[Vector2(x, y)] += 1
	pass

func get_tile_offset(x: int, y: int) -> Array:
	var array: Array = []
	if x >= 0 and y <= height:
		array.append(Vector2(x, y))
	return array
	pass
