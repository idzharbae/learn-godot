extends CharacterBody2D


const speed = 300.0
var target: CharacterBody2D
var default_rotation: float
var original_position: Vector2

func _ready():
	default_rotation = rotation_degrees
	original_position = global_position

func _physics_process(delta):	
	if target:
		look_at(target.global_position)
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position) .normalized()
		velocity = direction * speed
		move_and_slide()
	elif position != original_position:
		look_at(original_position)
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position) .normalized()
		velocity = direction * speed
		move_and_slide()

func _on_notice_area_body_entered(body):
	if body.name == "Player":
		target = body
		$AnimationPlayer.play("walk")


func _on_notice_area_body_exited(body):
	if body == target:
		$NavigationAgent2D.target_position = original_position
		target = null
		$AnimationPlayer.stop()
		get_tree().create_tween().tween_property(self, "rotation_degrees", default_rotation, 0.5)


func _on_target_update_timeout():
	if target:
		$NavigationAgent2D.target_position = target.global_position
