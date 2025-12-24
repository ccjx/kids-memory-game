extends Control

signal tile_clicked(tile)

@export var front_texture: Texture2D
@export var back_texture: Texture2D

var tile_id: int = -1
var is_flipped: bool = false
var is_matched: bool = false

@onready var texture_rect: TextureRect = $TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Start with back side
	texture_rect.texture = back_texture
	is_flipped = false

func setup(id: int, front: Texture2D, back: Texture2D) -> void:
	tile_id = id
	front_texture = front
	back_texture = back
	if texture_rect:
		texture_rect.texture = back_texture

func flip() -> void:
	if is_matched or is_flipped:
		return
	
	is_flipped = true
	animation_player.play("flip_to_front")

func flip_back() -> void:
	if is_matched:
		return
	
	is_flipped = false
	animation_player.play("flip_to_back")

func set_matched() -> void:
	is_matched = true
	is_flipped = true
	# Could add a matched animation or effect here

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not is_matched and not is_flipped:
				tile_clicked.emit(self)

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "flip_to_front":
		texture_rect.texture = front_texture
	elif anim_name == "flip_to_back":
		texture_rect.texture = back_texture
