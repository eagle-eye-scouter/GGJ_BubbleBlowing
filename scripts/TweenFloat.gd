extends Sprite2D

@onready var sprite = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#set_loops() causes the debugger to freak out, so I set the number of loops very high
	var tween = get_tree().create_tween().set_loops(100)
	#Others ways to write tween properties.
	#tween.tween_property(self, "position", position + Vector2.UP * 100, 5)
	#tween.tween_property(self, "position:y", position.y * 100, 5)
	#tween.tween_property(self, "position:y",100, 5).from(-100)
	#tween_sprite.tween_property(self, "position:y", -40, 5).as_relative()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", Vector2.UP * 40, 5).as_relative()
	tween.tween_property(self, "position:", Vector2.DOWN * 40,5).as_relative()
	pass # Replace with function body.
