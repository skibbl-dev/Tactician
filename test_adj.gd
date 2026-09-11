extends Node2D

@export var tilemap:TileMapLayer
@export var move_range:int = 3
var tilemap_data:PackedByteArray
var target = Vector2i(1,1)

func _ready() -> void:
	Tactician.set_tilemap(tilemap)
	tilemap_data = tilemap.tile_map_data

func _process(_delta: float) -> void:
	if(tilemap != null):
		if(Input.is_action_just_pressed("ui_accept")):
			var mouse_pos_global = get_viewport().get_mouse_position()
			var tile_pos = tilemap.local_to_map(tilemap.to_local(mouse_pos_global))
			target = tile_pos
			#var cells = Tactician.get_cells_within_distance_with_costs(tile_pos, 3)
			#cells.erase(tile_pos)
			#for cell in cells:
				#tilemap.erase_cell(cell)
			tilemap.erase_cell(tile_pos)
		if(Input.is_action_just_pressed("ui_cancel")):
			tilemap.tile_map_data = tilemap_data
		if(Input.is_action_just_pressed("ui_down")):
			var mouse_pos_global = get_viewport().get_mouse_position()
			var tile_pos = tilemap.local_to_map(tilemap.to_local(mouse_pos_global))
			var path = Tactician.get_shortest_path(tile_pos,target)
			for cell in path:
				tilemap.set_cell(cell, -1, Vector2i(12,2))
