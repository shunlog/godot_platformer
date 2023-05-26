extends TextureRect

func _ready():
	material.set_shader_param("t1", $Caves1.texture)
	material.set_shader_param("t2", $Caves2.texture)
	material.set_shader_param("t3", $Caves3.texture)
	material.set_shader_param("t4", $Gradient.texture)
