extends Node2D

var hurtbox : Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.area_entered.connect(_on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area:Node2D):
	if area is GumBubble:
		area.pop()
