extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var movementEnabled = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_state

enum state {
	idle,
	walk,
	run,
	crouch,
	attack,
	jump,
	falling
}

func _ready():
	current_state = state.idle

func _physics_process(delta):	
	
	if movementEnabled:
		var direction = Input.get_axis("A", "D")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if direction > 0:
			animated_sprite.flip_h = false
			
		elif direction < 0:
			animated_sprite.flip_h = true
		
		match current_state:
			state.idle:
				animation_player.play("Idle")
				if direction:
					current_state = state.run
				elif velocity.y < 0:
					current_state = state.jump
				elif velocity.y > 0:
					current_state = state.falling
			
			state.walk:
				animation_player.play("Walk")
					
			state.run:
				animation_player.play("Run")
				if not direction:
					current_state = state.idle
				
			state.attack:
				animation_player.play("Attack")
				
			state.crouch:
				animation_player.play("Crouch")
				
			state.jump:
				animation_player.play("Jump")
				
				if velocity.y > 0:
					current_state = state.falling
					
			state.falling:
				animation_player.play("Falling")
			
				if is_on_floor():
					current_state = state.idle
	
				
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	

	move_and_slide()
	
func bounce():
	velocity.y = JUMP_VELOCITY* 0.7
	
func ouch(enemypos):
	Global.lose_life()
	set_modulate(Color(1,0.3,0.3,0.3))
	
	movementEnabled = false
	
	velocity.y = JUMP_VELOCITY * 0.5	
	
	
	if enemypos:
		velocity.x = 100
	elif !enemypos:
		velocity.x = -100
		
		
	await get_tree().create_timer(1.0).timeout 
	movementEnabled = true
	set_modulate(Color(1,1,1,1))
	
	
	


func _on_fall_zone_body_entered(body):
	Global.lose_life()
	body.position.x = Global.respawn1.position.x
	body.position.y = Global.respawn1.position.y
	


func _on_fall_zone_2_body_entered(body):
	Global.lose_life()
	body.position.x = Global.respawn1.position.x
	body.position.y = Global.respawn1.position.y
