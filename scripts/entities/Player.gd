extends CharacterBody3D
class_name RuinForgePlayer

@export var speed := 6.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.002
@export var vr_mode := false  # Toggle VR support
@onready var camera: Camera3D = $Camera3D
@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var gun_pivot: Node3D = $GunPivot
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var last_shot := 0.0
var fire_rate := 0.2

func _ready():
	if vr_mode and XRServer.primary_interface:
		get_viewport().use_xr = true
		camera.visible = false
		xr_camera.visible = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		camera.visible = true
		xr_camera.visible = false
	# Placeholder gun visualization
	var gun_mesh := MeshInstance3D.new()
	gun_mesh.mesh = CapsuleMesh.new()
	gun_mesh.scale = Vector3(0.1, 0.1, 0.3)
	gun_mesh.position = Vector3(0.3, -0.2, -0.5)  # Offset for right-hand view
	gun_pivot.add_child(gun_mesh)

func _physics_process(delta: float):
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Movement
	var input_dir := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()
	
	# Shooting
	if Input.is_action_pressed("shoot") and (Time.get_ticks_msec() - last_shot) > (fire_rate * 1000):
		shoot()

func _input(event: InputEvent):
	if vr_mode or not event is InputEventMouseMotion:
		return
	rotate_y(-event.relative.x * mouse_sensitivity)
	camera.rotate_x(-event.relative.y * mouse_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func shoot():
	last_shot = Time.get_ticks_msec()
	var bullet := preload("res://scenes/Bullet.tscn").instantiate() as CharacterBody3D
	bullet.position = gun_pivot.global_position
	bullet.velocity = -gun_pivot.global_transform.basis.z * 20.0
	get_parent().add_child(bullet)
