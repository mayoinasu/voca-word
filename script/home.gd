extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"home-screen".visible = false
	$option.visible = false
	$disclaimer/AnimationPlayer.play("fade")
	await $disclaimer/AnimationPlayer.animation_finished
	AudioPlayer._play_home_bgm()
	$"home-screen".visible = true
	$"home-screen/AnimationPlayer".play("fade in")


func _on_texture_button_pressed() -> void:
	$"home-screen/AnimationPlayer".play("fade out")
	await $"home-screen/AnimationPlayer".animation_finished
	$option.visible = true
	$option/AnimationPlayer.play("fade in")
	
	
	


func _on_yes_pressed() -> void:
	$option/AnimationPlayer.play("fade out")
	await $option/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/tutoriall.tscn")


func _on_no_pressed() -> void:
	$option/AnimationPlayer.play("fade out")
	await $option/AnimationPlayer.animation_finished
	AudioPlayer.stop()
	get_tree().change_scene_to_file("res://scene/song_selection.tscn")
