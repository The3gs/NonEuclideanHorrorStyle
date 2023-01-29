extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


var color setget set_color, get_color
var debug_note setget set_note

func set_note(note):
    debug_note = note


func set_color(c: Color):
    var material = SpatialMaterial.new()
    color = c
    material.albedo_color = c
    $MeshInstance.material_override = material

func get_color():
    return color
