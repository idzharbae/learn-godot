extends CharacterBody2D


var laser_scene: PackedScene = preload("res://scenes/player/laser.tscn")
var grenade_scene: PackedScene = preload("res://scenes/player/grenade.tscn")
var laser_particles_scene: PackedScene = preload("res://scenes/player/laser_particles.tscn")

@export var base_speed = 300.0
var speed: float = base_speed
var direction: Vector2
var laser_is_coolingdown = false
var grenade_is_coolingdown = false
var laser_cooldown_timer: Timer
var grenade_cooldown_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	laser_cooldown_timer = $LaserCooldown
	grenade_cooldown_timer = $GrenadeCooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Movement.movement_only(speed)
	move_and_slide()
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	
	if Input.is_action_pressed("primary action") and not laser_is_coolingdown and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		#if Globals.laser_amount == 0:
			#Globals.laser_amount = Globals.max_laser_amount
		
		laser_is_coolingdown = true
		laser_cooldown_timer.start()
		
		var laserParticles = $LaserPosition/GPUParticles2D as GPUParticles2D
		laserParticles.emitting = true
		laserParticles.restart()
		var laser = laser_scene.instantiate() as Area2D
		$"..".add_child(laser)
		laser.position = $LaserPosition.global_position
		laser.rotation_degrees = rotation_degrees + randi_range(-75, 75) / 10.0
		$".."/InGameUI.update_laser_count()
		
	
	if Input.is_action_just_pressed("secondary action") and not grenade_is_coolingdown and Globals.grenade_amount > 0:
		grenade_is_coolingdown = true
		grenade_cooldown_timer.start()
		Globals.grenade_amount -= 1
		#if Globals.grenade_amount == 0:
			#Globals.grenade_amount = Globals.max_grenade_amount
		
		var grenade = grenade_scene.instantiate() as RigidBody2D
		$"..".add_child(grenade)
		grenade.position = $LaserPosition.global_position
		var player_direction = (get_global_mouse_position() - position).normalized()
		grenade.linear_velocity = 600 * player_direction
		$".."/InGameUI.update_grenade_count()


func _on_laser_cooldown_timeout():
	laser_is_coolingdown = false

func _on_grenade_cooldown_timeout():
	grenade_is_coolingdown = false

func on_hit(damage: int, source: String):
	if source == "enemy":
		Globals.player_hp -= damage
