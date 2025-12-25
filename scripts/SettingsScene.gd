extends Control

@onready var tile_count_option: OptionButton = $VBoxContainer/TileCountContainer/OptionButton
@onready var resolution_option: OptionButton = $VBoxContainer/ResolutionContainer/OptionButton
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var tile_label: Label = $VBoxContainer/TileCountContainer/Label
@onready var resolution_label: Label = $VBoxContainer/ResolutionContainer/Label

func _ready() -> void:
	# Apply UI scaling with pivot at top-left
	var scale_factor = GameSettings.get_ui_scale_factor()
	pivot_offset = Vector2.ZERO
	scale = Vector2.ONE * scale_factor
	
	# Scale fonts
	title_label.add_theme_font_size_override("font_size", int(48 * scale_factor))
	tile_label.add_theme_font_size_override("font_size", int(24 * scale_factor))
	tile_count_option.add_theme_font_size_override("font_size", int(24 * scale_factor))
	resolution_label.add_theme_font_size_override("font_size", int(24 * scale_factor))
	resolution_option.add_theme_font_size_override("font_size", int(24 * scale_factor))
	back_button.add_theme_font_size_override("font_size", int(24 * scale_factor))
	
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
	# Update UI scaling for this scene
	var scale_factor = GameSettings.get_ui_scale_factor()
	pivot_offset = Vector2.ZERO
	scale = Vector2.ONE * scale_factor
	
	# Re-apply font sizes
	title_label.add_theme_font_size_override("font_size", int(48 * scale_factor))
	tile_label.add_theme_font_size_override("font_size", int(24 * scale_factor))
	tile_count_option.add_theme_font_size_override("font_size", int(24 * scale_factor))
	resolution_label.add_theme_font_size_override("font_size", int(24 * scale_factor))
	resolution_option.add_theme_font_size_override("font_size", int(24 * scale_factor))
	back_button.add_theme_font_size_override("font_size", int(24 * scale_factor))

func _on_back_pressed() -> void:
	SceneManager.goto_main_menu()
