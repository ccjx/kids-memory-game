extends Control

@onready var demo_card: TextureRect = $MarginContainer/VBoxContainer/DemoArea/DemoPanel/DemoCard
@onready var demo_panel: Panel = $MarginContainer/VBoxContainer/DemoArea/DemoPanel

var card_texture: Texture2D

func _ready() -> void:
	# Load demo image
	if ResourceLoader.exists("res://assets/images/animals/1.jpg"):
		card_texture = load("res://assets/images/animals/1.jpg")
		demo_card.texture = card_texture
	
	# Ensure pivot is centered
	demo_card.pivot_offset = demo_card.size / 2

func _on_back_button_pressed() -> void:
	SceneManager.goto_main_menu()

# Animation button handlers
func _on_shake_red_flash_pressed() -> void:
	reset_card()
	shake_red_flash()

func _on_bounce_back_pressed() -> void:
	reset_card()
	bounce_back()

func _on_wobble_dim_pressed() -> void:
	reset_card()
	wobble_dim()

func _on_electric_spark_pressed() -> void:
	reset_card()
	electric_spark()

# Reset card to default state
func reset_card() -> void:
	demo_card.rotation = 0.0
	demo_card.scale = Vector2.ONE
	demo_card.modulate = Color.WHITE
	demo_card.pivot_offset = demo_card.size / 2

# Animation 1: Shake with Red Flash
func shake_red_flash() -> void:
	# Flash red twice
	for i in range(2):
		demo_card.modulate = Color(1.8, 0.2, 0.2)
		await get_tree().create_timer(0.1).timeout
		demo_card.modulate = Color.WHITE
		await get_tree().create_timer(0.15).timeout
	
	# Shake 8 times
	for i in range(8):
		demo_card.rotation = deg_to_rad(randf_range(-5, 5))
		await get_tree().create_timer(0.04).timeout
	
	demo_card.rotation = 0.0

# Animation 2: Bounce Back
func bounce_back() -> void:
	# Scale down (move back)
	var tween1 = create_tween()
	tween1.tween_property(demo_card, "scale", Vector2(0.85, 0.85), 0.15)
	await tween1.finished
	
	# Bounce forward
	var tween2 = create_tween()
	tween2.tween_property(demo_card, "scale", Vector2(1.15, 1.15), 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween2.finished
	
	# Return to normal
	var tween3 = create_tween()
	tween3.tween_property(demo_card, "scale", Vector2.ONE, 0.15)
	await tween3.finished

# Animation 3: Wobble and Dim
func wobble_dim() -> void:
	# Start dimming
	var dim_tween = create_tween()
	dim_tween.tween_property(demo_card, "modulate", Color(0.4, 0.4, 0.4), 0.5)
	
	# Wobble back and forth
	var angles = [20, -20, 15, -15, 10, -10, 5, -5, 0]
	for angle in angles:
		demo_card.rotation = deg_to_rad(angle)
		await get_tree().create_timer(0.06).timeout
	
	# Restore brightness
	var restore_tween = create_tween()
	restore_tween.tween_property(demo_card, "modulate", Color.WHITE, 0.3)
	await restore_tween.finished

# Animation 4: Electric Spark
func electric_spark() -> void:
	# Create spark particles
	var spark_scene = preload("res://scenes/effects/ElectricSpark.tscn")
	var spark = spark_scene.instantiate()
	demo_panel.add_child(spark)
	
	# Position at card center
	spark.position = demo_card.position + demo_card.size / 2
	spark.emitting = true
	
	# Jitter the card
	for i in range(15):
		demo_card.rotation = deg_to_rad(randf_range(-3, 3))
		demo_card.scale = Vector2.ONE * randf_range(0.98, 1.02)
		await get_tree().create_timer(0.03).timeout
	
	# Reset
	demo_card.rotation = 0.0
	demo_card.scale = Vector2.ONE
	
	# Clean up particles
	await get_tree().create_timer(0.5).timeout
	spark.queue_free()
