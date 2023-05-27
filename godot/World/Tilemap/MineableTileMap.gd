extends TileMap
class_name MineableTileMap

var pickable_scn = preload("res://Items/PickupItem.tscn")


func _ready():
	Global.fg_tilemap = self

func hit_tile():
	var cellv = world_to_map(get_local_mouse_position())
	if get_cellv(cellv) != INVALID_CELL:
		_mine_tile(cellv)
	
func place_tile(tile):
	var cellv = world_to_map(get_local_mouse_position())
	return _place_tile(cellv, tile)

func _mine_tile(cellv):
	var pickable = pickable_scn.instance()
	pickable.position = map_to_world(cellv)
	add_child(pickable)
	
	set_cellv(cellv, -1)

func _place_tile(cellv, tile):
	if get_cellv(cellv) != -1:
		return false
	set_cellv(cellv, tile)
	return true
