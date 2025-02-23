extends CharacterBody3D
class_name RuinForgeBullet

var lifetime := 3.0

func _ready():
	# Velocity will be set by Player.gd when instantiated
	pass

func _physics_process(delta: float):
	velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	move_and_collide(velocity * delta)
	lifetime -= delta
	if lifetime <= 0 or get_slide_collision_count() > 0:
		queue_free()
