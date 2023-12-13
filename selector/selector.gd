extends Control
class_name Selector

const ARROW_ANIMATION_SPEED = 1.5
const PULSE_ANIMATION_SPEED = 1.5

enum DIRECTION {LEFT, RIGHT}

@onready var item: Sprite2D = $Frame/Item
@onready var left_arrow_animation_player: AnimationPlayer = $Left/AnimationPlayer
@onready var right_arrow_animation_player: AnimationPlayer = $Right/AnimationPlayer
@onready var frame_animation_player: AnimationPlayer = $Frame/AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_index: int = 0
@onready var current_type: CompositeSprite.TYPE = CompositeSprite.TYPE.HAT

signal item_selected(index: int)

func _ready() -> void:
	animation_player.play("Passive")
	
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LEFT"):
		_scroll_selection(DIRECTION.LEFT)
	if Input.is_action_just_pressed("RIGHT"):
		_scroll_selection(DIRECTION.RIGHT)
	if Input.is_action_just_pressed("SELECT"):
		_make_selection()


func update(new_type: CompositeSprite.TYPE) -> void:
	current_type = new_type
	item.offset.y = CompositeSprite.sprite_offsets[current_type]
	_scroll_selection(Selector.DIRECTION.RIGHT)


func _left_arrow_clicked(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("CLICK"):
		_scroll_selection(DIRECTION.LEFT)


func _right_arrow_clicked(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("CLICK"):
		_scroll_selection(DIRECTION.RIGHT)


func _scroll_selection(direction: DIRECTION):
	match direction:
		DIRECTION.LEFT:
			left_arrow_animation_player.play("Pulse", -1, ARROW_ANIMATION_SPEED)
			if current_index <= 0:
				current_index = CompositeSprite.get_max_texture_index(current_type)
			else:
				current_index -= 1
		DIRECTION.RIGHT:
			right_arrow_animation_player.play("Pulse", -1, ARROW_ANIMATION_SPEED)
			if current_index >= CompositeSprite.get_max_texture_index(current_type):
				current_index = 0
			else:
				current_index += 1
	item.texture = CompositeSprite.get_texture_from_index(current_type, current_index)


func _frame_clicked(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("CLICK"):
		_make_selection()


func _make_selection() -> void:
	frame_animation_player.play("Pulse", -1, PULSE_ANIMATION_SPEED)
	item_selected.emit(current_index)


func hide_selector() -> void:
	animation_player.play("Hide")


func show_selector() -> void:
	animation_player.play_backwards("Hide")
