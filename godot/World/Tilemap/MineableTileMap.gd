extends TileMap
class_name MineableTileMap

func _ready():
	Global.fg_tilemap = self

func hit_block():
	var cellv = world_to_map(get_local_mouse_position())
	_mine_cell(cellv)
	
func place_block(tile):
	var cellv = world_to_map(get_local_mouse_position())
	return _place_cell(cellv, tile)

func _mine_cell(cellv):
	set_cellv(cellv, -1)

func _place_cell(cellv, tile):
	if get_cellv(cellv) != -1:
		return false
	set_cellv(cellv, tile)
	return true
