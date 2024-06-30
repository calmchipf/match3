extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if $CanvasLayer/MarginContainer/AnimationPlayer:
		$CanvasLayer/MarginContainer/AnimationPlayer.play("levels_bg")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	pass # Replace with function body.
