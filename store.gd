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
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if number == 0:
		if SongsData.bought1 == true:
			$background/TextureButton.modulate = Color(0.729, 0.729, 0.729, 1.0)
			$background/TextureButton/Label.text = "SOLD"
		
	if number == 1:
		if SongsData.bought2 == true:
			$background/TextureButton.modulate = Color(0.729, 0.729, 0.729, 1.0)
			$background/TextureButton/Label.text = "SOLD"
	
		
func _close_all():
	$"mozaik-role".visible = false
	$"mozaik-role/AudioStreamPlayer2D".stop()
	$"ochame-kinou".visible = false
	$"ochame-kinou/AudioStreamPlayer2D".stop()


func _on_right_pressed() -> void:
	number +=1
	_close_all()
	_song(number)


func _on_left_pressed() -> void:
	number -=1
	_close_all()
	_song(number)


func _on_texture_button_pressed() -> void:
	if number == 0:
		if SongsData.bought1 == false:
			SongsData.bought1 = true
			SongsData.song_buy += 1
			SongsData.song_buy_array.append("Mozaik Role")
	
	if number == 1:
		if SongsData.bought2 == false:
			SongsData.bought2 = true
			SongsData.song_buy += 1
			SongsData.song_buy_array.append("Ochame Kinou")
			


func _on_home_pressed() -> void:
	$background/AnimationPlayer.play("fade out")
	await $background/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/song_selection.tscn")
