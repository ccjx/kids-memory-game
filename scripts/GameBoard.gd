extends Control

const TILE_SCENE = preload("res://scenes/Tile.tscn")

# Image paths for Singapore landmarks
const LANDMARK_IMAGES = [
	"res://assets/images/landmarks/marina_bay_sands.jpg",
	"res://assets/images/landmarks/merlion.jpg",
	"res://assets/images/landmarks/gardens_by_the_bay.jpg",
	"res://assets/images/landmarks/singapore_flyer.jpg",
	"res://assets/images/landmarks/esplanade.jpg",
	"res://assets/images/landmarks/artscience_museum.jpg",
	"res://assets/images/landmarks/sentosa.jpg",
	"res://assets/images/landmarks/chinatown.jpg",
	"res://assets/images/landmarks/little_india.jpg",
	"res://assets/images/landmarks/raffles_hotel.jpg",
	"res://assets/images/landmarks/orchard_road.jpg",
	"res://assets/images/landmarks/jewel_changi.jpg"
]

@onready var grid_container: GridContainer = $VBoxContainer/GridContainer
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var victory_panel: Panel = $VictoryPanel
@onready var play_again_button: Button = $VictoryPanel/VBoxContainer/PlayAgainButton
@onready var menu_button: Button = $VictoryPanel/VBoxContainer/MenuButton

var back_texture: Texture2D
var first_tile: Control = null
var second_tile: Control = null
var pairs_found: int = 0
var total_pairs: int = 0
var is_checking: bool = false

func _ready() -> void:
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
	
	# Set grid columns based on tile count
	match tile_count:
		8:
			grid_container.columns = 4
		12:
			grid_container.columns = 4
		16:
			grid_container.columns = 4
		24:
			grid_container.columns = 6
	
	# Create pairs
	var tile_data = []
	for i in range(total_pairs):
		var texture = load(LANDMARK_IMAGES[i])
		tile_data.append({"id": i, "texture": texture})
		tile_data.append({"id": i, "texture": texture})
	
	# Shuffle
	tile_data.shuffle()
	
	# Create tiles
	for data in tile_data:
		var tile = TILE_SCENE.instantiate()
		grid_container.add_child(tile)
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
		# No match - flip back after 5 seconds
		await get_tree().create_timer(5.0).timeout
		first_tile.flip_back()
		second_tile.flip_back()
		
		# Reset for next turn
		first_tile = null
		second_tile = null
		is_checking = false

func show_victory_screen() -> void:
	victory_panel.show()

func _on_back_pressed() -> void:
	SceneManager.goto_main_menu()

func _on_play_again_pressed() -> void:
	victory_panel.hide()
	setup_board()

func _on_menu_pressed() -> void:
	SceneManager.goto_main_menu()
