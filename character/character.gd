extends Node2D
class_name Character

@onready var hat_sprite: Sprite2D = $CompositeSprite/Hat
@onready var shirt_sprite: Sprite2D = $CompositeSprite/Shirt
@onready var pants_sprite: Sprite2D = $CompositeSprite/Pants
@onready var body_sprite: Sprite2D = $CompositeSprite/Body

signal character_clicked(test: State)

enum State {IDLE, ROAM, DESPAWN}

@export_category("State Machine")
@export var _current_state: State = State.ROAM
@export_category("Idle State")
@export var idle_time_min: float = 0
@export var idle_time_max: float = 0
@export_category("Roam State")
@export var roam_speed: float = 0
@export var roam_radius: float = 0
@export var roam_next_position: Vector2 = Vector2.ZERO
@export_category("Despawn State")
@export var despawn_next_position: Vector2 = Vector2.ZERO
@export_category("Boundary")
@export var x_min: int = 0
@export var x_max: int = 0
@export var y_min: int = 0
@export var y_max: int = 0
@export_category("Character")
@export var current_hat: int = 0
@export var current_shirt: int = 0
@export var current_pants: int = 0
@export var current_body: int = 0

func _ready() -> void:
	# Determine random clothing
	randomize_clothing()
	
	# Set position to be offscreen
	position = get_offscreen_position()
	
	# Set next position to be random spot onscreen
	roam_next_position = get_onscreen_position()

func _process(delta: float) -> void:
	match _current_state:
		State.IDLE:
			_idle(delta)
		State.ROAM:
			_roam(delta)
		State.DESPAWN:
			_despawn(delta)

func _idle(delta: float) -> void:
	pass
	
func _roam(delta: float) -> void:
	# Check if we are in range of our current target, if so, pick a new one
	if position.distance_to(roam_next_position) < 10:
		var random_direction: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * roam_radius
		if is_within_borders(roam_next_position + random_direction):
			roam_next_position += random_direction
		else:
			roam_next_position -= random_direction
		
	# Move towards our target
	position = position.lerp(roam_next_position, delta * roam_speed)
	
func _despawn(delta: float) -> void:
	# Check if we are in range of our current target, if so, pick a new one
	if position.distance_to(despawn_next_position) < 2:
		queue_free()
		
	# Move towards our target
	position = position.lerp(despawn_next_position, delta * 3)

func change_state(new_state: State) -> void:
	match new_state:
		State.ROAM:
			_current_state = State.ROAM
		State.IDLE:
			_current_state = State.IDLE
		State.DESPAWN:
			# Generate a random Vector2 on the edges of the screen
			despawn_next_position = get_offscreen_position()
			_current_state = State.DESPAWN
			
func change_clothing(clothing_index: int, new_clothing: CompositeSprite.TYPE) -> void:
	match new_clothing:
		CompositeSprite.TYPE.HAT:
			current_hat = clothing_index
			hat_sprite.texture = CompositeSprite.get_texture_from_index(CompositeSprite.TYPE.HAT, current_hat)
		CompositeSprite.TYPE.SHIRT:
			current_shirt = clothing_index
			shirt_sprite.texture = CompositeSprite.get_texture_from_index(CompositeSprite.TYPE.SHIRT, current_shirt)
		CompositeSprite.TYPE.PANTS:
			current_pants = clothing_index
			pants_sprite.texture = CompositeSprite.get_texture_from_index(CompositeSprite.TYPE.PANTS, current_pants)
		CompositeSprite.TYPE.BODY:
			current_body = clothing_index
			body_sprite.texture = CompositeSprite.get_texture_from_index(CompositeSprite.TYPE.BODY, current_body)
		
func randomize_clothing() -> void:
	# Get a random clothing item and update the clothing
	change_clothing(CompositeSprite.get_random_texture_index(CompositeSprite.TYPE.HAT), CompositeSprite.TYPE.HAT)
	change_clothing(CompositeSprite.get_random_texture_index(CompositeSprite.TYPE.SHIRT), CompositeSprite.TYPE.SHIRT)
	change_clothing(CompositeSprite.get_random_texture_index(CompositeSprite.TYPE.PANTS), CompositeSprite.TYPE.PANTS)
	change_clothing(CompositeSprite.get_random_texture_index(CompositeSprite.TYPE.BODY), CompositeSprite.TYPE.BODY)

func is_within_borders(pos: Vector2) -> bool:
	return pos.x > x_min and pos.x < x_max and pos.y > y_min and pos.y < y_max

# Triggered when the character is clicked
func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("CLICK"):
		character_clicked.emit(_current_state)
		randomize_clothing()

func get_offscreen_position() -> Vector2:
	# Get a position at the center of the screen
	var center_of_screen: Vector2 = Vector2((x_max - x_min) / 2, (y_max - y_min) / 2)

	# Add a vector to that to pick some point outside the screen
	return center_of_screen + (500.0 * Vector2.from_angle(randf_range(0, 2 * PI)))

func get_onscreen_position() -> Vector2:
	return Vector2(randi_range(x_min, x_max), randi_range(y_min, y_max))
