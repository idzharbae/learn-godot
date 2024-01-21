extends RigidBody2D


var ExplosionTargets: Array[CollisionObject2D] = []
var ExplosionRadius: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ExplosionRadius = $ExplosionRadius
	for overlapping_body in ExplosionRadius.get_overlapping_bodies():
		if overlapping_body.has_method("on_hit"):
			ExplosionTargets.append(overlapping_body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage_targets():
	for explosion_target in ExplosionTargets:
		explosion_target.on_hit(50, "player")

func _on_explosion_radius_body_entered(body: CollisionObject2D):
	if body == self:
		return
	
	var idx = ExplosionTargets.find(body, 0)
	if idx != -1:
		return
	
	if body.has_method("on_hit"):
		ExplosionTargets.append(body)


func _on_explosion_radius_body_exited(body: CollisionObject2D):
	var idx = ExplosionTargets.find(body, 0)
	if idx == -1:
		return
	
	ExplosionTargets.remove_at(idx)


func _on_body_entered(body):
	(self as RigidBody2D).sleeping = true
	$CollisionShape2D.disabled = true
	$ExplosionAnimation.play("explosion")
