extends Control

var time_elapsed : float

@onready var mines_amount_label: Label = %MinesAmountLabel
@onready var label: Label = $VBoxContainer/Time/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.on_mines_changes.connect(_on_mines_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	
	var minutes := time_elapsed / 60
	var seconds := fmod(time_elapsed, 60)
	var milliseconds := fmod(time_elapsed, 1) * 100
	label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func _on_mines_change() -> void:
	mines_amount_label.text = "%s" % Global.assumed_mines
