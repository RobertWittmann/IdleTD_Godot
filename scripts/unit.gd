extends Node2D

signal center_reached

@export var move_speed: float = 0.3
@export var unit_respawn_delay: float = 0.5

var path
var move_interval

var healthBar


func _ready():
	add_to_group("units")
	move_interval = get_node("Timer")
	move_interval.timeout.connect(move_unit)
	healthBar = get_node("HealthBar")


func start_unit(_path):
	path = _path.duplicate()
	move_interval.start(move_speed)


func move_unit():
	global_position = Vector2i(path[0].x, path[0].y)
	if path.size() > 1:
		path.remove_at(0)
	else:
		center_reached.emit(self)
		await get_tree().create_timer(unit_respawn_delay).timeout
		queue_free()


func find_new_path(_astar, _goal, _scale):
	var pos = global_position / _scale
	path = _astar.get_point_path(pos, _goal)
