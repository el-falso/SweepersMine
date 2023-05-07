extends Control


@onready var game_over_container: PanelContainer = $GameOverContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.game_over.connect(_on_game_over)
	game_over_container.visible = false


func _on_game_over() -> void:
	game_over_container.visible = true
