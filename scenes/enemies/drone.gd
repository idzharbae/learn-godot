extends BaseEnemy

var target: CharacterBody2D
var ExplosionTargets: Array[CollisionObject2D] = []
var isExploding = false
var explosion_damage = 25

func _ready():
	var direction = Vector2.ZERO
	velocity = Vector2.ZERO
	HPBar = $HPBar
	init_hp(100)
	body_collision = $Body
	body_image = $Body/Sprite2D
	speed = 150

func _process(delta):
	if isExploding:
		return
	
	if target:
		chase(target)

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
		$Body/Sprite2D.visible = false
		$Body.disabled = true
		$AnimationPlayer.play("explode")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()
