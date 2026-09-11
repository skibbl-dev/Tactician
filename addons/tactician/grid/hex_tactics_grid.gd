@icon("res://addons/tactician/icons/hex_grid3.png")
class_name HexTacticsGrid
extends TacticsGrid

func _ready() -> void:
	super()

func get_adjacent_tiles(tile:Vector2i) -> Array[Vector2i]:
	return [
		tile + Vector2i(+1, 0), tile + Vector2i(+1, -1), tile + Vector2i(0, -1), 
		tile + Vector2i(-1, 0), tile + Vector2i(-1, +1), tile + Vector2i(0, +1), 
	]

func get_manhattan_distance(a:Vector2i, b:Vector2i) -> int:
	return (abs(a.x - b.x) + abs(a.x + a.y - b.x - b.y) + abs(a.y - b.y)) / 2
