class_name PathFinder
extends RefCounted

var astar_grid: AStarGrid2D = AStarGrid2D.new()
var layer: TileMapLayer

const OBJECT_MASK: int = 1
const CELL_BOX_SCALE: float = 0.9
const NO_NEARBY_CELL: = Vector2i(-2147483648, -2147483648)

#func setup(floor_layer: TileMapLayer, wall_layer: TileMapLayer, objects_layer: TileMapLayer) -> void:
	#layer = floor_layer
	#var tile_size: Vector2 = layer.tile_set.tile_size
	#
	#astar_grid.region = floor_layer.get_used_rect().merge(wall_layer.get_used_rect())
	#astar_grid.cell_size = tile_size
	#astar_grid.offset = tile_size / 2.0   # Path points are in the middle of the cells
	#astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	#astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	#astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	#astar_grid.update()
	#
	#for cell in wall_layer.get_used_cells():
		#astar_grid.set_point_solid(cell, true)
		
func setup(layers: Array[TileMapLayer]) -> void:
	if layers.is_empty():
		return
		
	# Use the first layer (floor layer) as the index grid
	layer = layers[0]
	var tile_size: Vector2 = layer.tile_set.tile_size
	
	# Dynamically calculate the combined boundaries of all passed layers
	var full_region := Rect2i()
	for l in layers:
		full_region = full_region.merge(l.get_used_rect())
	
	astar_grid.region = full_region
	astar_grid.cell_size = tile_size
	astar_grid.offset = tile_size / 2.0   # Path points are in the middle of the cells
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.update()
	
	# First layer is the floor layer 
	for i in range(1, layers.size()):
		var obstacle_layer: TileMapLayer = layers[i]
		for cell in obstacle_layer.get_used_cells():
			astar_grid.set_point_solid(cell, true)

func scan_obstacles(space: PhysicsDirectSpaceState2D, mask: int = OBJECT_MASK) -> void:
	var cell_box := RectangleShape2D.new()
	cell_box.size = astar_grid.cell_size * CELL_BOX_SCALE
	
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = cell_box
	query.collision_mask = mask
	
	for x in astar_grid.region.size.x:
		for y in astar_grid.region.size.y:
			var cell: Vector2i = astar_grid.region.position + Vector2i(x, y)
			var cell_center: Vector2 = layer.to_global(astar_grid.get_point_position(cell))
			query.transform = Transform2D(0.0, cell_center)
			if not space.intersect_shape(query, 1).is_empty():
				astar_grid.set_point_solid(cell, true)

func get_global_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	var from_cell: Vector2i = layer.local_to_map(layer.to_local(from))
	var to_cell: Vector2i = layer.local_to_map(layer.to_local(to))
	
	if not astar_grid.region.has_point(from_cell) or not astar_grid.region.has_point(to_cell):
		return PackedVector2Array()
	if astar_grid.is_point_solid(to_cell):
		return PackedVector2Array()
	
	if astar_grid.is_point_solid(from_cell):
		from_cell = nearest_open_cell(from_cell)
		if from_cell == NO_NEARBY_CELL:
			return PackedVector2Array()
	
	var global_path := PackedVector2Array()
	for point in astar_grid.get_point_path(from_cell, to_cell):
		global_path.append(layer.to_global(point))
	return global_path


func nearest_open_cell(cell: Vector2i) -> Vector2i:
	for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT,
			Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)]:
		var neighbor: Vector2i = cell + direction
		if astar_grid.region.has_point(neighbor) and not astar_grid.is_point_solid(neighbor):
			return neighbor
	return NO_NEARBY_CELL

func random_point_near(world_pos: Vector2, min_radius: int, max_radius: int) -> Vector2:
	var cell: Vector2i = layer.local_to_map(layer.to_local(world_pos))
	var offset_x = randi_range(min_radius, max_radius) * [1, -1].pick_random()
	var offset_y = randi_range(min_radius, max_radius) * [1, -1].pick_random()
	cell += Vector2i(offset_x, offset_y)
	return layer.to_global(layer.map_to_local(cell))


func check_distance(from: Vector2, to: Vector2, distance: float) -> bool:
	var from_cell: Vector2i = layer.local_to_map(layer.to_local(from))
	var to_cell: Vector2i = layer.local_to_map(layer.to_local(to))
	
	var calc_distance = Vector2(from_cell).distance_to(Vector2(to_cell))
	return true if calc_distance < distance else false


func count_walls_between(from: Vector2, to: Vector2) -> int:
	var from_cell: Vector2i = layer.local_to_map(layer.to_local(from))
	var to_cell: Vector2i = layer.local_to_map(layer.to_local(to))

	var count: int = 0
	for cell in Geometry2D.bresenham_line(from_cell, to_cell):
		if astar_grid.region.has_point(cell) and astar_grid.is_point_solid(cell):
			count += 1
	return count
	
func get_path_to_adjacent(from: Vector2, to_solid: Vector2) -> PackedVector2Array:
	var target_cell: Vector2i = layer.local_to_map(layer.to_local(to_solid))
	var best_path := PackedVector2Array()

	for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		var neighbor: Vector2i = target_cell + direction
		if not astar_grid.region.has_point(neighbor) or astar_grid.is_point_solid(neighbor):
			continue

		var neighbor_pos: Vector2 = layer.to_global(astar_grid.get_point_position(neighbor))
		var possible_path: PackedVector2Array = get_global_path(from, neighbor_pos)
		if possible_path.is_empty():
			continue
		if best_path.is_empty() or possible_path.size() < best_path.size():
			best_path = possible_path
	return best_path
