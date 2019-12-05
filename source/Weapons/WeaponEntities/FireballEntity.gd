extends Node2D

const MOVE_SPEED = 8 * 16

onready var particles = $Particles2D
onready var damage_area = $DamageArea
onready var obstacle_detector = $ObstacleDetector

var velocity = Vector2.ZERO
var is_launched = false

func _ready():
	set_physics_process(false)

func can_launch() -> bool:
	return obstacle_detector.get_overlapping_bodies().size() == 0

func launch(angle):
	if !is_launched:
		velocity = Vector2.RIGHT.rotated(angle) * MOVE_SPEED
		is_launched = true
		set_physics_process(true)
		damage_area.monitoring = true
	

func _physics_process(delta):
	position += velocity * delta

func explode():
	queue_free()

func _on_DamageArea_entity_damaged(entity):
	explode()

func _on_ObstacleDetector_body_exited(body):
	if is_launched:
		explode()
