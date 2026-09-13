@icon("res://addons/tactician/icons/grid2.png")
class_name TacticsGrid
extends TileMapLayer

@onready var object_manager: ObjectManager = $"../ObjectManager"

var map:Dictionary[Vector2i,Vector2i]
static var INSTNACE:TacticsGrid

func _enter_tree() -> void:
	INSTNACE = self

# PATHFINDING
func get_paths_within_distance(start:Vector2i, walk:int, masks:Array[int] = [], use_move_costs:bool = true, ignore_walls:bool = false, remove_occupants:bool = true) -> Dictionary[Vector2i,Array]:
	var came_from: Dictionary[Vector2i, Vector2i]
	var cost_so_far: Dictionary[Vector2i, int]
	
	#var current_tile:Vector2i = start
	cost_so_far[start] = 0
	
	if remove_occupants or !ignore_walls:
		object_manager.update_lookup_table()
	
	# get all walkable tiles, and update the flow field
	for current_tile in cost_so_far:
		for tile in get_adjacent_tiles(current_tile):
			var old_cost:int
			var new_cost:int
			
			var tile_data:TileData = get_cell_tile_data(tile)
			if(tile_data == null): continue # dont add tiles that aren't in the tilemap!
			
			var move_cost:int
			move_cost = tile_data.get_custom_data("move_cost")
			if use_move_costs == false and move_cost != -1: # no move cost and no wall
				move_cost = 1 # if we want to count steps instead of distance, just count 1
			
			if ignore_walls:
				if(move_cost == -1): move_cost = 1# if we want to bypass walls, treat a wall as a 1
			else:
				if(move_cost == -1): continue # dont add walls!
				if(object_manager.lookup_wall(tile, masks)): continue # dont add walls!
			
			if cost_so_far.has(tile):
				old_cost = cost_so_far[tile]
				new_cost = cost_so_far[current_tile] + move_cost + 1
			else:
				new_cost = cost_so_far[current_tile] + move_cost + 1
				old_cost = new_cost + 1
			
			if(new_cost > walk): continue # dont walk past the distance we were allocated
			
			if old_cost > new_cost: # if our old cost took longer than new cost
				cost_so_far[tile] = new_cost # replace cost
				came_from[tile] = current_tile # if this path is better, update the flow field
	
	## convert the flow field into individual paths
	var best_paths: Dictionary[Vector2i, Array]
	
	for tile in came_from:
		if remove_occupants:
			if object_manager.lookup_occupied(tile):
				continue
		var current_tile:Vector2i = tile
		var current_array:Array[Vector2i] = []
		while cost_so_far[current_tile] > 0: #repeat until we make it back to the very first tile
			current_array.push_front( current_tile)
			current_tile = came_from[current_tile]
		best_paths[tile] = current_array
	
	return best_paths

#func get_walkable_paths(start:Vector2i, walk:int) -> Dictionary[Vector2i,Array]:
	#
	#var came_from: Dictionary[Vector2i, Vector2i]
	#var cost_so_far: Dictionary[Vector2i, int]
	#var current_best_path: Dictionary[Vector2i, Array]
	#
	#var current_tile:Vector2i = start
	#cost_so_far[current_tile] = 0
	#
	#for tile in get_adjacent_tiles(current_tile):
		#var old_cost = cost_so_far[tile]
		#var new_cost = cost_so_far[current_tile] + 1 ## Replace with tiles move cost
		#if old_cost > new_cost: # if our old cost took longer than new cost
			#cost_so_far[tile] = new_cost # replace cost
			#came_from[tile] = current_tile # if this path is better, update the flow field
		#
	#
	#return {}

func get_adjacent_tiles(tile:Vector2i) -> Array[Vector2i]:
	return [
		tile + Vector2i(-1, 0), tile + Vector2i(0, +1), 
		tile + Vector2i(+1, 0), tile + Vector2i(0, -1), 
	]

func get_manhattan_distance(a:Vector2i, b:Vector2i) -> int:
	return ((abs(a.x - b.x) + abs(a.y - b.y)))

# MAP DATA
#func serialize_map() -> void:
	#var i = 0
	#for tile in get_used_cells():
		##map[tile] = get_cell_tile_data(tile).get_custom_data("move_cost")
		#map[tile] = get_cell_atlas_coords(tile)
		#i += 1
#
#func set_map() -> void:
	#for tile in map.keys():
		#set_cell(tile,0,map[tile])
