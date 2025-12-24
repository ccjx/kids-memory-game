extends Node

const CONFIG_FILE_PATH = "user://settings.cfg"
const SECTION = "game"
const TILE_COUNT_KEY = "tile_count"

var tile_count: int = 8  # Default: 8 tiles (4 pairs)

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE_PATH)
	
	if err == OK:
		tile_count = config.get_value(SECTION, TILE_COUNT_KEY, 8)
	else:
		# File doesn't exist or error, use defaults
		tile_count = 8
		save_settings()

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value(SECTION, TILE_COUNT_KEY, tile_count)
	config.save(CONFIG_FILE_PATH)

func set_tile_count(count: int) -> void:
	if count in [8, 12, 16, 24]:
		tile_count = count
		save_settings()
	else:
		push_error("Invalid tile count: %d. Must be 8, 12, 16, or 24." % count)

func get_tile_count() -> int:
	return tile_count
