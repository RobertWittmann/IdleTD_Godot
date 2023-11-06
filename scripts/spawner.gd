extends Node2D

signal unit_spawned

@export var unit: PackedScene
@export var unitLimit: int = 1

var pos: Vector2i = Vector2i(0, 0):
	set(value):
		pos = value

var spawn_timer: Timer

var astar
var goal
var path
var unitArray = []


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer = get_node("Timer")
	spawn_timer.timeout.connect(_spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func create_path(_astar, _goal):
	astar = _astar
	goal = _goal
	_update_path()


func _update_path():
	path = astar.get_point_path(pos, goal)


func _spawn():
	if unitArray.size() < unitLimit:
		var _unit = unit.instantiate()
		add_child(_unit)
		_unit.name = "unit"

		unitArray.append(_unit)
		_unit.center_reached.connect(respawnUnit)

		_unit.start_unit(path)
		# unit_spawned.emit(path)


func respawnUnit(_unit):
	unitArray.erase(_unit)
	# print("respawn")
