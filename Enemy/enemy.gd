extends CharacterBody2D

@export var direction = -1;

@onready var animation_player = $AnimationPlayer

var speed = 50

var squashed = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if direction == 1:
		$AnimatedSprite2D.flip_h = true;
	$FloorChecker.position.x = $CollisionShape2D.shape.size.x * direction
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	if is_on_wall() or not $FloorChecker.is_colliding() and is_on_floor():
		direction = direction * -1
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h;
		$FloorChecker.position.x = $CollisionShape2D.shape.size.x * direction
		
	if squashed == false:
		animation_player.play("walk")
	
	velocity.y += gravity
	
	velocity.x = speed * direction
		
	move_and_slide()


func _on_top_checker_body_entered(body):
	squashed = true;
	$AnimatedSprite2D.play("squash")
	speed = 0
	set_collision_layer_value(3, false)
	set_collision_layer_value(2, false)
	set_collision_mask_value(2, false)
	$TopChecker.set_collision_layer_value(3,false)
	$TopChecker.set_collision_layer_value(2,false)
	
	$TopChecker.set_collision_mask_value(2,false)
	
	$SidesChecker.set_collision_layer_value(3, false)
	$SidesChecker.set_collision_layer_value(2, false)
	
	$SidesChecker.set_collision_mask_value(2, false)
	$Timer.start(1)
	body.bounce()

func _on_sides_checker_body_entered(body):
	body.ouch(false)

func _on_timer_timeout():
	queue_free()


func _on_sides_checker_2_body_entered(body):
	body.ouch(true)
