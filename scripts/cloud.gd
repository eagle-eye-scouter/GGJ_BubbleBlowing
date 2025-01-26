extends Node2D
class_name Cloud

var starting_position : Vector2

@export var velocity : float = 20
@export var direction := Vector2(1,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * velocity * delta
	_active_process(delta)
	
	if abs(global_position.x) > 1000:
		global_position = starting_position
	
	if global_position.x > 1.5 * get_viewport_rect().size.x and direction.x > 0:
		global_position.x = -0.5 * get_viewport_rect().size.x
		global_position.y = starting_position.y
	elif global_position.x < -0.5 * get_viewport_rect().size.x and direction.x < 0:
		global_position.x = 1.5 * get_viewport_rect().size.x
		global_position.y = starting_position.y


func _active_process(delta: float) -> void:
	pass
