extends Node2D
signal reduce_patience(time)

@onready var ui = %CanvasLayer
@onready var bar = %ProgressBar
@onready var elaborate_txts = [%Text1, %Text2, %Text3]
@onready var elaborate_btns = [%Elaborate1, %Elaborate2, %Elaborate3]
const GREEN = Color("00ff00")
const YELLOW = Color("ffff00")
const RED = Color("ff0000")
var dialogue_started = false
var dialogue_progress = 0
var paused_timer
var elephant_clues
var already_paused = false
var convo_ready = true
var clue_hold
var continue_convo = false

func _ready() -> void:
	hide_ui()

func _physics_process(_delta: float) -> void:
	%Clue1.visible_ratio = (%Timer.wait_time - %Timer.time_left) / %Timer.wait_time
	%Clue2.visible_ratio = (%Timer2.wait_time - %Timer2.time_left) / %Timer2.wait_time
	%Clue3.visible_ratio = (%Timer3.wait_time - %Timer3.time_left) / %Timer3.wait_time
	if clue_hold:
		clue_hold.visible_ratio = (%Temp_Timer.wait_time - %Temp_Timer.time_left) / %Temp_Timer.wait_time

func set_timers(cus_type):
	match cus_type:
		"Pig":
			pass
		"Bear":
			pass
		"Fox":
			pass
		"Sloth":
			%Timer.wait_time = 1
			%Timer2.wait_time = 1
			%Timer3.wait_time = 1
		"Rabbit":
			%Timer.wait_time = 2
			%Timer2.wait_time = 2
			%Timer3.wait_time = 2
		"Peacock":
			pass
		"Panther":
			pass
		"Elephant":
			pass
		"Crocodile":
			pass

func update_patience(val) -> void:
	bar.value = val
	if bar.value < 33.3:
		bar.modulate = RED
	elif bar.value < 66.7:
		bar.modulate = YELLOW

func update_cus_image(image_path):
	%Customer_Img.texture = load(image_path)
	
func update_cus_name(cus_name):
	%Customer_Name.text = cus_name
	
func create_dialogue(cus_type, clues, clue_type):
	match cus_type:
		"Pig":
			%Clue1.text = "Could I have a " + clues[0] + "?"
			%Clue2.text = "Actually, I'd like some " + clues[1] + "."
			%Clue3.text = "Nevermind, get me a little " + clues[2] + "."
			update_images(clues)
		"Bear":
			%Clue1.text = "Don't keep me waiting! Bring me a " + clues[0] + "."
			%Clue2.text = "Grrr, that's not good enough. Feed me some " + clues[1] + " instead."
			%Clue3.text = "No, no, no! I want " + clues[2] + ", now!"
			update_images(clues)
		"Fox":
			if clue_type == "dish":
				create_dialogue(["Pig", "Bear", "Rabbit", "Peacock", "Panther", "Elephant"].pick_random(), clues, clue_type)
			elif clue_type == "neg_dish":
				create_dialogue(["Panther", "Crocodile"].pick_random(), clues, clue_type)
			else:
				create_dialogue(["Sloth", "Peacock"].pick_random(), clues, clue_type)
			#%Clue1.text = "Could I have a " + clues[0] + "?"
			#%Clue2.text = "Actually, I'd like some " + clues[1] + "."
			#%Clue3.text = "Nevermind, get me a little " + clues[2] + "."
			#update_images(clues)
		"Sloth":
			var clue1 = clues[0]
			var clue2 = clues[1]
			var clue3 = clues[2]
			%Clue1.text = "I'd like something..." + clue1 + "."
			%Box1.hide()
			%Clue2.text = "Hmm...something " + clue2 + "."
			%Box2.hide()
			%Clue3.text = "Can you make it a bit " + clue3 + "? Thanks..."
			%Box3.hide()
		"Rabbit":
			%Clue1.text = "The other day " + ["Susanne", "Helen", "Nicky", "Holly"].pick_random() + " mentioned this amazing " + clues[0] + " place she found downtown over the weekend. Gave it a raving review of five stars, so I think I should check it out later."
			%Clue2.text = "There was this recipe I found online for homemade " + clues[1] + ", but I can’t seem to be any good at it! I wonder what I’m doing wrong - maybe my measurements are a little off?"
			%Clue3.text = "Oh, I hope " + ["Margaret", "Janice", "Debbie", "Barbara"].pick_random() + " isn’t upset that we’re going to have some " + clues[2] + " without her... I know she really loves attending these outings."
			update_images(clues)
		"Peacock":
			if clue_type == "dish":
				%Clue1.text = "Fetch me a " + clues[0] + "!"
				%Clue2.text = "On second thought, I request " + clues[1] + "!"
				%Clue3.text = "Fah! Servant, bring me " + clues[2] + "!"
				update_images(clues)
			else:
				%Clue1.text = "I shall feast upon something " + clues[0] + "!"
				%Clue2.text = "And in the form of " + clues[1] + "!"
				%Clue3.text = "Make it " + clues[2] + ", and make it quick!"
				%Box1.hide()
				%Box2.hide()
				%Box3.hide()
		"Panther":
			if clue_type == "dish":
				%Clue1.text = "Give me " + clues[0] + "."
				%Clue2.text = "No, maybe " + clues[1] + " instead."
				%Clue3.text = "I hunger for " + clues[2] + "."
			else:
				%Clue1.text = "I despise " + clues[0] + "."
				%Clue2.text = "If you give me " + clues[1] + ", you'll regret it."
				%Clue3.text = "" + clues[2] + " makes me want to hurl."
			update_images(clues)
		"Elephant":
			elephant_clues = clues
			reset_elephant_text()
		"Crocodile":
			%Clue1.text = "I'm not in the mood for any " + clues[0] + "."
			%Clue2.text = "I'm allergic to " + clues[1] + ", and similar things."
			%Clue3.text = "I had " + clues[2] + " yesterday, I want something different."
			update_images(clues)
	
func update_images(clues):
	%Pic1.texture = load(InitDishes.menu[clues[0]]["Image"])
	%Pic2.texture = load(InitDishes.menu[clues[1]]["Image"])
	%Pic3.texture = load(InitDishes.menu[clues[2]]["Image"])
	%Answer1.text = InitDishes.get_tags(clues[0])
	%Answer2.text = InitDishes.get_tags(clues[1])
	%Answer3.text = InitDishes.get_tags(clues[2])
	
func reset_elephant_text() -> void:
	%Clue1.text = "I would like to try the " + elephant_clues[0] + "."
	%Clue2.text = "On second thought, maybe the " + elephant_clues[1] + "."
	%Clue3.text = "Could I have the " + elephant_clues[2] + "?"
	update_images(elephant_clues)
	
func pause_elephant_hints(clue) -> void:
	clue_hold = clue
	%Temp_Timer.start()
	clue_hold.text = "Hm...actually, come back later. I'm not ready to order."
	%Elephant_Timer.start()
	clue_hold.show()
	convo_ready = false
	
func hide_ui() -> void:
	ui.visible = false
	if %Timer.time_left > 0:
		%Timer.paused = true
		paused_timer = %Timer
	elif %Timer2.time_left > 0:
		%Timer2.paused = true
		paused_timer = %Timer2
	elif %Timer3.time_left > 0:
		%Timer3.paused = true
		paused_timer = %Timer3
	
func show_ui() -> void:
	ui.visible = true
	if not convo_ready: return
	if paused_timer:
		paused_timer.paused = false
	if not dialogue_started:
		dialogue_started = true
		if elephant_clues:
			if not already_paused and randf() < 0.25:
				pause_elephant_hints(%Clue1)
				return
			elif dialogue_progress < 1:
				%Clue1.show()
				%Timer.start()
				dialogue_progress += 1
		else:
			%Clue1.show()
			%Timer.start()
	elif elephant_clues and continue_convo:
		continue_convo = false
		if dialogue_progress == 0:
			%Timer.start()
		elif dialogue_progress == 1:
			%Pic1.show()
			%Elaborate1.show()
			%Timer2.start()
		else:
			%Pic2.show()
			%Elaborate2.show()
			%Timer3.start()
		#reset_elephant_text()
		
func _on_timer_timeout() -> void:
	%Pic1.show()
	%Elaborate1.show()
	await get_tree().create_timer(0.5).timeout
	if elephant_clues:
		if not already_paused and randf() < 0.25:
			pause_elephant_hints(%Clue2)
			return
		dialogue_progress += 1
	%Timer2.start()
	await get_tree().physics_frame
	%Clue2.show()

func _on_timer_2_timeout() -> void:
	%Pic2.show()
	%Elaborate2.show()
	await get_tree().create_timer(0.5).timeout
	if elephant_clues:
		if not already_paused and randf() < 0.25:
			pause_elephant_hints(%Clue3)
			return
		dialogue_progress += 1
	%Timer3.start()
	await get_tree().physics_frame
	%Clue3.show()

func _on_timer_3_timeout() -> void:
	%Pic3.show()
	%Elaborate3.show()

func _on_elaborate_1_pressed() -> void:
	%Elaborate1.hide()
	if %Text1.text == "Could you hurry up?":
		%Text1.text = "Can you elaborate?"
		%Elephant_Timer.stop()
		_on_elephant_timer_timeout()
		show_ui()
	else:
		%Answer1.show()
	emit_signal("reduce_patience", 10)

func _on_elaborate_2_pressed() -> void:
	%Elaborate2.hide()
	if %Text2.text == "Could you hurry up?":
		%Text2.text = "Can you elaborate?"
		%Clue2.visible_ratio = 0
		%Elephant_Timer.stop()
		_on_elephant_timer_timeout()
		show_ui()
	else:
		%Answer2.show()
	emit_signal("reduce_patience", 10)

func _on_elaborate_3_pressed() -> void:
	%Elaborate3.hide()
	if %Text3.text == "Could you hurry up?":
		%Text3.text = "Can you elaborate?"
		%Clue3.visible_ratio = 0
		%Elephant_Timer.stop()
		_on_elephant_timer_timeout()
		show_ui()
	else:
		%Answer3.show()
	emit_signal("reduce_patience", 10)

func _on_elephant_timer_timeout() -> void:
	already_paused = true
	convo_ready = true
	continue_convo = true
	reset_elephant_text()

func _on_temp_timer_timeout() -> void:
	elaborate_txts[dialogue_progress].text = "Could you hurry up?"
	elaborate_btns[dialogue_progress].show()
