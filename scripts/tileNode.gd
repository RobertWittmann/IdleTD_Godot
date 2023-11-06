extends Area2D
class_name TileNode

signal tile_clicked

var tileID: Vector2i = Vector2i(0, 0):
	get:
		return tileID
	set(value):
		tileID = value

var spawner: bool = false:
	get:
		return spawner
	set(value):
		spawner = value

var free: bool = true

var path: bool = false:
	set(value):
		path = value

var _spriteSize: Vector2i:
	get:
		return _spriteSize


func _ready():
	var _sprite = get_node("Sprite")
	_spriteSize = Vector2i(
		_sprite.texture.get_width() * _sprite.scale.x,
		_sprite.texture.get_height() * _sprite.scale.y
	)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			tile_clicked.emit(tileID)


func _on_mouse_entered():
	pass


func _on_mouse_exited():
	pass


func toggle_free():
	free = !free
	_update_tile()


func _update_tile():
	if !free:
		get_node("Sprite").modulate = Color.BLUE
	elif path:
		get_node("Sprite").modulate = Color.GREEN
	else:
		get_node("Sprite").modulate = Color.WHITE
