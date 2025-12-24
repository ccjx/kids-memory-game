extends Control

@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_new_game_pressed() -> void:
	SceneManager.goto_game()

func _on_settings_pressed() -> void:
	SceneManager.goto_settings()

func _on_exit_pressed() -> void:
	get_tree().quit()
