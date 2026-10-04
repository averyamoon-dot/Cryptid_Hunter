class_name PathFinder
extends Object

var astar_grid: AStarGrid2D =  AStarGrid2D.new()
var layer: TileMapLayer

func setup(floor_layer: TileMapLayer, wall_layer: TileMapLayer) -> void:
	layer = floor_layer
	var tile_size: Vector2 = layer.tile_set.tile_size
	
	astar_grid.region = floor_layer.get_used_rect().merge(wall_layer.get_used_rect())
	astar_grid.cell_size = tile_size
	astar_grid.offset = tile_size / 2.0   # Path points are in the middle of the cells
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	
	for cell in wall_layer.get_used_cells():
		astar_grid.set_point_solid(cell, true)

func get_global_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	# Converts vectors to grid cell locations
	var from_cell: Vector2i = layer.local_to_map(layer.to_local(from))
	var to_cell: Vector2i = layer.local_to_map(layer.to_local(to))
	
	# If destination is outside of the grid or a wall, return nothing and retry
	if not astar_grid.region.has_point(from_cell) or not astar_grid.region.has_point(to_cell):
		return PackedVector2Array()
	if astar_grid.is_point_solid(to_cell):
		return PackedVector2Array()
	
	# Returns vector array of global positions
	var global_path := PackedVector2Array()
	for point in astar_grid.get_point_path(from_cell, to_cell):
		global_path.append(layer.to_global(point))
	return global_path

func random_point_near(world_pos: Vector2, radius: int) -> Vector2:
	var cell: Vector2i = layer.local_to_map(layer.to_local(world_pos))
	cell += Vector2i(randi_range(-radius, radius), randi_range(-radius, radius))
	return layer.to_global(layer.map_to_local(cell))
