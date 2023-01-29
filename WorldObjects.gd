extends Node

# Walls
var Fence = DataTypes.WorldObject.new(preload("res://Objects/Walls/Fence.tscn"), false)
var BrokenFence = DataTypes.WorldObject.new(preload("res://Objects/Walls/BrokenFence.tscn"), false)


# CenterPieces
var SignPost = DataTypes.WorldObject.new(preload("res://Objects/Center/SignPost.tscn"), true)
var SmallCross = DataTypes.WorldObject.new(preload("res://Objects/Center/SmallCross.tscn"), true)
var MediumCross = DataTypes.WorldObject.new(preload("res://Objects/Center/MediumCross.tscn"), true)
var LargeCross = DataTypes.WorldObject.new(preload("res://Objects/Center/LargeCross.tscn"), true)
var HugeCross = DataTypes.WorldObject.new(preload("res://Objects/Center/HugeCross.tscn"), true)
var Well = DataTypes.WorldObject.new(preload("res://Objects/Center/Well.tscn"), true)
var Crystal = DataTypes.WorldObject.new(preload("res://Objects/Center/Crystal.tscn"), true)

var registry = [Fence, BrokenFence, SignPost, SmallCross, MediumCross, LargeCross, HugeCross, Well, Crystal]
