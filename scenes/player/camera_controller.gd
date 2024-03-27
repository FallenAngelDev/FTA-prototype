extends Node3D

var h_motion : float = 0
var v_motion : float = 0
var sensitivity : float = 0.1
var aceleration : float = 20

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		h_motion += -event.relative.x * sensitivity
		v_motion += event.relative.y * sensitivity

func _physics_process(delta: float) -> void:
	rotation_degrees.y = lerp(rotation_degrees.y, h_motion, aceleration * delta)
	rotation_degrees.x = lerp(rotation_degrees.x, v_motion, aceleration * delta)
