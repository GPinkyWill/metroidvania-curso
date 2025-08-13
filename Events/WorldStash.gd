extends Node

var data = {}


func get_id(node):
	var level = MainInstances.level
	return level.name + "_" + node.name + "_" + str(node.global_position)

func stash(id, key, value):
	if !data.has(id): data[id] = {}
	data[id][key] = value

func retrieve(id, key):
	if !data.has(id): return
	if !data[id].has(key): return
	return data[id][key]
