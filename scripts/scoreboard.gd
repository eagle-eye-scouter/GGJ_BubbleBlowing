extends Control

var entries: Array

# Components used to make a score entry
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const NAME_LENGTH = 3

# Current entry being edited
var entry = null
# Current position in the name being edited
var name_pos = 0
# Current letter in the alphabet being selected
var alphabet_pos = 0

var new_name = "AAA"

# Selection flash
var is_showing = true
var flash_timer: Timer

var config_manager: ConfigFile
var scoreboard_location = "user://scoreboard.cfg"
var temp_location = "user://temp.cfg"

# Set the references to the labels and their values
func _ready():
	entries = [$"Score Entry", $"Score Entry2", $"Score Entry3", $"Score Entry4", $"Score Entry5"]
	flash_timer = $Timer
	load_board()

func load_board():
	config_manager = ConfigFile.new()
	# Board exists, load scores
	if (config_manager.load(scoreboard_location) == OK):
		print("Config file found")
		for player in config_manager.get_sections():
			var id = config_manager.get_value(player, "id")
			entries[id].update_name(config_manager.get_value(player, "name"))
			entries[id].update_score(config_manager.get_value(player, "score"))
	else: # Board doesn't exist, make dummy values
		print("Config file not found")
		config_manager.set_value("P1", "id", 0)
		config_manager.set_value("P1", "name", "ACE")
		config_manager.set_value("P1", "score", 5000)
		config_manager.set_value("P2", "id", 1)
		config_manager.set_value("P2", "name", "BOB")
		config_manager.set_value("P2", "score", 4000)
		config_manager.set_value("P3", "id", 2)
		config_manager.set_value("P3", "name", "CAT")
		config_manager.set_value("P3", "score", 3000)
		config_manager.set_value("P4", "id", 3)
		config_manager.set_value("P4", "name", "DAL")
		config_manager.set_value("P4", "score", 2000)
		config_manager.set_value("P5", "id", 4)
		config_manager.set_value("P5", "name", "EOF")
		config_manager.set_value("P5", "score", 1000)
		var err = config_manager.save(scoreboard_location)
		if (err == OK):
			print("Created config file")
		else:
			print(err)
	update_display()
	var temp_config = ConfigFile.new()
	if (temp_config.load(temp_location) == OK):
		print("Temp file found")
		var new_score = temp_config.get_value("P0", "score")
		temp_config.set_value("P0", "score", 0)
		temp_config.save(temp_location)
		receive_score(new_score)
	else:
		print("Temp file not found")

# Save new scores to config file
func update_board():
	config_manager.load(scoreboard_location)
	config_manager.set_value("P1", "name", entries[0].get_p_name())
	config_manager.set_value("P1", "score", entries[0].get_p_score())
	config_manager.set_value("P2", "name", entries[1].get_p_name())
	config_manager.set_value("P2", "score", entries[1].get_p_score())
	config_manager.set_value("P3", "name", entries[2].get_p_name())
	config_manager.set_value("P3", "score", entries[2].get_p_score())
	config_manager.set_value("P4", "name", entries[3].get_p_name())
	config_manager.set_value("P4", "score", entries[3].get_p_score())
	config_manager.set_value("P5", "name", entries[4].get_p_name())
	config_manager.set_value("P5", "score", entries[4].get_p_score())
	config_manager.save(scoreboard_location)

# Compare new score with existing scores
# If score is not noteworthy, it won't be added to the list
func receive_score(new_score):
	entry = null
	var i:int = 0
	
	## Make clone to avoid duplication of scores
	var entries_edit = entries.duplicate()
	
	## While higher scores remain higher, keep incrementing
	while i < entries_edit.size() and entries_edit[i].get_p_score() >= new_score:
		i += 1
	
	## If we reached the end of the list, we can exit early
	if i >= entries_edit.size():
		return
	
	## If we have not reached the end of the list, we can mark this position for insertion
	var insert_index = i
	i += 1
	
	## Shift all following values down by one
	while i < entries_edit.size():
		if i > 0:
			entries_edit[i] = entries[i-1]
	
	## Set the focused entry, and start to update it.
	entry = entries_edit[insert_index]
	update_name("AAA")
	update_score(new_score)
	entries = entries_edit
	flash_timer.start()
		#
	#for old_entry in entries:
		## Noteworthy score, clear old one and update with new one
		#if (new_score > old_entry.get_p_score()):
			#entry = old_entry
			#update_name("AAA")
			#update_score(new_score)
			#flash_timer.start()
			#break

func _input(event: InputEvent):
	# Score is not noteworthy, don't receive edit inputs
	if (!entry):
		return

	# New score on the board
	if (event.is_action_pressed("ui_down") || event.is_action_pressed("player_down")): # Next letter
		change_letter(1)
	elif (event.is_action_pressed("ui_up") || event.is_action_pressed("player_up")): # Previous letter
		change_letter(-1)
	elif (event.is_action_pressed("ui_right") || event.is_action_pressed("player_right")): # Next letter name
		change_name(1)
	elif (event.is_action_pressed("ui_left") || event.is_action_pressed("player_left")): # Previous letter name
		change_name(-1)
	elif (event.is_action_pressed("ui_accept") || event.is_action_pressed("player_breath")): # Confirm pressed
		if (name_pos != NAME_LENGTH-1): # Not selected last letter
			change_name(1)
		else: # Confirming last letter
			flash_timer.paused = true
			flash_timer.stop()
			toggle_letter(true)
			update_display()
			entry = null
			update_board()

# Calculates new alphabet index when selecting letters
func change_letter(dir: int):
	# Restore the current letter
	toggle_letter(true)
	# Switch selected letter to new letter
	alphabet_pos = (alphabet_pos + dir) % ALPHABET.length()
	new_name[name_pos] = ALPHABET[alphabet_pos]
	update_name(new_name)
	update_display()

# Calculates new letter index in the name
func change_name(dir: int):
	# Restore the current letter
	toggle_letter(true)
	# Reset flash timer
	flash_timer.start()
	# Switch selected letter to existing letter
	name_pos = (name_pos + dir) % NAME_LENGTH
	alphabet_pos = ALPHABET.find(entry.get_p_name()[name_pos])
	# Flash to show that the letter is being selected
	toggle_letter(false)

# Update the internals for the name
func update_name(new_p_name: String):
	entry.update_name(new_p_name)

# Update the internals for the score
func update_score(new_p_score: int):
	entry.update_score(new_p_score)

func update_display():
	for nentry in entries:
		nentry.update_display()

func _on_timer_timeout():
	is_showing = !is_showing
	toggle_letter(is_showing)

func toggle_letter(display):
	if (display):
		new_name[name_pos] = ALPHABET[alphabet_pos]
		update_name(new_name)
		flash_timer.start() # Reset flash timer, primarily for edits
	else:
		new_name[name_pos] = " "
		update_name(new_name)
	
	# Toggle display status
	is_showing = display
	update_display()

func _on_texture_button_pressed() -> void:
	if (entry != null):
		flash_timer.paused = true
		flash_timer.stop()
		toggle_letter(true)
		update_display()
		entry = null
		update_board()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") # Exit screen
