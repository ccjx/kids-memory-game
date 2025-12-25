extends Control

const TILE_SCENE = preload("res://scenes/Tile.tscn")

# Image paths for animals
const ANIMAL_IMAGES = [
	"res://assets/images/animals/cat.jpg",
	"res://assets/images/animals/dog.jpg",
	"res://assets/images/animals/elephant.jpg",
	"res://assets/images/animals/fox.jpg",
	"res://assets/images/animals/giraffe.jpg",
	"res://assets/images/animals/lion.jpg",
	"res://assets/images/animals/monkey.jpg",
	"res://assets/images/animals/panda.jpg",
	"res://assets/images/animals/penguin.jpg",
	"res://assets/images/animals/rabbit.jpg",
	"res://assets/images/animals/tiger.jpg",
	"res://assets/images/animals/zebra.jpg"
]

@onready var grid_container: GridContainer = $VBoxContainer/CenterContainer/GridContainer
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var victory_panel: Panel = $VictoryPanel
@onready var play_again_button: Button = $VictoryPanel/VBoxContainer/PlayAgainButton
@onready var menu_button: Button = $VictoryPanel/VBoxContainer/MenuButton
@onready var complete_label: Label = $VictoryPanel/VBoxContainer/Panel/CompleteLabel

var back_texture: Texture2D
var first_tile: Control = null
var second_tile: Control = null
var pairs_found: int = 0
var total_pairs: int = 0
var is_checking: bool = false

func _ready() -> void:
	# Apply UI scaling with pivot at top-left
	var scale_factor = GameSettings.get_ui_scale_factor()
	pivot_offset = Vector2.ZERO
	scale = Vector2.ONE * scale_factor
	
	# Scale fonts
	back_button.add_theme_font_size_override("font_size", int(24 * scale_factor))
	complete_label.add_theme_font_size_override("font_size", int(64 * scale_factor))
	play_again_button.add_theme_font_size_override("font_size", int(28 * scale_factor))
	menu_button.add_theme_font_size_override("font_size", int(28 * scale_factor))
	
	# Load back texture
	back_texture = load("res://assets/images/ui/card_back.svg")
	
	# Hide victory panel
	victory_panel.hide()
	
	# Connect signals
	back_button.pressed.connect(_on_back_pressed)
	play_again_button.pressed.connect(_on_play_again_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Setup board
	setup_board()

func setup_board() -> void:
	# Clear existing tiles
	for child in grid_container.get_children():
		child.queue_free()
	
	# Reset game state
	first_tile = null
	second_tile = null
	pairs_found = 0
	is_checking = false
	
	# Get tile count from settings
	var tile_count = GameSettings.get_tile_count()
	total_pairs = tile_count / 2
	
	# Calculate dynamic tile size based on viewport
	var viewport_size = get_viewport_rect().size
	var available_width = viewport_size.x - 100  # Leave margins
	var available_height = viewport_size.y - 200  # Leave space for UI
	
	# Set grid columns based on tile count
	var columns = 4
	var rows = tile_count / columns
	match tile_count:
		8:
			columns = 4
			rows = 2
		12:
			columns = 4
			rows = 3
		16:
			columns = 4
			rows = 4
		24:
			columns = 6
			rows = 4
	
	grid_container.columns = columns
	
	# Calculate tile size to fit in available space
	var tile_width = (available_width - (columns - 1) * 10) / columns  # 10px spacing
	var tile_height = (available_height - (rows - 1) * 10) / rows
	var tile_size = min(tile_width, tile_height)
	tile_size = clamp(tile_size, 80, 200)  # Min 80px, max 200px
	
	# Create pairs
	var tile_data = []
	for i in range(total_pairs):
		var texture = load(ANIMAL_IMAGES[i])
		tile_data.append({"id": i, "texture": texture})
		tile_data.append({"id": i, "texture": texture})
	
	# Shuffle
	tile_data.shuffle()
	
	# Create tiles
	for data in tile_data:
		var tile = TILE_SCENE.instantiate()
		grid_container.add_child(tile)
		tile.custom_minimum_size = Vector2(tile_size, tile_size)
		tile.setup(data.id, data.texture, back_texture)
		tile.tile_clicked.connect(_on_tile_clicked)

func _on_tile_clicked(tile: Control) -> void:
	if is_checking:
		return
	
	if first_tile == null:
		# First tile clicked
		first_tile = tile
		first_tile.flip()
	elif second_tile == null and tile != first_tile:
		# Second tile clicked
		second_tile = tile
		second_tile.flip()
		is_checking = true
		
		# Check for match after flip animation
		await get_tree().create_timer(0.5).timeout
		check_match()

func check_match() -> void:
	if first_tile.tile_id == second_tile.tile_id:
		# Match found!
		first_tile.set_matched()
		second_tile.set_matched()
		pairs_found += 1
		
		# Reset for next turn
		first_tile = null
		second_tile = null
		is_checking = false
		
		# Check win condition
		if pairs_found == total_pairs:
			show_victory_screen()
	else:
		# No match - show error feedback, then flip back after 2 seconds
		first_tile.play_error_animation()
		second_tile.play_error_animation()
		await get_tree().create_timer(0.5).timeout  # Wait for blink animation
		
		await get_tree().create_timer(1.5).timeout  # Remaining time to 2s total
		first_tile.flip_back()
		second_tile.flip_back()
		
		# Reset for next turn
		first_tile = null
		second_tile = null
		is_checking = false

func show_victory_screen() -> void:
	victory_panel.show()
	
	# Play victory animations
	play_victory_animations()

func play_victory_animations() -> void:
	# Trophy rise from bottom
	await get_tree().create_timer(0.3).timeout
	var trophy_scene = preload("res://scenes/effects/TrophyRise.tscn")
	var trophy = trophy_scene.instantiate()
	victory_panel.add_child(trophy)
	trophy.position = Vector2(victory_panel.size.x / 2, victory_panel.size.y + 100)
	
	var trophy_tween = create_tween().set_parallel(true)
	trophy_tween.tween_property(trophy, "position:y", victory_panel.size.y / 2 - 150, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	trophy_tween.tween_property(trophy, "rotation", deg_to_rad(360), 1.2)
	
	# Fireworks display
	await get_tree().create_timer(0.5).timeout
	for i in range(5):
		var firework_scene = preload("res://scenes/effects/Firework.tscn")
		var firework = firework_scene.instantiate()
		victory_panel.add_child(firework)
		
		var random_x = randf_range(100, victory_panel.size.x - 100)
		var random_y = randf_range(100, victory_panel.size.y - 200)
		firework.position = Vector2(random_x, random_y)
		firework.emitting = true
		
		await get_tree().create_timer(0.4).timeout

func _on_back_pressed() -> void:
	SceneManager.goto_main_menu()

func _on_play_again_pressed() -> void:
	victory_panel.hide()
	setup_board()

func _on_menu_pressed() -> void:
	SceneManager.goto_main_menu()
