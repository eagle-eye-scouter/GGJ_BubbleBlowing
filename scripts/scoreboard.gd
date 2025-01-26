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

# Set the references to the labels and their values
func _ready():
	entries = [$"Score Entry", $"Score Entry2", $"Score Entry3"]
	flash_timer = $Timer

# Compare new score with existing scores
# If score is not noteworthy, it won't be added to the list
func receive_score(new_score):
	entry = null
	for old_entry in entries:
		# Noteworthy score, clear old one and update with new one
		if (new_score > old_entry.get_p_score()):
			entry = old_entry
			update_name(new_name)
			update_score(new_score)
			flash_timer.start()
			break

func _input(event: InputEvent):
	# Score is not noteworthy, don't receive edit inputs
	if (!entry):
		if (event.is_action_pressed("ui_accept")):
			return # Exit screen
		else:
			return

	# New score on the board
	if (event.is_action_pressed("ui_down")): # Next letter
		change_letter(1)
	elif (event.is_action_pressed("ui_up")): # Previous letter
		change_letter(-1)
	elif (event.is_action_pressed("ui_right")): # Next letter name
		change_name(1)
	elif (event.is_action_pressed("ui_left")): # Previous letter name
		change_name(-1)
	elif (event.is_action_pressed("ui_accept")): # Confirm pressed
		if (name_pos != NAME_LENGTH-1): # Not selected last letter
			change_name(1)
		else: # Confirming last letter
			flash_timer.paused = true
			flash_timer.stop()
			toggle_letter(true)
			update_display()
			entry = null
			return # Exit screen
	update_display()

# Calculates new alphabet index when selecting letters
func change_letter(dir: int):
	# Restore the current letter
	toggle_letter(true)
	# Switch selected letter to new letter
	alphabet_pos = (alphabet_pos + dir) % ALPHABET.length()
	new_name[name_pos] = ALPHABET[alphabet_pos]
	update_name(new_name)

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
	entry.update_display()

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
