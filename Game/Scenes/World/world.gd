extends Node2D

const TILE := preload("res://Game/Scenes/Tile/Tile.tscn")

var tiles : Array[Tile]
var bomb_tiles : Array[Tile]
var numUnopenedTiles : int


@export var height : int = 8
@export var weight : int = 8
@export var mines : int = 9

@onready var playfield: GridContainer = %Playfield

func _ready() -> void:
	weight = Global.weight
	height = Global.height
	mines = Global.mines
	numUnopenedTiles = height * weight
	Global.assumed_mines = mines
	
	# Setup playfield
	playfield.columns = weight
	for x in weight:
		for y in height:
			var tile : Tile = TILE.instantiate()
			tile.position = Vector2(x, y) * 32
			playfield.add_child(tile)
			tiles.append(tile)
			tile.has_been_revealed.connect(flood_fill)
	
	_setup_bombs()
	_setup_numbers()
	#for tile in tiles:
		#tile._set_color()
		
func _process(_delta: float) -> void:
	if numUnopenedTiles == mines:
		print("You won")

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
		var current_tile : Tile = tiles.pick_random()
		if not current_tile.has_bomb:
			current_tile.has_bomb = true
			bomb_tiles.append(current_tile)
			index -= 1

func _setup_numbers() -> void:
	#FIX: numbers are wrong in a custom game 
	for tile in tiles:
		for bomb in bomb_tiles:
			if (tile.position - bomb.position).length() == 32 or (tile.position - bomb.position).length() <= 32 * sqrt(2):
				tile._increment_number()
