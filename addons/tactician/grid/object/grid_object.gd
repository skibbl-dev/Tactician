@icon("res://addons/tactician/icons/object.png")
class_name GridObject
extends Node2D

#Layer the object is on, -1 is always a wall, 0 is never a wall
@export_range(-1,32) var object_layer: int = -1

# What the object ignores when looking for walls
@export_flags_2d_navigation() var object_mask: int
var object_masks: Array[int]

var grid:TacticsGrid

func _ready() -> void:
	grid = TacticsGrid.INSTNACE
	position = grid.map_to_local ( grid.local_to_map(position) )
	
	for shift in range(32):
		var mask = 1 << shift+1
		if object_mask & mask != 0 :
			object_masks.append( (log(mask) / log(2)) + 1 )
