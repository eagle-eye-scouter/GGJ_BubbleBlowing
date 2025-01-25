extends Node2D

# Components used to make a score entry
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const NAME_LENGTH = 3

# Components being displayed
@export var p_name: Label
@export var p_score: Label

# Current position in the name being edited
var name_pos = 0
# Current letter in the alphabet being selected
var alphabet_pos = 0

# Selection flash
var is_showing = true
var flash_timer: Timer

# Set the references to the labels and their default values
func _ready():
	p_name = $Name
	p_score = $Score
	flash_timer = $Timer
	update_name("AAA")
	update_score(000000)
	
func _input(event: InputEvent):
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
			flash_timer.stop()
			toggle_letter(true)

# Calculates new alphabet index when selecting letters
func change_letter(dir: int):
	# Restore the current letter
	toggle_letter(true)
	# Reset flash timer
	flash_timer.start()
	# Switch selected letter to new letter
	alphabet_pos = (alphabet_pos + dir) % ALPHABET.length()
	p_name.text[name_pos] = ALPHABET[alphabet_pos]

# Calculates new letter index in the name
func change_name(dir: int):
	# Restore the current letter
	toggle_letter(true)
	# Reset flash timer
	flash_timer.start()
	# Switch selected letter to existing letter
	name_pos = (name_pos + dir) % NAME_LENGTH
	alphabet_pos = ALPHABET.find(p_name.text[name_pos])
	# Flash to show that the letter is being selected
	toggle_letter(false)

# Update the display for the name
func update_name(new_name: String):
	p_name.text = new_name

# Update the display for the score
func update_score(new_score: int):
	p_score.text = str(new_score)

func _on_timer_timeout():
	is_showing = !is_showing
	toggle_letter(is_showing)

func toggle_letter(show):
	if (show):
		p_name.text[name_pos] = ALPHABET[alphabet_pos]
	else:
		p_name.text[name_pos] = " "
	
	# Toggle display status
	is_showing = show
