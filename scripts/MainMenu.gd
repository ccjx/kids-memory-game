extends Control

@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton
@onready var title_label: Label = $VBoxContainer/TitleLabel

func _ready() -> void:
	# Apply UI scaling with pivot at top-left to prevent overflow
	var scale_factor = GameSettings.get_ui_scale_factor()
	pivot_offset = Vector2.ZERO
	scale = Vector2.ONE * scale_factor
	
	# Scale fonts
	title_label.add_theme_font_size_override("font_size", int(64 * scale_factor))
	new_game_button.add_theme_font_size_override("font_size", int(28 * scale_factor))
	settings_button.add_theme_font_size_override("font_size", int(28 * scale_factor))
	exit_button.add_theme_font_size_override("font_size", int(28 * scale_factor))
	
	new_game_button.pressed.connect(_on_new_game_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_new_game_pressed() -> void:
	SceneManager.goto_game()

func _on_settings_pressed() -> void:
	SceneManager.goto_settings()

func _on_exit_pressed() -> void:
	get_tree().quit()
