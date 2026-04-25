extends Node2D

var number = 0
var scanning
var filter
var difficulty
var singer
var song_filtered = []
var count = 0
var filtered

func _ready() -> void:
	filter = "false"
	song_filtered.clear()
	number = 0
	count = 0
	
	$"background/by-difficulty".selected = 0
	$"background/by-singer".selected = 0
	$"background/Option".selected = 0 
	
	$background/Label7.visible = false
	$"background/by-difficulty".visible = false
	$"background/by-singer".visible = false
	
	$background/AnimationPlayer.play("fade in")
	_close_all()
	_song(0)
	
	$background/Label4.text = "Songs Played: %d / %d" % [SongsData.played, 5 + SongsData.song_buy]
	$background/Label2.text = "Full combo count: %d" % SongsData.full_combo_total
	
func _filter(item):
	song_filtered.clear()
	number = 0
	
	for i in range(SongsData.song_list.size()):
		if i >= 5:
			var buy_index = i - 5
			if buy_index >= SongsData.song_buy_array.size():
				continue 
			
			var bought_name = SongsData.song_buy_array[buy_index]
			var real_song = null
			for s in SongsData.song_list:
				if s[1] == bought_name:
					real_song = s
					break
			
			if real_song == null:
				continue
			
			if filter == "difficulty":
				if real_song[5] == item:
					song_filtered.append(i)
			elif filter == "singer":
				if real_song[6] == item or real_song[7] == item:
					song_filtered.append(i)
		else:
			if filter == "difficulty":
				if SongsData.song_list[i][5] == item:
					song_filtered.append(i)
			elif filter == "singer":
				if SongsData.song_list[i][6] == item or SongsData.song_list[i][7] == item:
					song_filtered.append(i)
	
	if not song_filtered.is_empty():
		_close_all()
		_song(song_filtered[0])
	
	if not song_filtered.is_empty():
		_close_all()
		_song(song_filtered[0])

func _show_song_for_buy_index(buy_index):
	if SongsData.song_buy_array.size() <= buy_index:
		return
	scanning = SongsData.song_buy_array[buy_index]
	match scanning:
		"Mozaik Role":
			$"mozaik-role".visible = true
			$"mozaik-role/AudioStreamPlayer2D".play()
			$background/Label3.text = "Dificulty: easy"
		"Ochame Kinou":
			$"ochame-kinou".visible = true
			$"ochame-kinou/AudioStreamPlayer2D".play()
			$background/Label3.text = "Dificulty: medium"
		"Charles":
			$charles.visible = true
			$charles/AudioStreamPlayer2D.play()
			$background/Label3.text = "Dificulty: medium"
		"Phony":
			$phony.visible = true
			$phony/AudioStreamPlayer2D.play()
			$background/Label3.text = "Dificulty: medium"
		"Love Trial":
			$"love-trial".visible = true
			$"love-trial/AudioStreamPlayer2D".play()
			$background/Label3.text = "Dificulty: medium"

func _song(number):
	match number:
		0:
			$"shoujo-rei".visible = true
			$"shoujo-rei/AudioStreamPlayer2D".play()
			$background/Label3.text = "Dificulty: easy"
		1:
			$"just-be-friend".visible = true
			$"just-be-friend/AudioStreamPlayer2D".play()
			$background/Label3.text = "Dificulty: medium"
		2:
			$"the-snow-white-princess".visible = true
			$"the-snow-white-princess/AudioStreamPlayer2D".play()
			$background/Label3.text = "Dificulty: easy"
		3:
			$"bring-it-on".visible = true
			$"bring-it-on/AudioStreamPlayer2D".play()
			$background/Label3.text = "Dificulty: medium"
		4:
			$snowman.visible = true
			$snowman/AudioStreamPlayer2D.play()
			$background/Label3.text = "Dificulty: easy"
		5: _show_song_for_buy_index(0)
		6: _show_song_for_buy_index(1)
		7: _show_song_for_buy_index(2)
		8: _show_song_for_buy_index(3)
		9: _show_song_for_buy_index(4)

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
	$"mozaik-role".visible = false
	$"mozaik-role/AudioStreamPlayer2D".stop()
	$"ochame-kinou".visible = false
	$"ochame-kinou/AudioStreamPlayer2D".stop()
	$charles.visible = false
	$charles/AudioStreamPlayer2D.stop()
	$phony.visible = false
	$phony/AudioStreamPlayer2D.stop()
	$"love-trial".visible = false
	$"love-trial/AudioStreamPlayer2D".stop()

func _process(delta: float) -> void:
	pass

func _on_right_pressed() -> void:
	_close_all()
	if filter == "false":
		if number == 4 + SongsData.song_buy:
			number = 0
		else:
			number += 1
		_song(number)
	else:
		if song_filtered.is_empty():
			return
		if number >= song_filtered.size() - 1:
			number = 0
		else:
			number += 1
		_song(song_filtered[number])

func _on_left_pressed() -> void:
	_close_all()
	if filter == "false":
		if number == 0:
			number = 4 + SongsData.song_buy
		else:
			number -= 1
		_song(number)
	else:
		if song_filtered.is_empty():
			return
		if number <= 0:
			number = song_filtered.size() - 1
		else:
			number -= 1
		_song(song_filtered[number])

func _on_select_pressed() -> void:
	match number:
		0: SongsData.song_selected = 0
		1: SongsData.song_selected = 1
		2: SongsData.song_selected = 2
		3: SongsData.song_selected = 3
		4: SongsData.song_selected = 4
		5:
			if SongsData.song_buy_array.size() > 0:
				scanning = SongsData.song_buy_array[0]
				match scanning:
					"Mozaik Role": SongsData.song_selected = 5
					"Ochame Kinou": SongsData.song_selected = 6
					"Charles": SongsData.song_selected = 7
					"Phony": SongsData.song_selected = 8
					"Love Trial": SongsData.song_selected = 9
		6:
			if SongsData.song_buy_array.size() > 1:
				scanning = SongsData.song_buy_array[1]
				match scanning:
					"Mozaik Role": SongsData.song_selected = 5
					"Ochame Kinou": SongsData.song_selected = 6
					"Charles": SongsData.song_selected = 7
					"Phony": SongsData.song_selected = 8
					"Love Trial": SongsData.song_selected = 9
		7:
			if SongsData.song_buy_array.size() > 2:
				scanning = SongsData.song_buy_array[2]
				match scanning:
					"Mozaik Role": SongsData.song_selected = 5
					"Ochame Kinou": SongsData.song_selected = 6
					"Charles": SongsData.song_selected = 7
					"Phony": SongsData.song_selected = 8
					"Love Trial": SongsData.song_selected = 9
		8:
			if SongsData.song_buy_array.size() > 3:
				scanning = SongsData.song_buy_array[3]
				match scanning:
					"Mozaik Role": SongsData.song_selected = 5
					"Ochame Kinou": SongsData.song_selected = 6
					"Charles": SongsData.song_selected = 7
					"Phony": SongsData.song_selected = 8
					"Love Trial": SongsData.song_selected = 9

	if SongsData.song_list[number][4] == false:
		SongsData.played += 1
		SongsData.song_list[number][4] = true
	$background/AnimationPlayer.play("fade out")
	await $background/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/player_map.tscn")

func _on_store_pressed() -> void:
	$background/AnimationPlayer.play("fade out")
	await $background/AnimationPlayer.animation_finished
	_close_all()
	get_tree().change_scene_to_file("res://scene/store.tscn")

func close_filter():
	$"background/by-difficulty".visible = false
	$"background/by-singer".visible = false
	$background/Label7.visible = false
	song_filtered.clear()

func _on_option_item_selected(index: int) -> void:
	match index:
		0: filter = "false"
		1:
			filter = "difficulty"
			close_filter()
			$"background/by-difficulty".visible = true
			$background/Label7.visible = true
			$background/Label7.text = "Difficulty"
		2:
			filter = "singer"
			close_filter()
			$"background/by-singer".visible = true
			$background/Label7.visible = true
			$background/Label7.text = "Virtual Singer"

func _on_bydifficulty_item_selected(index: int) -> void:
	match index:
		0: pass
		1:
			difficulty = "easy"
			_filter("easy")
		2:
			difficulty = "medium"
			_filter("medium")

func _on_bysinger_item_selected(index: int) -> void:
	match index:
		0: pass
		1: _filter("Miku")
		2: _filter("Luka")
		3: _filter("Meiko")
		4: _filter("Kaito")
		5: _filter("Rin")
		6: _filter("Len")
		7: _filter("other")
