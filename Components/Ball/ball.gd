extends CharacterBody2D

class_name Ball

signal life_lost

const VELOCITY_LIMIT = 40

var speed_up_factor = 1.05
var start_position: Vector2

@export var ball_speed = 20
@export var lifes = 3
@export var death_zone :DeathZone
@export var ui:UI

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	ui.set_lifes(lifes)
	start_position = position
	death_zone.life_lost.connect(on_life_lost)

func start_ball():
	position = start_position
	randomize()
	velocity = Vector2(randf_range(-1, 1), randf_range(-.1, -1)).normalized() * ball_speed

func reset_ball():
	position = start_position
	velocity = Vector2.ZERO

func _physics_process(delta):
	var collision = move_and_collide(velocity * ball_speed * delta)
	if collision :
		velocity = velocity.bounce(collision.get_normal())
		var collider = collision.get_collider()

		if collider is Brick:
			collider.decrease_level()



func on_life_lost():
	lifes -= 1
	if lifes == 0:
		ui.game_over()
	else:
		life_lost.emit()
		ui.set_lifes(lifes)
		reset_ball()
