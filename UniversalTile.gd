extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_type = "None"

var current_tile = null

var direction setget set_direction, get_direction
var player_visible setget set_pv

func set_pv(value):
	player_visible = value
	$FakePlayer.visible = value

func set_direction(dir):
	direction = dir
	self.rotation_degrees.y = 90 * dir

func get_direction():
	return direction


func set_data(value, side):
	if value is Color:
		if current_type == "Colored":
			current_tile.color = value
		else:
			current_type = "Colored"
			if current_tile != null:
				current_tile.queue_free()
			current_tile = preload("res://Tiles/ColoredTile.tscn").instance()
			add_child(current_tile)
			current_tile.color = value
	elif value is DataTypes.WorldCell:
		if current_type == "WorldCell":
			current_tile.set_data(value.sides[side])
		else:
			current_type = "WorldCell"
			if current_tile != null:
				current_tile.queue_free()
			current_tile = preload("res://Tiles/WorldCellTile.tscn").instance()
			add_child(current_tile)
			current_tile.set_data(value.sides[side])
