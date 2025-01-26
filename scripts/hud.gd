extends Camera2D

@onready var player = $"../Player"
@onready var diffstance = global_position.y-player.global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player.state != player.State.DEAD):
		global_position.y = player.global_position.y + diffstance
		update_hud()

func update_hud():
	$TimeLabel.set_text(str(int(player.timer.time_left)))  
	$ScoreLabel.set_text(str(int(player.score)))
