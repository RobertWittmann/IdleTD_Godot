extends Node2D

var _aStarGrid
var _nodeArray


func _ready():
	$GridManager.updated_path.connect(update_paths)

	$GridManager.initiate_astar()

	_aStarGrid = $GridManager.aStarGrid

	$GridManager.create_grid()

	_nodeArray = $GridManager.nodeArray

	$UnitManager.create_spawners(_nodeArray)
	update_paths()


func update_paths():
	$UnitManager.update_spawners(_aStarGrid, $GridManager.goalNode)
	$UnitManager.update_existing_units(_aStarGrid, $GridManager.goalNode, $GridManager.tileSize)
