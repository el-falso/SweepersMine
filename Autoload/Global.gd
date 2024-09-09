extends Node



var height : int = 8
var width : int = 8
var mines : int = 9
var assumed_mines : int

var playfield: World

var easy_mode := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
