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

var beatmap = [
	[14.5, 200, 350, "honnou ga"],
	[15.7, 400, 200, "kurui"],
	[16.4, 600, 300, "hajimeru"],
	[17.7, 300, 250, "oitsumerareta"],
	[19.2, 500, 400, "hatsukanezumi"],
	[20.7, 200, 200, "ima,"],
	[21.3, 350, 300, "zetsubou"],
	[22.3, 500, 190, "no fuchi"],
	[22.9, 220, 400, "ni tatte"],
	[24.2, 400, 290, "fumikiri"],
	[25.0, 200, 300, "e to"],
	[25.8, 500, 200, "tobidashita"],
	[27.2, 300, 400, "sou,"],
	[28.0, 170, 200, "kimi wa"],
	[28.8, 350, 450, "tomodachi"],
	[30.4, 200, 500, "boku no"],
	[31.4, 350, 200, "te wo"],
	[32.2, 500, 400, "tsukame yo"],
	[33.8, 180, 230, "sou,"],
	[34.4, 250, 400, "kimi wa"],
	[35.2, 360, 200, "hitori sa"],
	[36.7, 600, 300, "ibasho"],
	[37.7, 500, 400, "nante"],
	[38.5, 700, 200, "nai"],
	[38.95, 600, 500, "daro"],
	[40.2, 200, 300, "futarikiri"],
	[41.4, 500, 200, "kono"],
	[42.1, 600, 400, "mama"],
	[43.5, 350, 150, "aishiaeru"],
	[44.7, 600, 200, "saa"],
	[47.0, 450, 300, "kurikaesu"],
	[48.2, 700, 400, "furasshu"],
	[49.1, 500, 200, "bakku semi"],
	[49.9, 400, 500, "no koe"],
	[51.0, 600, 350, "nidoto wa"],
	[52.2, 300, 300, "kaeranu"],
	[53.6, 450, 510, "kimi"],
	[54.7, 200, 400, "towa ni"],
	[55.8, 420, 180, "chigireteku"],
	[57.6, 300, 300, "osoroi no"],
	[59.4, 500, 330, "kiihorudaa"],
	[60.9, 650, 500, "natsu ga"],
	[62.2, 400, 280, "keshisatta"],
	[63.7, 200, 330, "shiroi"],
	[64.6, 360, 500, "hada no"],
	[65.8, 500, 190, "shoujo ni"],
	[67.2, 300, 300, "kanashii"],
	[68.2, 400, 460, "hodo"],
	[68.8, 600, 200, "toritsukarete"],
	[70.3, 200, 400, "shimaitai"],
	[74.3, 450, 300, "kurikaesu"],
	[75.6, 700, 400, "furasshu"],
	[76.6, 500, 200, "bakku semi"],
	[77.4, 400, 500, "no koe"],
	[78.6, 600, 350, "nidoto wa"],
	[79.8, 300, 300, "kaeranu"],
	[81.2, 450, 510, "kimi"],
	[82.3, 200, 400, "towa ni"],
	[83.4, 420, 180, "chigireteku"],
	[85.2, 300, 300, "osoroi no"],
	[87.0, 500, 330, "kiihorudaa"],
	[88.8, 650, 500, "natsu ga"],
	[89.8, 400, 280, "keshisatta"],
	[91.3, 200, 330, "shiroi"],
	[92.2, 360, 500, "hada no"],
	[93.3, 500, 190, "shoujo ni"],
	[94.8, 300, 300, "kanashii"],
	[95.6, 400, 460, "hodo"],
	[96.5, 600, 200, "toritsukarete"],
	[97.9, 200, 400, "shimaitai"],
	[101.1, 300, 500, "toumeina"],
	[102.8, 600, 200, "kimi wa"],
	[103.8, 400, 400, "boku wo"],
	[104.5, 500, 190, "yubi"],
	[106.2, 300, 500, "sashitetaa"]
]


func _ready() -> void:
	preview_dot = Line2D.new()
	preview_dot.width = 8.0
	preview_dot.default_color =  Color(1, 1, 0, 0.9)
	add_child (preview_dot)
	
	AudioPlayer._play_shoujo_rei()

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
	
	last_click_pos = btn.position + btn.get_node("Button").size / 2
	btn.queue_free()
	waiting_for_click = false
	check_song_end()

func update_preview_line():
	preview_dot.clear_points()

	if current_btn == null or not is_instance_valid(current_btn):
		return

	if next_note_preview_pos == Vector2.ZERO:
		return

	var from_pos = current_btn.position + current_btn.get_node("Button").size / 2
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

func check_song_end():
	if next_index >= beatmap.size():
		await get_tree().create_timer(4).timeout
		if combo == 75:
			$AnimationPlayer.play("full_combo")
		else:
			$AnimationPlayer.play("song_clear")
