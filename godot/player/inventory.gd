extends Node2D

var reachable_distance := 5

func _set_tile_terrain(pos, terrain):
	if not Global.tilemap:
		return
		
	var tpos = Global.tilemap.local_to_map(pos)
	var tself = Global.tilemap.local_to_map(global_position)
	if abs(tpos.x - tself.x) + abs(tpos.y - tself.y) > reachable_distance:
		return
		
	Global.tilemap.set_cells_terrain_connect(0, [tpos], 0, terrain)

func _player_in_tile(pos: Vector2) -> bool:
	# returns true if any entity collides with the tile at global position pos
	if not Global.tilemap:
		return false
		
	var entities = get_tree().get_nodes_in_group("entities")
	for entity in entities:
		if entity.get_bounding_tiles_rect().has_point(pos):
			return true
	return false

func _place_tile():
	var pos = get_global_mouse_position()
	if _player_in_tile(pos):
		return
	_set_tile_terrain(pos, 1)

func _erase_tile():
	var pos = get_global_mouse_position()
	_set_tile_terrain(pos, -1)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_place_tile()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			_erase_tile()
