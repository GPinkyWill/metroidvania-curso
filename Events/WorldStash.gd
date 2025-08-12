extends Node

var data = {}


func get_id(node):
	var world = get_tree().current_scene
	return world.name + "_" + node.name + "_" + str(node.global_position)
