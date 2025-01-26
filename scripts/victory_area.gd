extends Area2D


@export var victory_point : Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	gravity_point_center = victory_point.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body:Node2D):
	var parent = body.get_parent()
	if parent is Player:
		parent.victory(victory_point)
	pass
