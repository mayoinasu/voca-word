# main.gd
extends Control

var RhythmButton = preload("res://scene/rhythm_button.tscn")
var my_font = preload("res://fonts/hemi_head/HemiHead-BoldItalic.otf")

var tutor_map = [
	[17.5,  220, 220, "Miku"],
	[18.0,  500, 200, "Miku"]
]

var beatmap = [
	[12.5,  200, 200, "I'm thinking"],
	[13.0,  400, 300, "Miku"],
	[13.9,  600, 200, "Miku"],
	[15.0,  300, 300, "oo"],
	[15.5,  400, 300, "ee"],
	[16.0,  500, 300, "oo"],
	[16.5,  650, 200, "I'm thinking"],
	[17.1,  600, 300, "Miku"],
	[17.8,  450, 200, "Miku"],
	[19.0,  350, 350, "oo"],
	[19.4,  450, 350, "ee"],
	[19.8,  550, 350, "oo"],
	[20.05,  200, 200, "I'm thinking"],
	[20.85,  450, 300, "Miku"],
	[21.65,  650, 200, "Miku"],
	[22.6,  300, 300, "oo"],
	[23.1,  400, 300, "ee"],
	[23.5,  500, 300, "oo"],
	[24.05,  650, 200, "I'm thinking"],
	[24.65,  600, 300, "Miku"],
	[25.3,  450, 200, "Miku"],
	[26.3,  350, 300, "oo"],
	[26.7,  450, 300, "ee"],
	[27.2,  550, 300, "oo"],
	[28.2,  350, 200, "I'm on"],
	[29.2,  350, 300, "top of"],
	[29.8,  350, 400, "the world"],
	[30.2,  550, 300, "Because"],
	[30.65,  650, 350, "of"],
	[30.8,  750, 350, "You"],
	[32.1,  350, 400, "All I"],
	[32.9,  450, 400, "wanted"],
	[33.4,  650, 400, "to do"],
	[34.3,  400, 500, "is follow you"],
	[35.7,  300, 200, "I'll keep"],
	[36.6,  500, 200, "singing along"],
	[38.0,  350, 270, "to all"],
	[38.8,  500, 270, "of you"],
	[39.5,  350, 400, "I'll keep"],
	[40.3,  400, 500, "singing along"],
	[42.6,  200, 200, "I'm thinking"],
	[43.3,  400, 300, "Miku"],
	[44.1,  600, 200, "Miku"],
	[45.1,  300, 300, "oo"],
	[45.6,  400, 300, "ee"],
	[46.1,  500, 300, "oo"],
	[46.4,  650, 200, "I'm thinking"],
	[47.2,  600, 300, "Miku"],
	[47.9,  450, 200, "Miku"],
	[48.9,  350, 350, "oo"],
	[49.3,  450, 350, "ee"],
	[49.7,  550, 350, "oo"],
	[50.1,  200, 200, "I'm thinking"],
	[50.8 ,  450, 300, "Miku"],
	[51.65,  650, 200, "Miku"],
	[52.6,  300, 300, "oo"],
	[53.1,  400, 300, "ee"],
	[53.5,  500, 300, "oo"],
	[53.8,  650, 200, "I'm thinking"],
	[54.5,  600, 300, "Miku"],
	[55.3,  450, 200, "Miku"],
	[56.4,  350, 300, "oo"],
	[56.8,  450, 300, "ee"],
	[57.3,  550, 300, "oo"]
]

var song_time = 0.0
var next_index = 0

var tut_done = false
var waiting_for_click = false 
var last_click_pos = Vector2.ZERO 

var current_btn = null
var next_btn = null

var line_progress = 0.0
var next_note_preview_pos = Vector2.ZERO
var time_until_next = 0.0
var time_to_next = 0.0
var preview_dot: Line2D

var score = 0
var combo = 0

const PERFECT_WINDOW = 1.00
const GOOD_WINDOW = 1.85

func _ready():
	preview_dot = Line2D.new()
	preview_dot.width = 8.0
	preview_dot.default_color = Color(1, 1, 0, 0.9)  
	add_child(preview_dot) 
	
	$background/commentary/AnimationPlayer/Label2.visible = false
	$background/commentary/AnimationPlayer2/Label3.visible = false
	$AnimationPlayer.play("fade in")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("tutorial1")
	
	AudioPlayer._play_tut(1)
	if not tut_done:
		if next_index == 0:
			await get_tree().create_timer(17.2).timeout
			$background/commentary/AnimationPlayer/Label2.visible = true
			$background/commentary/AnimationPlayer.play("tut1")
	
	var score_label = Label.new()
	score_label.name = "ScoreLabel"
	score_label.position = Vector2(890,90)
	score_label.add_theme_font_size_override("font_size", 28)
	score_label.add_theme_font_override("font", my_font)
	add_child(score_label)
	
	var combo_label = Label.new()
	combo_label.name = "ComboLabel"
	combo_label.position = Vector2(890,120)
	combo_label.add_theme_font_size_override("font_size",22)
	combo_label.add_theme_font_override("font", my_font)
	add_child(combo_label)
	
	update_score_ui()
	
	
		
	
func update_score_ui():
	$ScoreLabel.text = "Score:%d pts" % score
	if combo >= 2:
		$ComboLabel.text = "Combo: %dx" % combo
	else:
		$ComboLabel.text = ""
	

func _process(delta):
	update_preview_line()

	if tut_done and next_index < beatmap.size():
		time_until_next -= delta
		line_progress = clamp(1.0 - (time_until_next / time_to_next), 0.0, 1.0)

	if waiting_for_click:
		return  

	song_time += delta

	if not tut_done:
		while next_index < tutor_map.size() and song_time >= tutor_map[next_index][0]:
			spawn_button(next_index, false)
			next_index += 1
			
			waiting_for_click = true 
			return 
	else:
		while next_index < beatmap.size() and song_time >= beatmap[next_index][0]:
			spawn_button(next_index, true)
			next_index += 1

func update_preview_line():
	preview_dot.clear_points()

	if not tut_done:
		return

	if current_btn == null or not is_instance_valid(current_btn):
		return

	if next_note_preview_pos == Vector2.ZERO:
		return

	var from_pos = current_btn.position + current_btn.get_node("Button").size / 2
	var dot_pos = from_pos.lerp(next_note_preview_pos, line_progress)
	preview_dot.add_point(dot_pos + Vector2(-4, 0))
	preview_dot.add_point(dot_pos + Vector2(4, 0))

func spawn_button(index, is_main):
	var entry = beatmap[index] if is_main else tutor_map[index]
	var btn = RhythmButton.instantiate()
	add_child(btn)
	btn.position = Vector2(entry[1], entry[2])
	btn.get_node("Button").text = entry[3]
	btn.is_tutorial = not is_main
	btn.spawn_time = entry[0]

	# Current note is the one just spawned
	current_btn = btn

	# Preview points to the NEXT note after this one
	if is_main and index + 1 < beatmap.size():
		var time_now = beatmap[index][0]
		var time_next = beatmap[index + 1][0]
		time_to_next = time_next - time_now
		time_until_next = time_to_next
		next_note_preview_pos = Vector2(beatmap[index + 1][1], beatmap[index + 1][2] +20)
	else:
		# No next note, clear the preview
		next_note_preview_pos = Vector2.ZERO
		line_progress = 0.0

	btn.missed.connect(_on_note_missed.bind(btn, is_main))
	btn.get_node("Button").pressed.connect(_on_tut_note_clicked.bind(btn, is_main))
	
func _on_note_missed(btn, is_main):
	waiting_for_click = false
	if is_main:
		combo = 0
		update_score_ui()
		check_song_end()

func _on_tut_note_clicked(btn, is_main):
	if is_main:
		var time_diff = abs(song_time - btn.spawn_time)

		if time_diff <= PERFECT_WINDOW:
			score += 300 * (1 + combo / 10.0)  # Combo slightly boosts perfect score
			combo += 1
		elif time_diff <= GOOD_WINDOW:
			score += 100
			combo += 1
		else:
			score += 50
			combo += 1

		
		update_score_ui()
		check_song_end()

	last_click_pos = btn.position + btn.get_node("Button").size / 2
	btn.queue_free()
	waiting_for_click = false
	
		
	if not is_main:
		if next_index >= tutor_map.size():
			$background/commentary/AnimationPlayer2/Label3.visible = false
			$background/commentary/AnimationPlayer2.play("fade out")
			tut_done = true
			next_index = 0
			song_time = 0.0
			AudioPlayer._play_tut(3) 
			$AnimationPlayer.play("tutorial2")
			
		else:
			if next_index == 1:
				$background/commentary/AnimationPlayer/Label2.visible = false
				$background/commentary/AnimationPlayer.play("fade out")
				
				$background/commentary/AnimationPlayer2/Label3.visible = true
				$background/commentary/AnimationPlayer2.play("tut2")
			AudioPlayer._play_tut(next_index + 1)
			
func check_song_end():
	if next_index >= beatmap.size():
		await get_tree().create_timer(1.5).timeout
		if combo == 64:
			$AnimationPlayer.play("full_combo")
			AudioPlayer._full_combo()
		else:
			$AnimationPlayer.play("song_clear")
			AudioPlayer._song_end()
		
		await get_tree().create_timer(2).timeout
		$AnimationPlayer.play("fade out")
		await get_tree().create_timer(6).timeout
		AudioPlayer._play_home_bgm()
		get_tree().change_scene_to_file("res://scene/song_selection.tscn")
		
		
		
		
		
