extends Node2D
class_name NPCHandler

const CHARACTER = preload("res://character/character.tscn")

var item_to_find: int = 0

func _physics_process(delta: float) -> void:
	pass

func spawn_characters(amount: int, roam_speed: float, roam_radius: float, clothing_type: CompositeSprite.TYPE, difficulty: int = 1.0) -> void:
	# Take the total number of people to spawn
	# For each item, divide the total remaining by the difficulty and store the element - then divide the remainder and store, divide the remainder and store, divide the remainder and store...
	# Shuffle the array
	# Set the item to find as the item with the max ocurrences
	# Spawn characters
	var to_spawn : Array = []
	var remainder : float = float(amount)
	for i in range(0, CompositeSprite.get_max_texture_index(clothing_type) + 1):
		remainder = remainder / (1 + (1 / difficulty))
		to_spawn.append(floor(remainder))
	to_spawn.shuffle()
	item_to_find = to_spawn.find(to_spawn.max())
	for clothing_index in to_spawn.size():
		for clothing_amount in to_spawn[clothing_index]:
			var new_character : Character = CHARACTER.instantiate()
			add_child(new_character)
			new_character.roam_speed = roam_speed
			new_character.roam_radius = roam_radius
			new_character.change_clothing(clothing_index, clothing_type)
	

func get_most_common_index() -> int:
	return item_to_find

func dismiss_and_despawn() -> void:
	for child in get_children():
		child.change_state(Character.State.DESPAWN)
