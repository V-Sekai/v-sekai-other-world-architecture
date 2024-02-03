@tool
class_name Joint
extends RefCounted


## Standard joints
enum {
	JOINT_HIPS = 0,
	JOINT_SPINE = 1,
	JOINT_CHEST = 2,
	JOINT_UPPER_CHEST = 3,
	JOINT_NECK = 4,
	JOINT_HEAD = 5,
	JOINT_LEFT_SHOULDER = 6,
	JOINT_LEFT_UPPER_ARM = 7,
	JOINT_LEFT_LOWER_ARM = 8,
	JOINT_LEFT_HAND = 9,
	JOINT_LEFT_THUMB_METACARPAL = 10,
	JOINT_LEFT_THUMB_PROXIMAL = 11,
	JOINT_LEFT_THUMB_DISTAL = 12,
	JOINT_LEFT_INDEX_PROXIMAL = 13,
	JOINT_LEFT_INDEX_INTERMEDIATE = 14,
	JOINT_LEFT_INDEX_DISTAL = 15,
	JOINT_LEFT_MIDDLE_PROXIMAL = 16,
	JOINT_LEFT_MIDDLE_INTERMEDIATE = 17,
	JOINT_LEFT_MIDDLE_DISTAL = 18,
	JOINT_LEFT_RING_PROXIMAL = 19,
	JOINT_LEFT_RING_INTERMEDIATE = 20,
	JOINT_LEFT_RING_DISTAL = 21,
	JOINT_LEFT_LITTLE_PROXIMAL = 22,
	JOINT_LEFT_LITTLE_INTERMEDIATE = 23,
	JOINT_LEFT_LITTLE_DISTAL = 24,
	JOINT_RIGHT_SHOULDER = 25,
	JOINT_RIGHT_UPPER_ARM = 26,
	JOINT_RIGHT_LOWER_ARM = 27,
	JOINT_RIGHT_HAND = 28,
	JOINT_RIGHT_THUMB_METACARPAL = 29,
	JOINT_RIGHT_THUMB_PROXIMAL = 30,
	JOINT_RIGHT_THUMB_DISTAL = 31,
	JOINT_RIGHT_INDEX_PROXIMAL = 32,
	JOINT_RIGHT_INDEX_INTERMEDIATE = 33,
	JOINT_RIGHT_INDEX_DISTAL = 34,
	JOINT_RIGHT_MIDDLE_PROXIMAL = 35,
	JOINT_RIGHT_MIDDLE_INTERMEDIATE = 36,
	JOINT_RIGHT_MIDDLE_DISTAL = 37,
	JOINT_RIGHT_RING_PROXIMAL = 38,
	JOINT_RIGHT_RING_INTERMEDIATE = 39,
	JOINT_RIGHT_RING_DISTAL = 40,
	JOINT_RIGHT_LITTLE_PROXIMAL = 41,
	JOINT_RIGHT_LITTLE_INTERMEDIATE = 42,
	JOINT_RIGHT_LITTLE_DISTAL = 43,
	JOINT_LEFT_UPPER_LEG = 44,
	JOINT_LEFT_LOWER_LEG = 45,
	JOINT_LEFT_FOOT = 46,
	JOINT_RIGHT_UPPER_LEG = 47,
	JOINT_RIGHT_LOWER_LEG = 48,
	JOINT_RIGHT_FOOT = 49,
	JOINT_COUNT = 50
}


## Joint valid flag
var valid : bool = false

## Joint position
var position : Vector3 = Vector3.ZERO

## Joint rotation
var rotation : Quaternion = Quaternion.IDENTITY


# Convert to string
func _to_string() -> String:
	return "Joint_%d (%f,%f,%f) / (%f,%f,%f,%f : %f)" % [
		get_instance_id(),
		position.x,
		position.y,
		position.z,
		rotation.w,
		rotation.x,
		rotation.y,
		rotation.z,
		rotation.length()
	]
