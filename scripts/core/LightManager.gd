extends Node3D
class_name LightManager

@onready var mesh_node = get_parent().get_node("Ground/MeshInstance3D")
@onready var material = mesh_node.mesh.surface_get_material(0) if mesh_node else null
var light_map = Image.create(100, 100, false, Image.FORMAT_RF)
var light_pos = Vector2i(50, 50)
var light_range = 30

func _ready():
	print("Parent children: ", get_parent().get_children())
	print("Ground children: ", get_parent().get_node("Ground").get_children())
	print("Mesh node: ", mesh_node)
	print("Mesh: ", mesh_node.mesh if mesh_node else "(no mesh)")
	print("Material: ", material)
	if not mesh_node:
		push_error("MeshInstance3D not found at ../Ground/MeshInstance3D!")
		return
	if not material:
		print("No material on mesh, checking inspector material...")
		material = mesh_node.material_override  # Fallback to override
		print("Override material: ", material)
		if not material:
			push_error("No material found on MeshInstance3D! Assign one in inspector.")
			return
	generate_light_map()
	var tex = ImageTexture.create_from_image(light_map)
	material.set_shader_parameter("light_map", tex)

func generate_light_map():
	for y in range(100):
		for x in range(100):
			var dist = Vector2(x, y).distance_to(light_pos)
			var intensity = clamp(1.0 - (dist / light_range), 0.0, 1.0)
			light_map.set_pixel(x, y, Color(intensity, 0, 0, 1))
