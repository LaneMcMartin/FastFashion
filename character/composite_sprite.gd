extends Node
class_name CompositeSprite

enum TYPE {HAT, SHIRT, PANTS, BODY}

static var sprite_offsets = {
	TYPE.HAT: 13.5,
	TYPE.SHIRT: -8.0,
	TYPE.PANTS: -12.0,
	TYPE.BODY: 0.0
}

static var hat_spritesheet = {
	0: preload("res://character/Sprites/Hat/Hat1.png"),
	1: preload("res://character/Sprites/Hat/Hat2.png"),
	2: preload("res://character/Sprites/Hat/Hat3.png")
}

static var shirt_spritesheet = {
	0: preload("res://character/Sprites/Shirt/Shirt1.png"),
	1: preload("res://character/Sprites/Shirt/Shirt2.png"),
	2: preload("res://character/Sprites/Shirt/Shirt3.png")
}

static var pants_spritesheet = {
	0: preload("res://character/Sprites/Pants/Pants1.png"),
	1: preload("res://character/Sprites/Pants/Pants2.png"),
	2: preload("res://character/Sprites/Pants/Pants3.png")
}

static var  body_spritesheet = {
	0: preload("res://character/Sprites/Color/Color1.png"),
	1: preload("res://character/Sprites/Color/Color2.png"),
	2: preload("res://character/Sprites/Color/Color3.png")
}

static func get_max_texture_index(type: TYPE) -> int:
	var max_texture_index: int = 0
	match type:
		TYPE.HAT:
			max_texture_index = hat_spritesheet.size()
		TYPE.SHIRT:
			max_texture_index = shirt_spritesheet.size()
		TYPE.PANTS:
			max_texture_index = pants_spritesheet.size()
		TYPE.BODY:
			max_texture_index = body_spritesheet.size()
	return max_texture_index - 1

static func get_random_texture_index(type: TYPE) -> int:
	var random_texture_index: int = 0
	match type:
		TYPE.HAT:
			random_texture_index = hat_spritesheet.size()
		TYPE.SHIRT:
			random_texture_index = shirt_spritesheet.size()
		TYPE.PANTS:
			random_texture_index = pants_spritesheet.size()
		TYPE.BODY:
			random_texture_index = body_spritesheet.size()
	return randi_range(0, random_texture_index - 1)

static func get_texture_from_index(type: TYPE, index: int) -> Texture2D:
	var desired_texture: Texture2D = null
	match type:
		TYPE.HAT:
			desired_texture = hat_spritesheet[clamp(index, 0, hat_spritesheet.size() - 1)]
		TYPE.SHIRT:
			desired_texture = shirt_spritesheet[clamp(index, 0, shirt_spritesheet.size() - 1)]
		TYPE.PANTS:
			desired_texture = pants_spritesheet[clamp(index, 0, pants_spritesheet.size() - 1)]
		TYPE.BODY:
			desired_texture = body_spritesheet[clamp(index, 0, body_spritesheet.size() - 1)]
	return desired_texture
