extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func set_color(c: Color):
    var material = SpatialMaterial.new()
    material.albedo_color = c
    material.flags_unshaded = true
    $MeshInstance.material_override = material


func clear(new, x1, y1, z1, parent, x2, y2, z2):
    if new == null and x1 == x2 and y1 == y2 and z1 == z2:
        self.queue_free()
