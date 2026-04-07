extends Node2D

var number = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_close_all()
	_song(0)
	


func _song(number):
	if number == 0:
		$"shoujo-rei".visible = true
		$"shoujo-rei/AudioStreamPlayer2D".play()
	if number == 1:
		$"just-be-friend".visible = true
		$"just-be-friend/AudioStreamPlayer2D".play()



func _close_all():
	$"shoujo-rei".visible = false
	$"shoujo-rei/AudioStreamPlayer2D".stop()
	$"just-be-friend".visible = false
	$"just-be-friend/AudioStreamPlayer2D".stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_right_pressed() -> void:
	number +=1
	_close_all()
	_song(number)
	

func _on_left_pressed() -> void:
	number -=1
	_close_all()
	_song(number)


func _on_select_pressed() -> void:
	if number == 0:
		SongsData.song_selected = 0
		get_tree().change_scene_to_file("res://scene/player_map.tscn")
