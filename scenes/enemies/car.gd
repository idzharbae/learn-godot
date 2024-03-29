extends BaseEnemy

var target: CharacterBody2D
@onready var line1 = $Body/Turret/RayCast2D/Line2D
@onready var line2 = $Body/Turret/RayCast2D2/Line2D
var damage = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	HPBar = $HPBar
	init_hp(200)
	body_image = $Body
	body_collision = $Body
	line1.add_point($Body/Turret/RayCast2D.target_position)
	line2.add_point($Body/Turret/RayCast2D2.target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		$Body/Turret.look_at(target.global_position)

func _on_shoot_range_body_entered(body):
	if body.name == "Player":
		target = body
		$AnimationPlayer.play("LaserBeam")

func _on_shoot_range_body_exited(body):
	if body == target:
		target = null
		get_tree().create_tween().tween_property($Turret, "rotation_degrees", 0, 0.5)

func damage_target():
	if target:
		$Body/Turret/TurretImage/Gunfire1/PointLight2D.visible = true
		$Body/Turret/TurretImage/Gunfire2/PointLight2D.visible = true
		
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property($Body/Turret/TurretImage/Gunfire1, "modulate:a", 0, 0.5).from(1)
		tween.tween_property($Body/Turret/TurretImage/Gunfire2, "modulate:a", 0, 0.5).from(1)
		tween.tween_property($Body/Turret/TurretImage/Gunfire1/PointLight2D, "energy", 0, 0.5).from(2)
		tween.tween_property($Body/Turret/TurretImage/Gunfire2/PointLight2D, "energy", 0, 0.5).from(2)
		
		target.on_hit(damage, "enemy")

