extends Node2D
class_name NPCHandler

const CHARACTER = preload("res://character/character.tscn")

var item_to_find: int = 0

func _physics_process(delta: float) -> void:
	pass

func spawn_characters(amount: int, roam_speed: float, roam_radius: float, clothing_type: CompositeSprite.TYPE, difficulty: int = 1.0) -> void:
	# First, find out how many of each type of object we need to spawn
	var amount_to_spawn: Array = []
	for i in range(0, CompositeSprite.get_max_texture_index(clothing_type) + 1):
		var baseCount = amount / (CompositeSprite.get_max_texture_index(clothing_type) + 1)
		var additionalCount = randi_range(-difficulty * baseCount, difficulty * baseCount)
		amount_to_spawn.append(baseCount + additionalCount)
		
	# Sort the objects and make sure we don't have a max duplicate
	amount_to_spawn.sort()
	amount_to_spawn.reverse()
	if (amount_to_spawn[0] == amount_to_spawn[1]):
		amount_to_spawn[0] += 1
		amount_to_spawn[1] -= 1
		
	# Shuffle the objects and spawn the characters
	amount_to_spawn.shuffle()
	item_to_find = amount_to_spawn.find(amount_to_spawn.max())
	for clothing_index in amount_to_spawn.size():
		for clothing_amount in amount_to_spawn[clothing_index]:
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
