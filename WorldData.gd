extends Node

class Location:
    var x: int = 0
    var y: int = 0
    var z: int = 0
    var side: int = 0
    var dir: int = 0
# warning-ignore:shadowed_variable
    func offset(x: int, y: int, z: int, side = 0, dir = 0):
        return Location.new(self.x + x, self.y + y, self.z + z, side, dir)
# warning-ignore:shadowed_variable
    func _init(x: int, y: int, z: int, side: int = 0, dir: int = 0):
        self.x = x
        self.y = y
        self.z = z
        self.side = side
        self.dir = dir

var player_location setget set_pl

signal player_moved
signal cube_changed(new, x, y, z)
signal world_reloaded

func set_pl(loc: Location):
    var map_size = len(map_3D)
    var loca = Location.new((loc.x + map_size) % map_size, 
                            (loc.y + map_size) % map_size, 
                            (loc.z + map_size) % map_size,
                            loc.side, loc.dir)
    
    player_location = loca
    emit_signal("player_moved")

func get_empty():
    return DataTypes.WorldCell.new(
            [
                DataTypes.WorldCellFace.new(null, 0, null, null, null, null),
                DataTypes.WorldCellFace.new(null, 0, null, null, null, null),
                DataTypes.WorldCellFace.new(null, 0, null, null, null, null),
                DataTypes.WorldCellFace.new(null, 0, null, null, null, null),
                DataTypes.WorldCellFace.new(null, 0, null, null, null, null),
                DataTypes.WorldCellFace.new(null, 0, null, null, null, null),
               ]
       )

onready var map_3D = [
    [[null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null]],
    [[null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null]],
    [[null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, get_empty(), null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null]],
    [[null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, get_empty(), null, null, null],
     [null, null, get_empty(), get_empty(), get_empty(), null, null],
     [null, null, null, get_empty(), null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null]],
    [[null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, DataTypes.WorldCell.new(
            [
                DataTypes.WorldCellFace.new(null, 0, null, WorldObjects.Fence, null, WorldObjects.BrokenFence),
                DataTypes.WorldCellFace.new(WorldObjects.Well, 1, null, null, null, null),
                DataTypes.WorldCellFace.new(null, 0, null, WorldObjects.Fence, null, null),
                DataTypes.WorldCellFace.new(null, 0, null, WorldObjects.Fence, null, null),
                DataTypes.WorldCellFace.new(WorldObjects.HugeCross, 0, null, null, null, null),
                DataTypes.WorldCellFace.new(null, 0, WorldObjects.Fence, null, null, null),
               ]
       )
        , null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null]],
    [[null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null]],
    [[null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null],
     [null, null, null, null, null, null, null]]
   ]


func get_cube(location: Location):
    var map_size = len(map_3D)
    return map_3D[(location.x + map_size) % map_size]\
                 [(location.y + map_size) % map_size]\
                 [(location.z + map_size) % map_size]

func set_cube(location: Location, value):
    var map_size = len(map_3D)
    map_3D[(location.x + map_size) % map_size]\
          [(location.y + map_size) % map_size]\
          [(location.z + map_size) % map_size] = value
    emit_signal("cube_changed", value, (location.x + map_size) % map_size, 
                                        (location.y + map_size) % map_size, 
                                        (location.z + map_size) % map_size)

func _ready():
    player_location = Location.new(3, 4, 3, 0, 0)

func _input(event):
    if event.is_action_pressed("debug_regen"):
        randomize_world(7)

func randomize_world(map_size: int = 10):
    randomize()
    map_3D = []
    for i in range(map_size):
        map_3D.append([])
        for j in range(map_size):
            map_3D[i].append([])
# warning-ignore:unused_variable
            for k in range(map_size):
                if randi() % 10 == 0:
                    map_3D[i][j].append(Color(randi()))
                else:
                    map_3D[i][j].append(null)
    set_cube(player_location, Color(randi()))
    emit_signal("world_reloaded")
