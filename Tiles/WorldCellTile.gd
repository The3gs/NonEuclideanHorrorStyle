extends Spatial

var side0 = null
var side1 = null
var side2 = null
var side3 = null
var center = null

func set_data(side_data):
	if side0 != null:
		side0.queue_free()
		side0 = null
	if side_data.edges[0] != null:
		side0 = side_data.edges[0].scene
	if side0 != null:
		side0 = side0.instance()
		add_child(side0)
	
	if side1 != null:
		side1.queue_free()
		side1 = null
	if side_data.edges[1] != null:
		side1 = side_data.edges[1].scene
	if side1 != null:
		side1 = side1.instance()
		side1.rotate_y(PI/2)
		add_child(side1)
	
	if side2 != null:
		side2.queue_free()
		side2 = null
	if side_data.edges[2] != null:
		side2 = side_data.edges[2].scene
	if side2 != null:
		side2 = side2.instance()
		side2.rotate_y(PI)
		add_child(side2)
	
	if side3 != null:
		side3.queue_free()
		side3 = null
	if side_data.edges[3] != null:
		side3 = side_data.edges[3].scene
	if side3 != null:
		side3 = side3.instance()
		side3.rotate_y(3*PI/2)
		add_child(side3)
	
	if center != null:
		center.queue_free()
		center = null
	if side_data.center != null:
		center = side_data.center.scene
	if center != null:
		center = center.instance()
		center.rotate_y(side_data.center_rotation*PI/2)
		add_child(center)
	




