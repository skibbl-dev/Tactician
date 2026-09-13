@icon("res://addons/tactician/icons/unit.png")
extends GridObject

## What the object ignores when looking for walls
@export_flags_2d_navigation() var object_mask: int
var object_masks: Array[int]

@export var move_range: int = 4
@export var move_time: float = 0.15
var moving:bool = false
var move_percent:float = 0:
	set(value):
		move_percent = value
		#position = move_from + ((move_direction * grid.tile_set.tile_size)*move_percent)
		global_position.x = remap(move_percent,0,1,move_from.x, move_to.x)
		global_position.y = remap(move_percent,0,1,move_from.y, move_to.y)
var move_from:Vector2
var move_to:Vector2i

signal finished_moving

func _object_ready() -> void:
	super()
	
	for shift in range(32):
		var mask = 1 << shift
		if object_mask & mask != 0 :
			object_masks.append( (log(mask) / log(2)) + 1 )
	 
	print(object_masks)
	
	DEBUG_ready_for_next()

var possible_paths:Dictionary[Vector2i,Array]
func DEBUG_ready_for_next():
	$MoveTilemap.global_position = Vector2.ZERO
	$MoveTilemap.clear()
	possible_paths = grid.get_paths_within_distance(grid_position,move_range,object_masks)
	
	for cell in possible_paths:
		$MoveTilemap.set_cell(cell,0,Vector2i(12,2))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if(moving): return
		if possible_paths.has( grid.local_to_map(get_global_mouse_position()) ):
			$MoveTilemap.clear()
			move_along_path(possible_paths[grid.local_to_map(get_global_mouse_position())])

func move_along_path(path:Array[Vector2i]):
	if path.size() == 0: # we moved through the whole path!
		finished_moving.emit()
		return
	
	move_from = global_position
	move_to = grid.map_to_local(path.pop_front())

	move_percent = 0
	moving = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"move_percent",1,move_time)
	tween.tween_property(self,"moving",false,0)
	tween.tween_callback(move_along_path.bind(path))
	#tween.tween_callback(finished_moving.emit)
