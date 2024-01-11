extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_scene(target: String) -> void:
	var animation = $AnimationPlayer as AnimationPlayer
	animation.play("fade_to_black")
	await animation.animation_finished
	animation.play_backwards("fade_to_black")
	get_tree().change_scene_to_file(target)
