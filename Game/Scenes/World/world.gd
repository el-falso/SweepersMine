extends Node2D

const TILE := preload("res://Game/Scenes/Tile/Tile.tscn")

var tiles : Array[Tile]

@export var height : int = 9
@export var weight : int = 9
@export var mines : int = 8

@onready var playfield: GridContainer = $CenterContainer/Playfield

func _ready() -> void:
	playfield.columns = weight
	for x in weight:
		for y in height:
			var tile : Tile = TILE.instantiate()
			tile.position = Vector2(x, y) * 32
			playfield.add_child(tile)
			tiles.append(tile)
			tile.has_been_revealed.connect(flood_fill)

func flood_fill(starting_tile: Tile) -> void:
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
					if not tile.is_revealed:
						await get_tree().create_timer(0.05).timeout
						tile.is_revealed = true
						flood_fill_array.append(tile)
