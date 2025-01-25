extends Control

func _ready() -> void:
	get_node("VBoxContainer/TextureButtonStart").grab_focus()

func _on_texture_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scroll_world.tscn")

func _on_texture_button_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scoreboard.tscn")

func _on_texture_button_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scoreboard.tscn")

func _on_texture_button_exit_pressed() -> void:
	get_tree().quit()
