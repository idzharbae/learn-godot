extends Object

class_name Movement

static func directional_movement(speed: float, rotation_degrees: float) -> Dictionary:
	var direction: Vector2
	var velocity: Vector2
	
	direction = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO:
		return {
			"rotation_degrees": rotation_degrees,
			"velocity": Vector2.ZERO,
		}
	
	rotation_degrees = (180 / PI) * atan2(direction.x, -direction.y)
	velocity = direction * speed
	
	return {
		"rotation_degrees": rotation_degrees,
		"velocity": velocity,
	}

static func movement_only(speed: float) -> Vector2:
	var direction: Vector2
	
	direction = Input.get_vector("left", "right", "up", "down")
	return direction * speed
