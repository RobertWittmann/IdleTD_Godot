extends Node2D

signal spawners_created

@export var spawner: PackedScene

var _spawners = []


func _ready():
	pass


func create_spawners(_nodeArray):
	var x_length = _nodeArray.size()
	for row in _nodeArray:
		var y_length = row.size()
		for item in row:
			if (
				item.tileID.x == 0 && item.tileID.y == 0
				|| item.tileID.x == x_length - 1 && item.tileID.y == 0
				|| item.tileID.x == 0 && item.tileID.y == y_length - 1
				|| item.tileID.x == x_length - 1 && item.tileID.y == y_length - 1
			):
				item.spawner = true
				var _spawner = spawner.instantiate()
				add_child(_spawner)
				_spawner.name = str(item.tileID.x, "-", item.tileID.y, " spawner")
				_spawner.pos = Vector2i(item.tileID.x, item.tileID.y)
				_spawner.position = Vector2i(item.position.x, item.position.y)
				_spawners.append(_spawner)

				_spawner.unit_spawned.connect(update_spawned_units)


func update_spawners(_astar: AStarGrid2D, _goal: Vector2i):
	for _spawner in _spawners:
		_spawner.create_path(_astar, _goal)


func update_spawned_units(_path):
	get_tree().call_group("units", "start_unit", _path)


func update_existing_units(_astar, _goal, _scale):
	get_tree().call_group("units", "find_new_path", _astar, _goal, _scale)
