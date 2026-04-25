extends Control

var RhythmButton = preload("res://scene/rhythm_button.tscn")
var my_font = preload("res://fonts/hemi_head/HemiHead-BoldItalic.otf")

var score = 0
var combo = 0
var song_time = 0.0

var time_to_next = 0.0
var time_until_next = 0.0
var next_note_preview_pos = Vector2.ZERO
var line_progress = 0.0
var preview_dot = Line2D
var last_click_pos = Vector2.ZERO

var next_index = 0
var current_btn = null
var next_btn = null
var waiting_for_click = false

const PERFECT_WINDOW = 1.00
const GOOD_WINDOW = 1.85

var highest = 0
var dot_from_pos = Vector2.ZERO


var beatmap =[]

func _ready() -> void:
	$Node2D/Label.text = SongsData.song_list[SongsData.song_selected][1]
	$AnimationPlayer.play("fade in")
	beatmap = SongsData.get_beatmap(SongsData.song_selected)
	preview_dot = Line2D.new()
	preview_dot.width = 8.0
	preview_dot.default_color =  Color(1, 1, 0, 0.9)
	add_child (preview_dot)
	
	AudioPlayer._play_level(SongsData.song_selected)
	print(SongsData.song_selected)

	update_score_ui()
	
func update_score_ui():
	$ScoreLabel.text = "Score %d pts" % score
	if combo >= 2:
		$ComboLabel.text = "Combo %dx" % combo
	else:
		$ComboLabel.text = ""

func spawn_button(index):
	var btn = RhythmButton.instantiate()
	var entry = beatmap[index]
	add_child(btn)
	btn.position = Vector2(entry[1], entry[2])
	btn.get_node("Button").text = entry[3]
	btn.spawn_time = entry[0]
	
	current_btn = btn
	
	if index + 1 < beatmap.size():
		var time_now = beatmap[index][0]
		var time_next = beatmap[index + 1][0]
		time_to_next = time_next - time_now
		time_until_next = time_to_next
		next_note_preview_pos = Vector2(beatmap[index + 1][1], beatmap[index + 1][2] +20)
	
	else:
		next_note_preview_pos = Vector2.ZERO
		line_progress = 0.0
	
	btn.missed.connect(_on_note_missed.bind(btn))
	btn.get_node("Button").pressed.connect(_on_note_clicked.bind(btn))
	
	
	
func _on_note_missed(btn):
	dot_from_pos = btn.position + btn.get_node("Button").size/2
	btn.queue_free() 
	waiting_for_click = false
	combo = 0
	update_score_ui()
	check_song_end()

func _on_note_clicked(btn):
	var time_diff = abs(song_time-btn.spawn_time)
	
	if time_diff < PERFECT_WINDOW:
		score += 300 * (1+combo / 10.0)
		combo += 1
	elif time_diff < GOOD_WINDOW:
		score += 100
		combo += 1
	else:
		score += 50
		combo += 1
		
	update_score_ui()
	
	dot_from_pos = btn.position + btn.get_node("Button").size/2
	last_click_pos = dot_from_pos
	btn.queue_free()
	waiting_for_click = false
	check_song_end()

func update_preview_line():
	preview_dot.clear_points()

	if next_note_preview_pos == Vector2.ZERO:
		return
	var from_pos = Vector2.ZERO
	if current_btn != null and is_instance_valid(current_btn):
		from_pos = current_btn.position + current_btn.get_node("Button").size/2
	elif dot_from_pos != Vector2.ZERO:
		from_pos = dot_from_pos
	else:
		return
	
	var dot_pos = from_pos.lerp(next_note_preview_pos, line_progress)
	preview_dot.add_point(dot_pos + Vector2(-4, 0))
	preview_dot.add_point(dot_pos + Vector2(4, 0))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_preview_line()
	time_until_next -= delta
	line_progress = clamp(1.0 - (time_until_next / time_to_next), 0.0, 1.0)
	
	if waiting_for_click:
		return  

	song_time += delta
	
	while next_index < beatmap.size() and song_time >= beatmap[next_index][0]:
			spawn_button(next_index)
			next_index += 1
			
	if combo >= highest:
		highest = combo

func check_song_end():
	
	if next_index >= beatmap.size():
		var tree = get_tree()
		await get_tree().create_timer(4).timeout
		if combo == SongsData.song_list[SongsData.song_selected][3]:
			$AnimationPlayer.play("full combo")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer/Label10.text = "Fantastic!"
			SongsData.full_combo_total += 1
		else:
			$AnimationPlayer.play("song end")
			await $AnimationPlayer.animation_finished
			if highest >= (SongsData.song_list[SongsData.song_selected][3])/2:
				$AnimationPlayer/Label10.text = "Well done!"
			else:
				$AnimationPlayer/Label10.text = "Good!"
		$AnimationPlayer/Label9.text = "%d x" %highest
		await get_tree().create_timer(1).timeout
		$AnimationPlayer.play("score")
		if SongsData.song_selected == 6:
			await get_tree().create_timer(2).timeout
			$AnimationPlayer.play("fade out")
			await $AnimationPlayer.animation_finished
			await get_tree().create_timer(2).timeout
			tree.change_scene_to_file("res://scene/song_selection.tscn")
		if SongsData.song_selected == 8:
			await get_tree().create_timer(2).timeout
			$AnimationPlayer.play("fade out")
			await $AnimationPlayer.animation_finished
			await get_tree().create_timer(2).timeout
			tree.change_scene_to_file("res://scene/song_selection.tscn")
		if SongsData.song_selected == 9:
			await get_tree().create_timer(2).timeout
			$AnimationPlayer.play("fade out")
			await $AnimationPlayer.animation_finished
			await get_tree().create_timer(2).timeout
			tree.change_scene_to_file("res://scene/song_selection.tscn")
		await $AnimationPlayer.animation_finished
		await AudioPlayer.finished
		$AnimationPlayer.play("fade out")
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(2).timeout
		tree.change_scene_to_file("res://scene/song_selection.tscn")
