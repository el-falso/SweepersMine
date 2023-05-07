extends MarginContainer

var time_elapsed : float
var is_timer_started : bool = true

@onready var mines_amount_label: Label = %MinesAmountLabel
@onready var label: Label = $VBoxContainer/Time/Label


func _ready() -> void:
	EventBus.on_mines_changes.connect(_on_mines_change)
	EventBus.game_over.connect(_on_timer_stop)


func _process(delta: float) -> void:
	if is_timer_started:
		time_elapsed += delta
		
		var minutes := time_elapsed / 60
		var seconds := fmod(time_elapsed, 60)
		var milliseconds := fmod(time_elapsed, 1) * 100
		label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]


func _on_mines_change() -> void:
	mines_amount_label.text = "%s" % Global.assumed_mines


func _on_timer_stop() -> void:
	is_timer_started = false
