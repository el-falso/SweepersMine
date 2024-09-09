extends Control


@onready var btn_classic: Button = %BtnClassic
@onready var btn_easy: Button = %BtnEasy
@onready var btn_medium: Button = %BtnMedium
@onready var btn_expert: Button = %BtnExpert

@onready var slider_width: HSlider = %SliderWidth
@onready var lbl_current_width: Label = %LblCurrentWidth
@onready var slider_height: HSlider = %SliderHeight
@onready var lbl_current_height: Label = %LblCurrentHeight
@onready var slider_mines: HSlider = %SliderMines
@onready var lbl_current_mines: Label = %LblCurrentMines
@onready var btn_play: Button = %BtnPlay

@onready var cb_easy_mode: CheckBox = %CBEasyMode



func _ready() -> void:
	btn_classic.pressed.connect(_on_btn_classic_pressed)
	btn_easy.pressed.connect(_on_btn_easy_pressed)
	btn_medium.pressed.connect(_on_btn_medium_pressed)
	btn_expert.pressed.connect(_on_btn_expert_pressed)
	
	slider_width.value_changed.connect(_on_slider_width_value_changed)
	slider_height.value_changed.connect(_on_slider_height_value_changed)
	slider_mines.value_changed.connect(_on_slider_mines_value_changed)
	btn_play.pressed.connect(_on_btn_play_pressed)
	
	lbl_current_width.text = "%s" % slider_width.value
	lbl_current_height.text = "%s" % slider_height.value
	lbl_current_mines.text = "%s" % slider_mines.value
	
	cb_easy_mode.button_pressed = Global.easy_mode
	

func _on_btn_classic_pressed() -> void:
	Global.width = 8
	Global.height = 8
	Global.mines = 9
	
	get_tree().change_scene_to_file("res://Game/Scenes/World/world.tscn")


func _on_btn_easy_pressed() -> void:
	Global.width = 9
	Global.height = 9
	Global.mines = 10
	
	get_tree().change_scene_to_file("res://Game/Scenes/World/world.tscn")


func _on_btn_medium_pressed() -> void:
	Global.width = 16
	Global.height = 16
	Global.mines = 40
	
	get_tree().change_scene_to_file("res://Game/Scenes/World/world.tscn")


func _on_btn_expert_pressed() -> void:
	Global.width = 20
	Global.height = 16
	Global.mines = 99
	
	get_tree().change_scene_to_file("res://Game/Scenes/World/world.tscn")


func _on_slider_width_value_changed(value: float) -> void:
	lbl_current_width.text = "%s" % value
	slider_mines.min_value = floorf(value * slider_height.value / 10.0)
	slider_mines.max_value = floorf(value * slider_height.value / 1.42)

func _on_slider_height_value_changed(value: float) -> void:
	lbl_current_height.text = "%s" % value
	slider_mines.min_value = floorf(value * slider_width.value / 10.0)
	slider_mines.max_value = floorf(value * slider_width.value / 1.42)
	
func _on_slider_mines_value_changed(value: float) -> void:
	lbl_current_mines.text = "%s" % value

func _on_btn_play_pressed() -> void:
	Global.width = roundi(slider_width.value)
	Global.height = roundi(slider_height.value)
	Global.mines = roundi(slider_mines.value)
	
	get_tree().change_scene_to_file("res://Game/Scenes/World/world.tscn")


func _on_cb_easy_mode_toggled(toggled_on: bool) -> void:
	Global.easy_mode = toggled_on
