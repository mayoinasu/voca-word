extends Node2D

var number = 0

func _ready() -> void:
	$background/AnimationPlayer.play("fade in")
	_close_all()
	_song(0)
	
	$background/Label4.text = "Songs Played: %d / 5" % SongsData.played
	#$background/Label5.text = "Finish all song \n to get new feature"
	#if SongsData.played == 5:
		#$background/Label5.text = "New feature unlocked"
		#$background/next_bonus.visible = true
		
	

func _song(number):
	if number == 0:
		$"shoujo-rei".visible = true
		$"shoujo-rei/AudioStreamPlayer2D".play()
		$background/Label3.text = "Dificulty: easy"
	elif number == 1:
		$"just-be-friend".visible = true
		$"just-be-friend/AudioStreamPlayer2D".play()
		$background/Label3.text = "Dificulty: medium"
	elif number == 2:
		$"the-snow-white-princess".visible = true
		$"the-snow-white-princess/AudioStreamPlayer2D".play()
		$background/Label3.text = "Dificulty: easy"
	elif number == 3:
		$"bring-it-on".visible = true
		$"bring-it-on/AudioStreamPlayer2D".play()
		$background/Label3.text = "Dificulty: medium"
	elif number == 4:
		$snowman.visible = true
		$snowman/AudioStreamPlayer2D.play()
		$background/Label3.text = "Dificulty: easy"


func _close_all():
	$"shoujo-rei".visible = false
	$"shoujo-rei/AudioStreamPlayer2D".stop()
	$"just-be-friend".visible = false
	$"just-be-friend/AudioStreamPlayer2D".stop()
	$"the-snow-white-princess".visible = false
	$"the-snow-white-princess/AudioStreamPlayer2D".stop()
	$"bring-it-on".visible = false
	$"bring-it-on/AudioStreamPlayer2D".stop()
	$snowman.visible = false
	$snowman/AudioStreamPlayer2D.stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_right_pressed() -> void:
	if number == 4:
		number = 0
	else: 
		number +=1
	_close_all()
	_song(number)


func _on_left_pressed() -> void:
	if number == 0:
		number = 4
	else: 
		number -=1
	_close_all()
	_song(number)

	

func _on_select_pressed() -> void:
	if number == 0:
		SongsData.song_selected = 0
	if number == 1:
		SongsData.song_selected = 1
	if number == 2:
		SongsData.song_selected = 2
	if number == 3:
		SongsData.song_selected = 3
	if number == 4:
		SongsData.song_selected = 4
	if SongsData.song_list[number][4] == false:
		SongsData.played += 1
		SongsData.song_list[number][4] = true
	$background/AnimationPlayer.play("fade out")
	await $background/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/player_map.tscn")
