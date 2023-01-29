extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    WorldData.connect("player_moved", self, "player_moved")
    WorldData.connect("cube_changed", self, "add_node")
    WorldData.connect("world_reloaded", self, "refresh_world")
    refresh_world()

func refresh_world():
    var old_children = $Cubes.get_children()
    var mini_map_cube = preload("res://MiniMapCube.tscn")
    var mapsize = len(WorldData.map_3D)
    for i in range(mapsize):
        for j in range(mapsize):
            for k in range(mapsize):
                if WorldData.get_cube(WorldData.Location.new(i, j, k)) != null:
                    var node = mini_map_cube.instance()
                    var color = WorldData.get_cube(WorldData.Location.new(i, j, k))
                    if color is Color:
                        node.set_color(color)
                    $Cubes.add_child(node)
                    node.translate(Vector3(i-mapsize/2, j-mapsize/2, k-mapsize/2))
                    WorldData.connect("cube_changed", node, "clear", [self, i, j, k])
    for cube in old_children:
        cube.queue_free()

func add_node(new, x, y, z):
    if new == null:
        return
    var mini_map_cube = preload("res://MiniMapCube.tscn")
    var node = mini_map_cube.instance()
    if new is Color:
        node.set_color(new)
    $Cubes.add_child(node)
    var mapsize = len(WorldData.map_3D)
    node.translate(Vector3(x-mapsize/2, y-mapsize/2, z-mapsize/2))
    WorldData.connect("cube_changed", node, "clear", [self, x, y, z])

func delete_node(new, x1, y1, z1, node, x2, y2, z2):
    if node != null and new == null and x1 == x2 and y1 == y2 and z1 == z2:
        node.queue_free()

func player_moved():
    var pl = WorldData.player_location
    var ms = len(WorldData.map_3D)/2
    $PlayerMarker.translation = Vector3(pl.x-ms, pl.y-ms, pl.z-ms)
    camera_dest = Vector3(pl.x-ms, pl.y-ms, pl.z-ms)
    match pl.side:
        0:
            $PlayerMarker.rotation_degrees = Vector3(0, 0, 0)
            camera_rot_deg_x = 0
        1:
            $PlayerMarker.rotation_degrees = Vector3(0, 0, -90)
            camera_rot_deg_x = 20 if camera_rot_deg_x == 0 else 70
            camera_rot_deg_y = 45
        2:
            $PlayerMarker.rotation_degrees = Vector3(-90, 0, 0)
            camera_rot_deg_x = 20 if camera_rot_deg_x == 0 else 70
            camera_rot_deg_y = 135
        3:
            $PlayerMarker.rotation_degrees = Vector3(90, 0, 0)
            camera_rot_deg_x = 20 if camera_rot_deg_x == 0 else 70
            camera_rot_deg_y = -45
        4:
            $PlayerMarker.rotation_degrees = Vector3(0, 0, 90)
            camera_rot_deg_x = 20 if camera_rot_deg_x == 0 else 70
            camera_rot_deg_y = -135
        5:
            $PlayerMarker.rotation_degrees = Vector3(180, 0, 0)
            camera_rot_deg_x = 90
    lerp_weight = 0
    prev_pos = $CameraPivot.translation
    prev_rot = $CameraPivot.rotation

var camera_dest = Vector3.ZERO
var camera_rot_deg_x = 45
var camera_rot_deg_y = 0
var lerp_weight = 1
var prev_rot = Vector3.ZERO
var prev_pos = Vector3.ZERO

func _process(delta):
#    var boost = 1.0
#    if Input.is_action_pressed("move_sneak"):
#        boost = 10.0
#    $CameraPivotA.rotate_y(delta * 0.3 * boost)
    var rot_dest = Quat(Vector3(camera_rot_deg_x * PI/180, camera_rot_deg_y * PI/180, 0))
    var cur_rot = Quat(prev_rot)
    var lerped_rot = cur_rot.slerp(rot_dest, lerp_weight)
    $CameraPivot.translation = prev_pos.linear_interpolate(camera_dest, lerp_weight)
    lerp_weight += delta
    if lerp_weight > 1.0:
        lerp_weight = 1.0
    $CameraPivot.rotation = lerped_rot.get_euler()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
