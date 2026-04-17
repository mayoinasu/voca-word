extends Node2D

var number = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$background/AnimationPlayer.play("fade in")
	_close_all()
	_song(0)
	

func _song(number):
	$background/TextureButton/Label.text = "BUY"
	$background/TextureButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if number == 0:
		$"mozaik-role".visible = true
		$"mozaik-role/AudioStreamPlayer2D".play()
		
	if number == 1:
		$"ochame-kinou".visible = true
		$"ochame-kinou/AudioStreamPlayer2D".play()
	
	if number == 2:
		$charles.visible = true
		$charles/AudioStreamPlayer2D.play()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$background/Label4.text = "User's full combo: %d" %SongsData.full_combo_total 
	if number == 0:
		if SongsData.bought1 == true:
			$background/TextureButton.modulate = Color(0.729, 0.729, 0.729, 1.0)
			$background/TextureButton/Label.text = "SOLD"
		
	if number == 1:
		if SongsData.bought2 == true:
			$background/TextureButton.modulate = Color(0.729, 0.729, 0.729, 1.0)
			$background/TextureButton/Label.text = "SOLD"
		
	if number == 2:
		if SongsData.bought3 == true:
			$background/TextureButton.modulate = Color(0.729, 0.729, 0.729, 1.0)
			$background/TextureButton/Label.text = "SOLD"
	
		
func _close_all():
	$"mozaik-role".visible = false
	$"mozaik-role/AudioStreamPlayer2D".stop()
	$"ochame-kinou".visible = false
	$"ochame-kinou/AudioStreamPlayer2D".stop()
	$background/Label2.visible = false
	$charles.visible = false
	$charles/AudioStreamPlayer2D.stop()

func _on_right_pressed() -> void:
	if number == 2:
		number = 0
	else:
		number +=1
	_close_all()
	_song(number)


func _on_left_pressed() -> void:
	if number == 0:
		number = 2
	else: 
		number -=1
	_close_all()
	_song(number)


func _on_texture_button_pressed() -> void:
	if number == 0:
		if SongsData.bought1 == false && SongsData.full_combo_total >= 2:
			SongsData.full_combo_total -=2
			SongsData.bought1 = true
			SongsData.song_buy += 1
			SongsData.song_buy_array.append("Mozaik Role")
		elif SongsData.full_combo_total < 2:
			$background/Label2.visible = true
	
	if number == 1:
		if SongsData.bought2 == false && SongsData.full_combo_total >= 2:
			SongsData.full_combo_total -=2
			SongsData.bought2 = true
			SongsData.song_buy += 1
			SongsData.song_buy_array.append("Ochame Kinou")
		elif number == 1 && SongsData.full_combo_total < 2:
			$background/Label2.visible = true
	
	if number == 2:
		if SongsData.bought3 == false && SongsData.full_combo_total >= 2:
			SongsData.full_combo_total -=2
			SongsData.bought3 = true
			SongsData.song_buy += 1
			SongsData.song_buy_array.append("Charles")
		elif number == 2 && SongsData.full_combo_total < 2:
			$background/Label2.visible = true
			


func _on_home_pressed() -> void:
	$background/AnimationPlayer.play("fade out")
	await $background/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/song_selection.tscn")


func _on_question_pressed() -> void:
	$Sprite2D.visible = true


func _on_back_pressed() -> void:
	$Sprite2D.visible = false
