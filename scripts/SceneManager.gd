extends Node

# Scene paths
const MAIN_MENU = "res://scenes/MainMenu.tscn"
const GAME_SCENE = "res://scenes/GameScene.tscn"
const SETTINGS_SCENE = "res://scenes/SettingsScene.tscn"
const ANIMATION_POC = "res://scenes/AnimationPOC.tscn"

var _is_transitioning = false

func change_scene(scene_path: String) -> void:
	if _is_transitioning:
		return
	
	_is_transitioning = true
	
	# Simple fade transition
	var tree = get_tree()
	if tree:
		# Create a fade overlay
		var fade = ColorRect.new()
		fade.color = Color.BLACK
		fade.modulate.a = 0.0
		fade.set_anchors_preset(Control.PRESET_FULL_RECT)
		fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# Add to root
		tree.root.add_child(fade)
		
		# Fade out
		var tween = tree.create_tween()
		tween.tween_property(fade, "modulate:a", 1.0, 0.3)
		await tween.finished
		
		# Change scene
		tree.change_scene_to_file(scene_path)
		
		# Fade in
		var tween2 = tree.create_tween()
		tween2.tween_property(fade, "modulate:a", 0.0, 0.3)
		await tween2.finished
		
		# Clean up
		fade.queue_free()
		_is_transitioning = false

func goto_main_menu() -> void:
	change_scene(MAIN_MENU)

func goto_game() -> void:
	change_scene(GAME_SCENE)

func goto_settings() -> void:
	change_scene(SETTINGS_SCENE)

func goto_animation_poc() -> void:
	change_scene(ANIMATION_POC)
