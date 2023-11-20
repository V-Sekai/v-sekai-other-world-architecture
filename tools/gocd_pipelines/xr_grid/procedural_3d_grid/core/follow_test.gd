extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true

var _world_grab := WorldGrab.new()
func _process(delta):
	global_transform = _world_grab.split_blend(get_parent().global_transform, global_transform, 0.6, .99, 0.8, get_parent().global_transform.origin)
