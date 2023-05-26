extends TileMap
class_name MineableTileMap

func _input(event):
	# TODO dig() should be called from the pickaxe node
	if event is InputEventMouseButton:
		var cellv = world_to_map(get_local_mouse_position())
		if event.button_index == BUTTON_LEFT and event.pressed:
			mine_cell(cellv)
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			place_cell(cellv, 1)

func mine_cell(cellv):
	set_cellv(cellv, -1)

func place_cell(cellv, tile):
	if get_cellv(cellv) != -1:
		return
	set_cellv(cellv, tile)
