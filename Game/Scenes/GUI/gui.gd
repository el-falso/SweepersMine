extends Control


@onready var game_over_container: VBoxContainer = $GameOverContainer
@onready var game_won_container: PanelContainer = $GameWonContainer


func _ready() -> void:
	EventBus.game_over.connect(_on_game_over)
	EventBus.game_won.connect(_on_game_won, CONNECT_ONE_SHOT)
	game_over_container.visible = false
	game_won_container.visible = false


func _on_game_over() -> void:
	game_over_container.visible = true
	# TODO: maybe don't use a timer, but a button to change scenes, so the player can analyze the playfield
	#await get_tree().create_timer(2.0).timeout
	#get_tree().change_scene_to_file("res://Game/Scenes/StageSelection/StageSelection.tscn")
	
func _on_game_won() -> void:
	game_won_container.visible = true


func _on_btn_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Scenes/StageSelection/StageSelection.tscn")
