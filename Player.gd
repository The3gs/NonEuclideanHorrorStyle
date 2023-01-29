extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	WorldData.connect("player_moved", self, "refresh_debug_info")
	refresh_debug_info()

func refresh_debug_info():
	var loc = WorldData.player_location
	$HUD/Debug/Coords.text = ("X:" + str(loc.x) + 
							  " Y:" + str(loc.y) + 
							  " Z:" + str(loc.z) + 
							  " Side:" + str(loc.side) + 
							  " Direction:" + str(loc.dir))
	

var speed = 4
var sneak_modifier = 0.5
var jump_power = 3

var gravity = Vector3.DOWN * 9.8
var velocity = Vector3.ZERO

signal update_camera(camera_transform)
signal moved
signal item_used(collider, shape, point, normal)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x/100)
		var cam = $Camera.rotation.x
		cam -= event.relative.y/100
		$Camera.rotation.x = PI/2 if cam > PI/2 else cam if cam > -PI/2 else -PI/2
		emit_signal("update_camera", $Camera.global_transform)
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton and event.is_pressed():
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().set_input_as_handled()
	
	if event.is_action_pressed("debug_coords"):
		$HUD/Debug.visible = not $HUD/Debug.visible
	

func _unhandled_input(event):
	if event.is_action_pressed("use_item"):
		var raycast = $Camera/RayCast
		emit_signal("item_used", raycast.get_collider(), raycast.get_collider_shape(),
			raycast.get_collision_point(), raycast.get_collision_normal())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = 0
	velocity.z = 0
	if Input.is_action_pressed("move_forward"):
		velocity += -transform.basis.z * speed * (sneak_modifier if Input.is_action_pressed("move_sneak") else 1.0)
	if Input.is_action_pressed("move_back"):
		velocity += transform.basis.z * speed * (sneak_modifier if Input.is_action_pressed("move_sneak") else 1.0)
	if Input.is_action_pressed("move_left"):
		velocity += -transform.basis.x * speed * (sneak_modifier if Input.is_action_pressed("move_sneak") else 1.0)
	if Input.is_action_pressed("move_right"):
		velocity += transform.basis.x * speed * (sneak_modifier if Input.is_action_pressed("move_sneak") else 1.0)
	
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity += jump_power * Vector3.UP
	
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	emit_signal("update_camera", $Camera.global_transform)
	emit_signal("moved")
