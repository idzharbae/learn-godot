extends BaseEnemy


var target: CharacterBody2D
var default_rotation: float
var target_near = false
var damage = 20
var animation: AnimationPlayer

func _ready():
	body_collision = $Body
	speed = 300
	HPBar = $HPBar
	init_hp(150)
	default_rotation = rotation_degrees
	original_position = global_position
	animation = $AnimationPlayer
	body_hit_sound = $BodyHitSound

func _physics_process(delta):	
	if target:
		if animation.current_animation == "attack" and animation.is_playing():
			return
		if not animation.is_playing():
			animation.play("walk")
		chase_path_find(target, $NavigationAgent2D)
	elif position.distance_to(original_position) > 10:
		if not animation.is_playing():
			animation.play("walk")
		backoff_from_chase($NavigationAgent2D)
	else:
		get_tree().create_tween().tween_property(self, "rotation_degrees", default_rotation, 0.5)
		animation.stop()

func _on_notice_area_body_entered(body):
	if body.name == "Player":
		target = body

func _on_notice_area_body_exited(body):
	if body == target:
		$NavigationAgent2D.target_position = original_position
		target = null

func _on_target_update_timeout():
	if target:
		$NavigationAgent2D.target_position = target.global_position


func _on_attack_range_body_entered(body):
	if body == target:
		target_near = true
		animation.play("attack")


func _on_attack_range_body_exited(body):
	if body == target:
		target_near = false

func check_target_still_near():
	if not target_near:
		animation.stop()

func damage_target():
	if target_near and target.has_method("on_hit"):
		target.on_hit(damage, "enemy")
