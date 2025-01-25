extends Marker2D


@onready var fleet : Node2D = $Fleet
@onready var trigger : Area2D = $Trigger


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trigger.body_entered.connect(_on_body_entered)
	pass # Replace with function body.


func _on_body_entered(body:Node2D):
	if body is Player:
		for child in fleet.get_children():
			if child is Obstacle:
				child.state = Obstacle.State.ACTIVE
	pass
