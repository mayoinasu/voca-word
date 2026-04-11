
extends Control

signal button_hit

var texts = [""]
var time_left = 2.0
signal missed

var is_tutorial = false

var spawn_time = 0.0

func _ready():
	$Button.pressed.connect(_on_pressed)
	$Button.text = texts[randi() % texts.size()]
	animate_in()

func animate_in():
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)

func _on_pressed():
	button_hit.emit()
	queue_free()

func _process(delta):
	if is_tutorial:
		return
	
	time_left -= delta
	modulate.a = clamp(time_left / 1.0, 0.0, 1.0) 
	if time_left <= 0:
		emit_signal("missed")
		queue_free()
