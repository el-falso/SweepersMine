class_name Tile
extends TextureRect

signal has_been_revealed(tile: Tile)

var has_bomb : bool = false
var is_empty : bool = true

var is_flagged : bool = false:
	set(value):
		is_flagged = value
		$Flag.visible = value
	get:
		return is_flagged

var is_revealed : bool = false:
	set(value):
		is_revealed = value
		$Cover.visible = not value
	get:
		return is_revealed

@onready var bomb: TextureRect = $Bomb

func _ready() -> void:
	bomb.visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("mouse_right"):
			if not is_revealed:
				is_flagged = !is_flagged
		if event.is_action_pressed("reveal"):
			if not is_revealed:
				is_revealed = true
				has_been_revealed.emit(self)
