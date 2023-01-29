extends Spatial

onready var player = $Player

var selected_item = 0
var selected_item_node = null
onready var selected_item_viewport = $SelectedItem/Viewport/Spatial

#primarily for compression purposes. Not happy at all with this.
var path_instructions = [
	[# 0 (Top | Facing positive y)
		[# 0 (positive x)
			# Each side/dir combo needs 4 entries in the form of:
			# [offset.x, offset.y, offset.z, next_side, base_rotation]
			#
			# last entry should have offset 0,0,0 at the end, which descirbes a
			# step arround the edge to the next side of the same cube.
			#
			# $20 bonus if someone can find a better way to get this info...
			[0, 1, 0, 5, 0],
			[1, 1, 0, 4, 0],
			[1, 0, 0, 0, 0],
			[0, 0, 0, 1, 0]
		   ],
		[# 1 (negative z)
			[0, 1, 0, 5, 2],
			[0, 1, -1, 3, 1],
			[0, 0, -1, 0, 0],
			[0, 0, 0, 2, 1]
		   ],
		[# 2 (negative x)
			[0, 1, 0, 5, 0],
			[-1, 1, 0, 1, 0],
			[-1, 0, 0, 0, 0],
			[0, 0, 0, 4, 0]
		   ],
		[# 3 (positive z)
			[0, 1, 0, 5, 2],
			[0, 1, 1, 2, 1],
			[0, 0, 1, 0, 0],
			[0, 0, 0, 3, 1]
		   ]
	   ],
	[# 1 (Back | Facing positive x)
		[# 0 (negative y)
			[1, 0, 0, 4, 0],
			[1, -1, 0, 0, 0],
			[0, -1, 0, 1, 0],
			[0, 0, 0, 5, 0]
		   ],
		[# 1 (negative z)
			[1, 0, 0, 4, 2],
			[1, 0, -1, 3, 2],
			[0, 0, -1, 1, 0],
			[0, 0, 0, 2, 0]
		   ],
		[# 2 (positive y)
			[1, 0, 0, 4, 0],
			[1, 1, 0, 5, 0],
			[0, 1, 0, 1, 0],
			[0, 0, 0, 0, 0]
		   ],
		[# 3 (positive z)
			[1, 0, 0, 4, 2],
			[1, 0, 1, 2, 0],
			[0, 0, 1, 1, 0],
			[0, 0, 0, 3, 2]
		   ]
	   ],
	[# 2 (Left | Facing negative z)
		[# 0 (negative y)
			[0, 0, -1, 3, 0],
			[0, -1, -1, 0, 3],
			[0, -1, 0, 2, 0],
			[0, 0, 0, 5, 1]
		   ],
		[# 1 (negative x)
			[0, 0, -1, 3, 2],
			[-1, 0, -1, 1, 0],
			[-1, 0, 0, 2, 0],
			[0, 0, 0, 4, 2]
		   ],
		[# 2 (positive y)
			[0, 0, -1, 3, 0],
			[0, 1, -1, 5, 1],
			[0, 1, 0, 2, 0],
			[0, 0, 0, 0, 3]
		   ],
		[# 3 (positive x)
			[0, 0, -1, 3, 2],
			[1, 0, -1, 4, 2],
			[1, 0, 0, 2, 0],
			[0, 0, 0, 1, 0]
		   ]
	   ],
	[# 3 (Right | Facing positive z)
		[# 0 (facing positive y)
			[0, 0, 1, 2, 0],
			[0, 1, 1, 5, 1],
			[0, 1, 0, 3, 0],
			[0, 0, 0, 0, 3]
		   ],
		[# 1 (facing negative x)
			[0, 0, 1, 2, 2],
			[-1, 0, 1, 1, 2],
			[-1, 0, 0, 3, 0],
			[0, 0, 0, 4, 0]
		   ],
		[# 2 (facing negative y)
			[0, 0, 1, 2, 0],
			[0, -1, 1, 0, 3],
			[0, -1, 0, 3, 0],
			[0, 0, 0, 5, 1]
		   ],
		[# 3 (facing positive x)
			[0, 0, 1, 2, 2],
			[1, 0, 1, 4, 0],
			[1, 0, 0, 3, 0],
			[0, 0, 0, 1, 2]
		   ]
	   ],
	[# 4 (Front | Facing negative x)
		[# 0 (facing positive y)
			[-1, 0, 0, 1, 0],
			[-1, 1, 0, 5, 0],
			[0, 1, 0, 4, 0],
			[0, 0, 0, 0, 0]
		   ],
		[# 1 (facing negative z)
			[-1, 0, 0, 1, 2],
			[-1, 0, -1, 3, 0],
			[0, 0, -1, 4, 0],
			[0, 0, 0, 2, 2]
		   ],
		[# 2 (facing negative y)
			[-1, 0, 0, 1, 0],
			[-1, -1, 0, 0, 0],
			[0, -1, 0, 4, 0],
			[0, 0, 0, 5, 0]
		   ],
		[# 3 (facing positive z)
			[-1, 0, 0, 1, 2],
			[-1, 0, 1, 2, 2],
			[0, 0, 1, 4, 0],
			[0, 0, 0, 3, 0]
		   ]
	   ],
	[# 5 (Bottom | facing negative y)
		[# 0 (facing negative x)
			[0, -1, 0, 0, 0],
			[-1, -1, 0, 1, 0],
			[-1, 0, 0, 5, 0],
			[0, 0, 0, 4, 0]
		   ],
		[# 1 (facing negative z)
			[0, -1, 0, 0, 2],
			[0, -1, -1, 3, 3],
			[0, 0, -1, 5, 0],
			[0, 0, 0, 2, 3]
		   ],
		[# 2 (facing positive x)
			[0, -1, 0, 0, 0],
			[1, -1, 0, 4, 0],
			[1, 0, 0, 5, 0],
			[0, 0, 0, 1, 0]
		   ],
		[# 3 (facing positive z)
			[0, -1, 0, 0, 2],
			[0, -1, 1, 2, 3],
			[0, 0, 1, 5, 0],
			[0, 0, 0, 3, 3]
		   ]
	   ]
   ]

func follow_path_3D(location, path: Array, index: int = 0):
	if len(path) <= index:
		return location
	var next
	var checks = path_instructions[location.side][(4 + path[index] - location.dir) % 4]
	if len(checks) != 4:
		return location.new(0, 0, 0, 0, 0)
	for check in checks:
		if WorldData.get_cube(location.offset(check[0], check[1], check[2])) != null:
			return follow_path_3D(location.offset(check[0], check[1], check[2], check[3], (check[4] + location.dir) % 4 ), path, index + 1)
	return null

func move_3D(dir: int):
	
	WorldData.player_location = follow_path_3D(WorldData.player_location, [dir])
	refresh_tiles_3D()
	print(WorldData.player_location.dir)

func refresh_tiles_3D():    
	for cell in cells:
		var location = follow_path_3D(WorldData.player_location, cell['path'])
		cell['node'].set_data(WorldData.get_cube(location), location.side)
		cell['node'].direction = location.dir
		var loc_eq = (WorldData.player_location.x == location.x and
					WorldData.player_location.y == location.y and
					WorldData.player_location.z == location.z and
					WorldData.player_location.side == location.side)
		cell['node'].player_visible = loc_eq and cell['path'] != []
	
	for portal in portals:
		var hide = true
		var c = null
		for perm in portal["cells"]:
			var l = follow_path_3D(WorldData.player_location, perm)
			if c == null:
				c = l
			elif c.x != l.x or c.y != l.y or c.z != l.z or c.dir != l.dir or c.side != l.side:
				hide = false
		if hide:
			portal["node"].hide()
		else:
			portal["node"].show()

onready var cells = [
		{"node": $PrimaryWorld/C, "path": []},
		{"node": $PrimaryWorld/N, "path": [0]},
		{"node": $PrimaryWorld/W, "path": [1]},
		{"node": $PrimaryWorld/S, "path": [2]},
		{"node": $PrimaryWorld/E, "path": [3]},
		{"node": $PrimaryWorld/NE, "path": [0, 3]},
		{"node": $PrimaryWorld/NW, "path": [0, 1]},
		{"node": $PrimaryWorld/SW, "path": [2, 1]},
		{"node": $PrimaryWorld/SE, "path": [2, 3]},
		{"node": $PrimaryWorld/NN, "path": [0, 0]},
		{"node": $PrimaryWorld/NNW, "path": [0, 0, 1]},
		{"node": $PrimaryWorld/NNE, "path": [0, 0, 3]},
		{"node": $PrimaryWorld/NWW, "path": [0, 1, 1]},
		{"node": $PrimaryWorld/NEE, "path": [0, 3, 3]},
		{"node": $PrimaryWorld/EE, "path": [3, 3]},
		{"node": $PrimaryWorld/WW, "path": [1, 1]},
		{"node": $PrimaryWorld/SWW, "path": [2, 1, 1]},
		{"node": $PrimaryWorld/SEE, "path": [2, 3, 3]},
		{"node": $PrimaryWorld/SS, "path": [2, 2]},
		{"node": $PrimaryWorld/SSE, "path": [2, 2, 3]},
		{"node": $PrimaryWorld/SSW, "path": [2, 2, 1]},
		{"node": $SecondaryWorld/WN, "path": [1, 0]},
		{"node": $SecondaryWorld/WNW, "path": [1, 0, 1]},
		{"node": $SecondaryWorld/WNN, "path": [1, 0, 0]},
		{"node": $SecondaryWorld/EN, "path": [3, 0]},
		{"node": $SecondaryWorld/ENE, "path": [3, 0, 3]},
		{"node": $SecondaryWorld/ENN, "path": [3, 0, 0]},
		{"node": $SecondaryWorld/WS, "path": [1, 2]},
		{"node": $SecondaryWorld/WSW, "path": [1, 2, 1]},
		{"node": $SecondaryWorld/WSS, "path": [1, 2, 2]},
		{"node": $SecondaryWorld/ES, "path": [3, 2]},
		{"node": $SecondaryWorld/ESS, "path": [3, 2, 2]},
		{"node": $SecondaryWorld/ESE, "path": [3, 2, 3]},
		{"node": $TernaryWorld/NEN, "path": [0, 3, 0]},
		{"node": $TernaryWorld/EEN, "path": [3, 3, 0]},
		{"node": $TernaryWorld/EES, "path": [3, 3, 2]},
		{"node": $TernaryWorld/SES, "path": [2, 3, 2]},
		{"node": $TernaryWorld/SWS, "path": [2, 1, 2]},
		{"node": $TernaryWorld/WWS, "path": [1, 1, 2]},
		{"node": $TernaryWorld/WWN, "path": [1, 1, 0]},
		{"node": $TernaryWorld/NWN, "path": [0, 1, 0]}
   ]

onready var portals = [
		{"node": $Portals/NE, "cells": [[0, 3], [3, 0]]},
		{"node": $Portals/EEN, "cells": [[3, 3, 0], [0, 3, 3], [3, 0, 3]]},
		{"node": $Portals/NEN, "cells": [[0, 0, 3], [0, 3, 0], [3, 0, 0]]},
		{"node": $Portals/SE, "cells": [[2, 3], [3, 2]]},
		{"node": $Portals/SES, "cells": [[2, 3, 2], [3, 2, 2], [2, 2, 3]]},
		{"node": $Portals/EES, "cells": [[2, 3, 3], [3, 2, 3], [3, 3, 2]]},
		{"node": $Portals/NW, "cells": [[0, 1], [1, 0]]},
		{"node": $Portals/WWN, "cells": [[0, 1, 1], [1, 0, 1], [1, 1, 0]]},
		{"node": $Portals/NWN, "cells": [[0, 0, 1], [0, 1, 0], [1, 0, 0]]},
		{"node": $Portals/SW, "cells": [[2, 1], [1, 2]]},
		{"node": $Portals/WWS, "cells": [[1, 1, 2], [1, 2, 1], [2, 1, 1]]},
		{"node": $Portals/SWS, "cells": [[1, 2, 2], [2, 1, 2], [2, 2, 1]]}
   ]



func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if 0x30 <= event.unicode and event.unicode <= 0x39:
			pass# load_world(event.unicode - 0x30)
	
	if event.is_action_pressed("debug_action"):
		if $Player/Camera.rotation_degrees.x > -45:
			var pl = WorldData.player_location
			var dir = path_instructions[pl.side][0][0]
			var swap_dest = pl.offset(dir[0], dir[1], dir[2], pl.side, 0)
			if WorldData.get_cube(swap_dest) == null:
				WorldData.set_cube(swap_dest, WorldData.get_cube(pl))
				WorldData.set_cube(pl, null)
				WorldData.player_location = swap_dest
				
		else:
			WorldData.player_location = WorldData.player_location.offset(0, 0, 0, 5 - WorldData.player_location.side, 0)
		refresh_tiles_3D()
	
	if event.is_action_pressed("debug_add_block"):
		var pl = WorldData.player_location
		var dir = path_instructions[pl.side][0][0]
		var dest = pl.offset(dir[0], dir[1], dir[2], pl.side, 0)
		if WorldData.get_cube(dest) == null:
			WorldData.set_cube(dest, WorldData.get_empty())
			WorldData.player_location = dest
	
	if event.is_action_pressed("item_select_up"):
		selected_item += 1
		if selected_item >= len(WorldObjects.registry):
			selected_item = 0
		set_selected_gui()
	if event.is_action_pressed("item_select_down"):
		selected_item -= 1
		if selected_item < 0:
			selected_item = len(WorldObjects.registry) - 1
		set_selected_gui()

func set_selected_gui():
	if selected_item_node != null:
		selected_item_node.queue_free()
	selected_item_node = WorldObjects.registry[selected_item].scene.instance()
	selected_item_viewport.add_child(selected_item_node)

func item_used(collider, shape, point, normal):
	if collider == $FloorCollision and abs(point.x) <= 1 and abs(point.z) <= 1:
		print("Place Object", point)
		var cube = WorldData.get_cube(WorldData.player_location)
		if cube is DataTypes.WorldCell:
			var item = WorldObjects.registry[selected_item]
			var side = cube.sides[WorldData.player_location.side]
			var rot = ((int((player.rotation.y + 5.0*PI/4.0) / PI * 2.0) + 3) % 4)
			rot = (rot + 4 - WorldData.player_location.dir) % 4
			if item.is_center:
				if side.center != null:
					side.center = null
				else:
					side.center = item
					side.center_rotation = rot
			else:
				if side.edges[rot] != null:
					side.edges[rot] = null
				else:
					side.edges[rot] = item
			
		refresh_tiles_3D()

# Called when the node enters the scene tree for the first time.
func _ready():
	#load_world(0)
	refresh_tiles_3D()
	set_selected_gui()
	
	refresh_viewport_size()
	get_tree().connect("screen_resized", self, "refresh_viewport_size")
	player.connect("update_camera", self, "update_camera")
	player.connect("moved", self, "update_fake_players")
	player.connect("item_used", self, "item_used")
	WorldData.connect("world_reloaded", self, "refresh_tiles_3D")

func update_fake_players():
	var translation = $PrimaryWorld/C.transform.xform_inv(player.translation)
	get_tree().call_group("FakePlayers", "update_position", translation, player.rotation.y + PI/2.0 * WorldData.player_location.dir)

func refresh_viewport_size():
	for node in get_tree().get_nodes_in_group("Viewports"):
		node.size = get_viewport().size

func update_camera(camera_transform):
	for node in get_tree().get_nodes_in_group("Viewports"):
		node.get_camera().global_transform = camera_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_shape: CollisionShape = player.get_child(1)
	if player.translation.x > 1:
		player.translation.x -= 2
		move_3D(0)
	if player.translation.x < -1:
		player.translation.x += 2
		move_3D(2)
	if player.translation.z > 1:
		player.translation.z -= 2
		move_3D(3)
	if player.translation.z < -1:
		player.translation.z += 2
		move_3D(1)
		
	
#Who needs version control when you can leave unhealthy amounts of code sitting
# in a comment at the bottom.
# (This code pertains to early experiments which were designed to test the rendering)
#
#var map
#
#var current_dir = 0
#var current_cell = 0
#
#func move(direction: int):
#    var current = follow_path(current_cell, current_dir, [direction])
#    current_dir =  current["rotation"]
#    current_cell = current["cell"]
#    refresh_tiles()
#
#func follow_path(start: int, dir: int, path: Array, index: int = 0):
#    if len(path) <= index:
#        return {"cell": start, "rotation": dir, "note": str(path)}
#    var next_dir = (4 - dir + path[index]) % 4
#    var next = map[start]["next"][next_dir]
#    var next_step = follow_path(next["cell"], (next["rotation"] + path[index]) % 4, path, index + 1)
#    return {"cell": next_step["cell"], "rotation": next_step["rotation"], "note": str(path)}
#
#func refresh_tiles():
#    var current = {"cell": current_cell, "rotation": current_dir}
#
#    for cell in cells:
#        var next = follow_path(current_cell, current_dir, cell['path'])
#        cell['node'].color = map[next["cell"]]["color"]
#        cell['node'].direction = next["rotation"]
#        cell['node'].debug_note = next["note"]
#        cell['node'].player_visible = current_cell == next['cell'] and cell['path'] != []
#
#    for portal in portals:
#        var hide = true
#        var dir = null
#        var cell = null
#        for perm in portal["cells"]:
#            var n = follow_path(current_cell, current_dir, perm)
#            if dir == null or cell == null:
#                dir = n["rotation"]
#                cell = n["cell"]
#            elif dir != n["rotation"] or cell != n["cell"]:
#                hide = false
#        if hide:
#            portal["node"].hide()
#        else:
#            portal["node"].show()
#
#
#func load_world(number: int):
#    var map_scene = preload("res://Maps.gd")
#    var maps = map_scene.new()
#    if number < len(maps.maps):
#        map = maps.maps[number]
#
#    current_cell = 0
#
#    refresh_tiles()


