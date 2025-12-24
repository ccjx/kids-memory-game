extends Node

const CONFIG_FILE_PATH = "user://settings.cfg"
const SECTION = "game"
const TILE_COUNT_KEY = "tile_count"
const RESOLUTION_KEY = "resolution"

# Resolution presets
enum Resolution {
	DESKTOP = 0,        # 1920x1080
	HIGH_DPI = 1,       # 2560x1440
	IPAD_MINI = 2       # 2048x1536
}

const RESOLUTION_SIZES = {
	Resolution.DESKTOP: Vector2i(1920, 1080),
	Resolution.HIGH_DPI: Vector2i(2560, 1440),
	Resolution.IPAD_MINI: Vector2i(2048, 1536)
}

var tile_count: int = 8  # Default: 8 tiles (4 pairs)
var current_resolution: Resolution = Resolution.DESKTOP

func _ready() -> void:
	load_settings()
	apply_resolution()

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE_PATH)
	
	if err == OK:
		tile_count = config.get_value(SECTION, TILE_COUNT_KEY, 8)
		current_resolution = config.get_value(SECTION, RESOLUTION_KEY, Resolution.DESKTOP)
	else:
		# File doesn't exist or error, auto-detect and use defaults
		auto_detect_resolution()
		tile_count = 8
		save_settings()

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value(SECTION, TILE_COUNT_KEY, tile_count)
	config.set_value(SECTION, RESOLUTION_KEY, current_resolution)
	config.save(CONFIG_FILE_PATH)

func set_tile_count(count: int) -> void:
	if count in [8, 12, 16, 24]:
		tile_count = count
		save_settings()
	else:
		push_error("Invalid tile count: %d. Must be 8, 12, 16, or 24." % count)

func get_tile_count() -> int:
	return tile_count

func set_resolution(res: Resolution) -> void:
	current_resolution = res
	save_settings()
	apply_resolution()

func get_resolution() -> Resolution:
	return current_resolution

func apply_resolution() -> void:
	var size = RESOLUTION_SIZES[current_resolution]
	DisplayServer.window_set_size(size)
	# Center window on screen
	var screen_size = DisplayServer.screen_get_size()
	var window_pos = (screen_size - size) / 2
	DisplayServer.window_set_position(window_pos)

func auto_detect_resolution() -> void:
	var screen_size = DisplayServer.screen_get_size()
	
	# Auto-detect based on screen size
	if screen_size.x >= 2560:
		current_resolution = Resolution.HIGH_DPI
	elif screen_size.x >= 2048 and abs(float(screen_size.x) / float(screen_size.y) - 4.0/3.0) < 0.1:
		current_resolution = Resolution.IPAD_MINI
	else:
		current_resolution = Resolution.DESKTOP

func get_resolution_name(res: Resolution) -> String:
	match res:
		Resolution.DESKTOP:
			return "Desktop (1920x1080)"
		Resolution.HIGH_DPI:
			return "High-DPI (2560x1440)"
		Resolution.IPAD_MINI:
			return "iPad Mini (2048x1536)"
		_:
			return "Unknown"
