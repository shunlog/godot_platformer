extends MineableTileMap

onready var bitmap :TextureRect = $WorldBitmap

func _ready():
	set_from_texture(bitmap)


func set_from_texture(vp :TextureRect) -> void:
	yield(VisualServer, "frame_post_draw")
	var img = vp.get_texture().get_data()
	set_from_bitmap(img)


func set_from_bitmap(img: Image) -> void:
	# img is a bitmap where black means block and white means air
	img.lock()
	for x in range(img.get_width()):
		var depth = 0
		for y in range(img.get_height()):
			var col = img.get_pixel(x, y)
			if not col:
				depth += 1
				if depth < 35 + randi() % 5:
					set_cell(x, y, 0)
				else:
					set_cell(x, y, 1)
