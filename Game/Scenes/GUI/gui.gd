extends Control


@onready var game_over_container: PanelContainer = $GameOverContainer
@onready var game_won_container: PanelContainer = $GameWonContainer


func _ready() -> void:
	EventBus.game_over.connect(_on_game_over)
	EventBus.game_won.connect(_on_game_won, CONNECT_ONE_SHOT)
	game_over_container.visible = false
	game_won_container.visible = false


func _on_game_over() -> void:
	game_over_container.visible = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Game/Scenes/StageSelection/StageSelection.tscn")
	
func _on_game_won() -> void:
	game_won_container.visible = true
