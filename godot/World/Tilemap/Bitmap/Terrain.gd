extends TextureRect

func _ready():
	material.set_shader_param("t1", $Terrain1.texture)
	material.set_shader_param("t2", $Terrain2.texture)
