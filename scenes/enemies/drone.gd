extends CharacterBody2D

var hitpoints: int
var direction: Vector2
var target: CharacterBody2D
var HPBar: TextureProgressBar
var ExplosionTargets: Array[CollisionObject2D] = []
var isExploding = false
var explosion_damage = 25

func _ready():
	hitpoints = 100
	var direction = Vector2.ZERO
	velocity = Vector2.ZERO
	HPBar = $HPBar
	HPBar.max_value = hitpoints
	HPBar.value = hitpoints

func _process(delta):
	if isExploding:
		return
	
	if target:
		direction = (target.position - position).normalized()
		look_at(target.position)
	
	velocity = direction * 200
	move_and_slide()

func on_hit(damage: int, source: String):
	if source != "player" or isExploding:
		return
	
	var tween = get_tree().create_tween()
	hitpoints -= damage
	HPBar.value = hitpoints
	if hitpoints < 1:
		hitpoints = 0
		$Sprite2D.modulate = Color(3,3,3,1)
		tween.set_loops(4)
		tween.tween_property($Sprite2D, "modulate:a", 0.33, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property($Sprite2D, "modulate:a", 1, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_callback(queue_free)
	else:
		tween.tween_property($Sprite2D, "modulate", Color(3,3,3,1), 0.1)
		tween.tween_property($Sprite2D, "modulate", Color(1,1,1,1), 0.1)



func _on_detection_body_entered(body):
	target = body

func _on_detection_body_exited(body):
	if body as CharacterBody2D == target:
		target = null
		direction = Vector2.ZERO
		get_tree().create_tween().tween_property($".", "rotation_degrees", 0, 0.5)


func _on_explosion_radius_body_entered(body: CollisionObject2D):
	if body == self:
		return
	
	if body.has_method("on_hit"):
		ExplosionTargets.append(body)


func _on_explosion_radius_body_exited(body):
	var idx = ExplosionTargets.find(body, 0)
	if idx == -1:
		return
	
	ExplosionTargets.remove_at(idx)


func _on_explosion_trigger_radius_body_entered(body: CollisionObject2D):
	if body.is_in_group("player_and_allies") and not isExploding:
		for explosion_target in ExplosionTargets:
			explosion_target.on_hit(explosion_damage, "enemy")
		isExploding = true
		$Explosion.visible = true
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		$AnimationPlayer.play("explode")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()
