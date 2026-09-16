@icon("res://addons/tactician/icons/object_container6.png")
class_name ObjectManager
extends Node2D

var objects:Array[GridObject]
var lookup_table:Dictionary[Vector2i, Array]

func _ready() -> void:
	
	for object in find_children("", "GridObject"):
		objects.append(object)
		object._object_ready()

func get_objects(tile: Vector2i) -> Array[GridObject]:
	var return_array:Array[GridObject]
	for object in objects:
		if(object.grid_position == tile):
			return_array.append(object)
	return return_array

func is_occupied(tile:Vector2i) -> bool:
	var objects:Array[GridObject] = get_objects(tile)
	if objects.size() > 0:
		if objects[0].occupies_space:
			return true
	return false

func is_wall(tile, masks:Array[int] = []) -> bool:
	var objects:Array[GridObject] = get_objects(tile)
	for object in objects:
		if object.object_layer == -1:
			return true
		if object.object_layer == 0:
			continue
		if !masks.has(object.object_layer): # if you arent on their team theyre a wall
			return true
	return false

func update_lookup_table():
	var return_dict:Dictionary[Vector2i, Array]
	for object in objects:
		return_dict[object.grid_position] = []
		return_dict[object.grid_position].append(object)
	lookup_table = return_dict

func lookup_occupied(tile:Vector2i) -> bool:
	if lookup_table.has(tile):
		var objects:Array[GridObject]
		objects.append_array(lookup_table[tile])
		if objects.size() > 0:
			if objects[0].occupies_space:
				return true
	return false

func lookup_wall(tile, masks:Array[int] = []) -> bool:
	if lookup_table.has(tile):
		var objects:Array[GridObject]
		objects.append_array(lookup_table[tile])
		for object in objects:
			if object.object_layer == -1:
				return true
			if object.object_layer == 0:
				continue
			if !masks.has(object.object_layer): # if you arent on their team theyre a wall
				return true
	return false
