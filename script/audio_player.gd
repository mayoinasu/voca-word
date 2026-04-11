extends AudioStreamPlayer

const home_bgm = preload ("res://audio-asset/Home-bgm.mp3")
const tut1 = preload("res://audio-asset/Miku1.WAV")
const tut2 = preload("res://audio-asset/Miku2.WAV")
const tut3 = preload("res://audio-asset/Miku3.WAV")
const full_combo = preload("res://audio-asset/freesound_community-yay-6120.mp3")
const song_end = preload("res://audio-asset/freesound_community-yipee-45360.mp3")
const shoujo_rei = preload("res://audio-asset/shoujo-rei.WAV")
const just_be_friends = preload("res://audio-asset/Just be friends - full - seriously.WAV")
const the_snow_white_princess_is = preload ("res://audio-asset/The snow white princess is - full.WAV")
const bring_it_on = preload("res://audio-asset/bring it on.WAV")
const snowman = preload ("res://audio-asset/snowman- full.MP3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream != music:
		stream = music
		
	stop()
	seek(0)
	stream = music
	volume_db = volume
	play()
	

func _play_home_bgm():
	_play_music(home_bgm)

func _play_tut(number):
	if number == 1:
		_play_music(tut1)
	if number == 2:
		_play_music(tut2)
	if number == 3:
		_play_music(tut3)

func _song_end():
	_play_music(song_end)

func _full_combo():
	_play_music(full_combo)

func _play_level(song_selected):
	if song_selected == 0:
		_play_music(shoujo_rei)
	if song_selected == 1:
		_play_music(just_be_friends)
	if song_selected == 2:
		_play_music(the_snow_white_princess_is)
	if song_selected == 3:
		_play_music(bring_it_on)
	if song_selected == 4:
		_play_music(snowman)
		
	
