extends BaseEnemy


var target: CharacterBody2D
var default_rotation: float

func _ready():
	body = $Body
	speed = 300
	hitpoints = 150
	HPBar = $HPBar
	default_rotation = rotation_degrees
	original_position = global_position

func _physics_process(delta):	
	if target:
		chase(target)
	elif position != original_position:
		backoff_from_chase($NavigationAgent2D)

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
