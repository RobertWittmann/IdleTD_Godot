extends Node2D

signal grid_created
signal astar_created
signal updated_path

@export var tile: PackedScene
@export var gridSize: Vector2i = Vector2i(11, 11)
@export var tileScale: int = 1
@export var spriteSize: int = 32

var tileSize: int:
	get:
		return tileSize

var nodeArray = []:
	get:
		return nodeArray
var aStarGrid:
	get:
		return aStarGrid
var goalNode:
	get:
		return goalNode

var grid


func _ready():
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			return


func initiate_astar():
	tileSize = tileScale * spriteSize

	aStarGrid = AStarGrid2D.new()
	aStarGrid.region = Rect2i(0, 0, gridSize.x, gridSize.y)
	aStarGrid.cell_size = Vector2i(tileSize, tileSize)
	# aStarGrid.offset = Vector2(tileSize, tileSize) / 2
	aStarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	aStarGrid.update()

	goalNode = Vector2i((gridSize.x - 1) / 2, (gridSize.y - 1) / 2)


func create_grid():
	grid = Node.new()
	grid.name = "Grid"
	add_child(grid)

	for x in gridSize.x:
		nodeArray.append([])
		for y in gridSize.y:
			var _tile = tile.instantiate()
			grid.add_child(_tile)

			_tile.tileID = Vector2i(x, y)

			_tile.scale.x = tileScale
			_tile.scale.y = tileScale
			_tile.position.x = (x * tileSize)
			_tile.position.y = (y * tileSize)

			_tile.get_node("Label").text = str("(", x, ",", y, ")")

			_tile.tile_clicked.connect(_on_tile_clicked)

			nodeArray[x].append(_tile)


func _on_tile_clicked(_tileID):
	if nodeArray[_tileID.x][_tileID.y].spawner == true:
		return

	if aStarGrid.is_point_solid(_tileID):
		aStarGrid.set_point_solid(_tileID, false)
	else:
		aStarGrid.set_point_solid(_tileID, true)

	var paths = []

	paths.append(aStarGrid.get_id_path(Vector2i(0, 0), goalNode))
	paths.append(aStarGrid.get_id_path(Vector2i(gridSize.x - 1, 0), goalNode))
	paths.append(aStarGrid.get_id_path(Vector2i(0, gridSize.y - 1), goalNode))
	paths.append(aStarGrid.get_id_path(Vector2i(gridSize.x - 1, gridSize.y - 1), goalNode))

	for path in paths:
		if path.size() <= 0:
			aStarGrid.set_point_solid(_tileID, false)
			updateTiles()
			return

	nodeArray[_tileID.x][_tileID.y].toggle_free()

	for x in gridSize.x:
		for y in gridSize.y:
			nodeArray[x][y].path = false
			nodeArray[x][y]._update_tile()

	for path in paths:
		for item in path:
			nodeArray[item.x][item.y].path = true
			nodeArray[item.x][item.y]._update_tile()

	updated_path.emit()


func updateTiles():
	for x in gridSize.x:
		for y in gridSize.y:
			nodeArray[x][y]._update_tile()


func getNodeID(target: Node2D):
	return target.nodeID
