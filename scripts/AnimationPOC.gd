extends Control

@onready var demo_card: TextureRect = $MarginContainer/VBoxContainer/DemoArea/DemoPanel/DemoCard
@onready var demo_panel: Panel = $MarginContainer/VBoxContainer/DemoArea/DemoPanel

# Preload demo card texture
var card_texture: Texture2D

func _ready() -> void:
	# Load a demo image
	if ResourceLoader.exists("res://assets/images/animals/1.jpg"):
		card_texture = load("res://assets/images/animals/1.jpg")
		demo_card.texture = card_texture

func _on_back_button_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scene.MAIN_MENU)

# Victory animations
func _on_confetti_burst_pressed() -> void:
	reset_demo_card()
	await get_tree().create_timer(0.1).timeout
	play_confetti_burst()

func _on_star_cascade_pressed() -> void:
	reset_demo_card()
	await get_tree().create_timer(0.1).timeout
	play_star_cascade()

func _on_trophy_rise_pressed() -> void:
	reset_demo_card()
	await get_tree().create_timer(0.1).timeout
	play_trophy_rise()

func _on_fireworks_display_pressed() -> void:
	reset_demo_card()
	await get_tree().create_timer(0.1).timeout
	play_fireworks_display()

# Wrong match animations
func _on_shake_red_flash_pressed() -> void:
	reset_demo_card()
	await get_tree().create_timer(0.1).timeout
	play_shake_red_flash()

func _on_bounce_back_pressed() -> void:
	reset_demo_card()
	await get_tree().create_timer(0.1).timeout
	play_bounce_back()

func _on_wobble_dim_pressed() -> void:
	reset_demo_card()
	await get_tree().create_timer(0.1).timeout
	play_wobble_dim()

func _on_electric_spark_pressed() -> void:
	reset_demo_card()
	await get_tree().create_timer(0.1).timeout
	play_electric_spark()

func reset_demo_card() -> void:
	demo_card.position = Vector2.ZERO
	demo_card.rotation = 0
	demo_card.scale = Vector2.ONE
	demo_card.modulate = Color.WHITE
	demo_card.pivot_offset = demo_card.size / 2

# Victory Animations Implementation

func play_confetti_burst() -> void:
	# Create confetti particles
	var confetti_scene = preload("res://scenes/effects/ConfettiBurst.tscn")
	var confetti = confetti_scene.instantiate()
	demo_panel.add_child(confetti)
	confetti.position = demo_card.position + demo_card.size / 2
	confetti.emitting = true
	
	# Card bounce animation
	var tween = create_tween().set_parallel(true)
	tween.tween_property(demo_card, "scale", Vector2(1.2, 1.2), 0.2)
	tween.tween_property(demo_card, "rotation", deg_to_rad(10), 0.1)
	await tween.finished
	
	var tween2 = create_tween().set_parallel(true)
	tween2.tween_property(demo_card, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween2.tween_property(demo_card, "rotation", 0, 0.3)
	await tween2.finished
	
	await get_tree().create_timer(2.0).timeout
	confetti.queue_free()

func play_star_cascade() -> void:
	# Create star particles
	var stars_scene = preload("res://scenes/effects/StarCascade.tscn")
	var stars = stars_scene.instantiate()
	demo_panel.add_child(stars)
	stars.position = Vector2(demo_panel.size.x / 2, 0)
	stars.emitting = true
	
	# Card glow and scale
	var tween = create_tween()
	tween.tween_property(demo_card, "modulate", Color(1.5, 1.5, 1.0), 0.3)
	tween.tween_property(demo_card, "scale", Vector2(1.15, 1.15), 0.3)
	tween.tween_property(demo_card, "modulate", Color.WHITE, 0.3)
	tween.tween_property(demo_card, "scale", Vector2.ONE, 0.3)
	
	await get_tree().create_timer(2.5).timeout
	stars.queue_free()

func play_trophy_rise() -> void:
	# Create trophy sprite
	var trophy_scene = preload("res://scenes/effects/TrophyRise.tscn")
	var trophy = trophy_scene.instantiate()
	demo_panel.add_child(trophy)
	trophy.position = Vector2(demo_panel.size.x / 2, demo_panel.size.y + 100)
	
	# Animate trophy rising
	var tween = create_tween().set_parallel(true)
	tween.tween_property(trophy, "position:y", demo_panel.size.y / 2, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(trophy, "rotation", deg_to_rad(360), 1.5)
	tween.tween_property(trophy, "modulate:a", 0.0, 0.5).set_delay(2.0)
	
	# Card celebration
	var card_tween = create_tween().set_loops(3)
	card_tween.tween_property(demo_card, "scale", Vector2(1.1, 1.1), 0.2)
	card_tween.tween_property(demo_card, "scale", Vector2.ONE, 0.2)
	
	await tween.finished
	trophy.queue_free()

func play_fireworks_display() -> void:
	# Create multiple firework bursts
	for i in range(5):
		var firework_scene = preload("res://scenes/effects/Firework.tscn")
		var firework = firework_scene.instantiate()
		demo_panel.add_child(firework)
		
		var random_x = randf_range(50, demo_panel.size.x - 50)
		var random_y = randf_range(50, demo_panel.size.y - 50)
		firework.position = Vector2(random_x, random_y)
		firework.emitting = true
		
		await get_tree().create_timer(0.3).timeout
	
	# Card pulse
	var tween = create_tween().set_loops(4)
	tween.tween_property(demo_card, "modulate", Color(1.3, 1.3, 1.3), 0.2)
	tween.tween_property(demo_card, "modulate", Color.WHITE, 0.2)

# Wrong Match Animations Implementation

func play_shake_red_flash() -> void:
	var original_pos = demo_card.position
	
	# Red flash
	var flash_tween = create_tween()
	flash_tween.tween_property(demo_card, "modulate", Color(1.5, 0.3, 0.3), 0.1)
	flash_tween.tween_property(demo_card, "modulate", Color.WHITE, 0.1)
	flash_tween.set_loops(2)
	
	# Shake
	for i in range(8):
		var offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		var shake_tween = create_tween()
		shake_tween.tween_property(demo_card, "position", original_pos + offset, 0.05)
		await shake_tween.finished
	
	demo_card.position = original_pos

func play_bounce_back() -> void:
	var original_pos = demo_card.position
	
	# Move forward then bounce back
	var tween = create_tween()
	tween.tween_property(demo_card, "position:y", original_pos.y - 30, 0.15)
	tween.tween_property(demo_card, "position:y", original_pos.y + 20, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(demo_card, "position:y", original_pos.y, 0.15)

func play_wobble_dim() -> void:
	# Wobble rotation
	var wobble_tween = create_tween()
	wobble_tween.tween_property(demo_card, "rotation", deg_to_rad(15), 0.1)
	wobble_tween.tween_property(demo_card, "rotation", deg_to_rad(-15), 0.1)
	wobble_tween.tween_property(demo_card, "rotation", deg_to_rad(10), 0.1)
	wobble_tween.tween_property(demo_card, "rotation", deg_to_rad(-10), 0.1)
	wobble_tween.tween_property(demo_card, "rotation", 0, 0.1)
	
	# Dim
	var dim_tween = create_tween()
	dim_tween.tween_property(demo_card, "modulate", Color(0.5, 0.5, 0.5), 0.3)
	dim_tween.tween_property(demo_card, "modulate", Color.WHITE, 0.3)

func play_electric_spark() -> void:
	# Create electric spark particles
	var spark_scene = preload("res://scenes/effects/ElectricSpark.tscn")
	var spark = spark_scene.instantiate()
	demo_panel.add_child(spark)
	spark.position = demo_card.position + demo_card.size / 2
	spark.emitting = true
	
	# Card jitter
	var original_pos = demo_card.position
	for i in range(12):
		var offset = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		demo_card.position = original_pos + offset
		await get_tree().create_timer(0.03).timeout
	demo_card.position = original_pos
	
	await get_tree().create_timer(1.0).timeout
	spark.queue_free()
