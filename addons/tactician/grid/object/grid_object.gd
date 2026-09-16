@icon("res://addons/tactician/icons/object.png")
class_name GridObject
extends Sprite2D

##Disable if you want other objects to be able to occupy the same space as this one
@export var occupies_space:bool = true
##Layer the object is on, -1 is always a wall, 0 is never a wall
@export_range(-1,32) var object_layer: int = -1

var grid_position:Vector2i:
	get:
		return grid.local_to_map(position)
	set(value):
		position = grid.map_to_local( value )

var grid:TacticsGrid

func _object_ready() -> void:
	grid = TacticsGrid.INSTNACE
	
	grid_position = grid_position #align to grid, counter intuitive, but look at getter and setter at the top
#func get_grid_position() -> Vector2i:
	#return grid.local_to_map(position)
#func set_grid_position(value:Vector2i):
	#position = grid.map_to_local( value )
