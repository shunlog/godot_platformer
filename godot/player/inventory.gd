extends Node2D

var reachable_distance := 5

func _set_tile_terrain(pos, terrain):
	if not Global.tilemap:
		return
		
	var tpos = Global.tilemap.local_to_map(pos)
	var tself = Global.tilemap.local_to_map(get_parent().position)
	if abs(tpos.x - tself.x) + abs(tpos.y - tself.y) > reachable_distance:
		return
		
	Global.tilemap.set_cells_terrain_connect(0, [tpos], 0, terrain)

func _player_in_tile(pos: Vector2) -> bool:
	# returns true if any entity collides with the tile at global position pos
	if not Global.tilemap:
		return false
		
	# need to figure out how to get array of all entities (group?)
	return false

	# tile size
	var ts = Global.tilemap.tile_set.tile_size[0]
	# collision box size
	var sz : Vector2 = $CollisionShape2D.shape.size
	# left-up corner
	var corner_LU: Vector2 = (position - sz / 2) - (position - sz / 2).posmod(ts)
	# right-down corner
	var corner_RD: Vector2 = (position + sz / 2) - (position + sz / 2).posmod(ts) + Vector2(ts, ts)
	var bounding_tiles_rect : Rect2 = Rect2(corner_LU, corner_RD - corner_LU)
	
	if bounding_tiles_rect.has_point(pos):
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
