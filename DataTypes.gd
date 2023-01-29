extends Node

class WorldCell:
    var sides: Array
    func _init(side_values):
        sides = side_values

class WorldCellFace:
    var edges: Array
    var center: WorldObject
    var center_rotation: int
    func _init(center_object: WorldObject = null, center_rot: int = 0,
               side0: WorldObject = null, side1: WorldObject = null,
               side2: WorldObject = null, side3: WorldObject = null):
        edges = [side0, side1, side2, side3]
        center = center_object
        center_rotation = center_rot

class WorldObject:
    var scene
    var is_center: bool
    func _init(base_scene, is_centered: bool):
        scene = base_scene
        is_center = is_centered
