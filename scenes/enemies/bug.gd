extends BaseEnemy

var target: CharacterBody2D
var player_near = false
var animated_body: AnimatedSprite2D

func _ready():
	original_position = global_position
	animated_body = $Body/AnimatedSprite2D
	body_image = animated_body
	body_collision = $Body
	var direction = Vector2.ZERO
	velocity = Vector2.ZERO
	HPBar = $HPBar
	init_hp(50)
	speed = 150

func _physics_process(_delta):
	if target:
		if animated_body.animation == "attack" and animated_body.is_playing():
			return
		if not animated_body.is_playing():
			animated_body.play("walk")
		chase_path_find(target, $NavigationAgent2D)
	elif position.distance_to(original_position) > 10:
		if not animated_body.is_playing():
			animated_body.play("walk")
		backoff_from_chase($NavigationAgent2D)
	else:
		get_tree().create_tween().tween_property($".", "rotation_degrees", 0, 0.5)
		animated_body.stop()

func on_hit(damage: int, source: String):
	if source != "player":
		return
	
	var tween = get_tree().create_tween()
	hitpoints -= damage
	HPBar.value = hitpoints
	if hitpoints < 1:
		hitpoints = 0
		animated_body.modulate = Color(3,3,3,1)
		tween.set_loops(4)
		tween.tween_property(animated_body, "modulate:a", 0.33, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(animated_body, "modulate:a", 1, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_callback(blocking_bleed)
		tween.tween_callback(queue_free)
	else:
		$Particles/HitParticles.emitting = true

func blocking_bleed():
	var timer = get_tree().create_timer(0.5)
	$Particles/HitParticles.emitting = true
	await timer.timeout

func _on_sight_body_entered(body):
	target = body

func _on_sight_body_exited(body):
	if body as CharacterBody2D == target:
		$NavigationAgent2D.target_position = original_position
		target = null



func _on_attack_range_body_entered(body):
	if not player_near:
		player_near = true
		animated_body.play("attack")


func _on_attack_range_body_exited(body):
	player_near = false


func _on_animated_sprite_2d_animation_finished():
	if player_near:
		Globals.player_hp -= 10
		$Timers/AttackTimer.start()

func _on_attack_timer_timeout():
	if player_near:
		animated_body.play("attack")


func _on_target_path_finding_update_timeout():
	if target:
		$NavigationAgent2D.target_position = target.global_position
