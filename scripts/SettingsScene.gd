extends Control

@onready var tile_count_option: OptionButton = $VBoxContainer/TileCountContainer/OptionButton
@onready var resolution_option: OptionButton = $VBoxContainer/ResolutionContainer/OptionButton
@onready var back_button: Button = $VBoxContainer/BackButton

func _ready() -> void:
	# Setup tile count options
	tile_count_option.clear()
	tile_count_option.add_item("8 Tiles", 0)
	tile_count_option.add_item("12 Tiles", 1)
	tile_count_option.add_item("16 Tiles", 2)
	tile_count_option.add_item("24 Tiles", 3)
	
	# Load current tile count setting
	var current_count = GameSettings.get_tile_count()
	match current_count:
		8:
			tile_count_option.selected = 0
		12:
			tile_count_option.selected = 1
		16:
			tile_count_option.selected = 2
		24:
			tile_count_option.selected = 3
	
	# Setup resolution options
	resolution_option.clear()
	resolution_option.add_item(GameSettings.get_resolution_name(GameSettings.Resolution.DESKTOP), GameSettings.Resolution.DESKTOP)
	resolution_option.add_item(GameSettings.get_resolution_name(GameSettings.Resolution.HIGH_DPI), GameSettings.Resolution.HIGH_DPI)
	resolution_option.add_item(GameSettings.get_resolution_name(GameSettings.Resolution.IPAD_MINI), GameSettings.Resolution.IPAD_MINI)
	
	# Load current resolution setting
	var current_res = GameSettings.get_resolution()
	resolution_option.selected = current_res
	
	# Connect signals
	tile_count_option.item_selected.connect(_on_tile_count_selected)
	resolution_option.item_selected.connect(_on_resolution_selected)
	back_button.pressed.connect(_on_back_pressed)

func _on_tile_count_selected(index: int) -> void:
	var counts = [8, 12, 16, 24]
	GameSettings.set_tile_count(counts[index])

func _on_resolution_selected(index: int) -> void:
	GameSettings.set_resolution(index as GameSettings.Resolution)

func _on_back_pressed() -> void:
	SceneManager.goto_main_menu()
