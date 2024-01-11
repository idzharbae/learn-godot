extends CharacterBody2D

var hitpoints: int
var direction: Vector2
var target: CharacterBody2D
var HPBar: TextureProgressBar
var player_near = false

func _ready():
	hitpoints = 25
	var direction = Vector2.ZERO
	velocity = Vector2.ZERO
	HPBar = $BugHP
	HPBar.max_value = hitpoints
	HPBar.value = hitpoints

func _process(delta):
	if player_near:
		return
	
	if target:
		direction = (target.position - position).normalized()
		look_at(target.position)
		if not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("walk")
	
	velocity = direction * 200
	move_and_slide()

func on_hit(damage: int, source: String):
	if source != "player":
		return
	
	var tween = get_tree().create_tween()
	hitpoints -= damage
	HPBar.value = hitpoints
	if hitpoints < 1:
		hitpoints = 0
		$AnimatedSprite2D.modulate = Color(3,3,3,1)
		tween.set_loops(4)
		tween.tween_property($AnimatedSprite2D, "modulate:a", 0.33, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property($AnimatedSprite2D, "modulate:a", 1, 0.25).set_trans(Tween.TRANS_BOUNCE)
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
		$AnimatedSprite2D.stop()
		target = null
		direction = Vector2.ZERO
		get_tree().create_tween().tween_property($".", "rotation_degrees", 0, 0.5)


func _on_attack_range_body_entered(body):
	if not player_near:
		player_near = true
		$AnimatedSprite2D.play("attack")


func _on_attack_range_body_exited(body):
	player_near = false


func _on_animated_sprite_2d_animation_finished():
	if player_near:
		Globals.player_hp -= 10
		$Timers/AttackTimer.start()

func _on_attack_timer_timeout():
	if player_near:
		$AnimatedSprite2D.play("attack")
