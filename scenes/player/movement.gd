extends CharacterBody3D

@onready var camera := $CameraArm as Node3D
@onready var anim_tree := $male_human_base/AnimationTree as AnimationTree
@onready var body := $male_human_base
@onready var blend_space := "parameters/BlendSpace2D/blend_position"

var sensibility := 0.01
var aceleration = 1

const MAX_SPEED = 7
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("right","left","backward", "foward")
	#var input_dir := Input.get_axis("backward", "foward")
	#var input_sides := Input.get_axis("right","left")
	var direction := (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var direction_rad = Vector2(direction.z, direction.x).angle()
		anim_tree[blend_space] = lerp(anim_tree[blend_space], input_dir, 0.05)
		body.rotation.y = lerp_angle(body.rotation.y,direction_rad,0.1)
		velocity.x = lerp(velocity.x, direction.x * MAX_SPEED, delta * aceleration)
		velocity.z = lerp(velocity.z, direction.z * MAX_SPEED, delta * aceleration)
	else:
		anim_tree[blend_space] = lerp(anim_tree[blend_space], Vector2.ZERO , 0.1)
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED)
		velocity.z = move_toward(velocity.z, 0, MAX_SPEED)

	move_and_slide()
