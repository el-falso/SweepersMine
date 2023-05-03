class_name Tile
extends TextureRect

signal has_been_revealed(tile: Tile)

var has_bomb : bool = false:
	set(value):
		has_bomb = value
		$Bomb.visible = true
		is_empty = false
	get:
		return has_bomb
	
var is_empty : bool = true

var number : int = 0:
	set(value):
		number = value
		$Label.text = str(number)
		$Label.modulate = number_to_color(value)
	get:
		return number

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
		if value:
			#TODO: needs overhaul, really ugly coded
			get_parent().get_parent().get_parent().numUnopenedTiles -= 1
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
				Global.assumed_mines = Global.assumed_mines - 1 if is_flagged else Global.assumed_mines + 1
				EventBus.on_mines_changes.emit()
		if event.is_action_pressed("reveal"):
			if not is_revealed:
				is_revealed = true
				has_been_revealed.emit(self)

func _increment_number() -> void:
	$Label.visible = true
	number += 1
	$Label.text = str(number)

func _set_color() -> void:
	if has_bomb:
		modulate = Color.RED
	if is_empty:
		modulate = Color.BLUE


func number_to_color(number: int) -> Color:
	match number:
		1:
			return Color.CORNFLOWER_BLUE
		2:
			return Color.GREEN_YELLOW
		3:
			return Color.RED
		4:
			return Color.DARK_BLUE
		5:
			return Color.BROWN
		6:
			return Color.DARK_SEA_GREEN
		7:
			return Color.BLUE_VIOLET
		8:
			return Color.DIM_GRAY
		_:
			return Color.WHITE
