extends Node3D

signal dice_rolled(dice1_result: int, dice2_result: int)
signal back_to_drink_selection

@export var dice_template: PackedScene
@export var dice_audio: AudioStream

@onready var dice1: RigidBody3D = $dice1
@onready var dice2: RigidBody3D = $dice2


func _ready():
	_generate_dices()
	
#	# Add a random angular velocity to the dice
#	var angular_velocity = Vector3(
#		randf_range(-1, 10),
#		randf_range(-1, 10),
#		randf_range(-1, 10)
#	)
#	dice1.angular_velocity = angular_velocity
#	
#	var angular_velocity2 = Vector3(
#		randf_range(-1, 10),
#		randf_range(-1, 10),
#		randf_range(-1, 10)
#	)
#	
#	dice2.angular_velocity = angular_velocity2

	# Get top face of the dice when dice are still
	await get_tree().create_timer(0.2).timeout
	while is_body_still(dice1) == false or is_body_still(dice2) == false:
		print("Waiting for dice to settle...")
		await get_tree().create_timer(0.2).timeout
	
	var top_face1 = get_top_face(dice1)
	var top_face2 = get_top_face(dice2)
	print("Top face of Dice 1: ", top_face1)
	print("Top face of Dice 2: ", top_face2)

	dice_rolled.emit(top_face1, top_face2)

	
#func _process(delta: float) -> void:
#	# Print the velocity of the dice
#	if dice1 and dice2:
#		print("Dice 1 Velocity: ", dice1.linear_velocity.length())
#		print("Dice 2 Velocity: ", dice2.linear_velocity)
#		
#		# Check if the dice are still
#		if is_body_still(dice1) and is_body_still(dice2):
#			print("Both dice are still.")
#			var top_face1 = get_top_face(dice1)
#			var top_face2 = get_top_face(dice2)
#			print("Top face of Dice 1: ", top_face1)
#			print("Top face of Dice 2: ", top_face2)
#			# Optionally, you can stop the process or do something else here
#			return
#	else:
#		print("Dice not found.")


func _generate_dices():
	# Clear existing dice
	if dice1:
		dice1.queue_free()
	if dice2:
		dice2.queue_free()
	
	# Instantiate new dice
	dice1 = dice_template.instantiate()
	dice2 = dice_template.instantiate()
	
	dice1.name = "Dice1"
	dice2.name = "Dice2"
	
	dice1.body_entered.connect(_on_dice_body_entered)
	dice2.body_entered.connect(_on_dice_body_entered)
	
	# Add them to the scene
	add_child(dice1)
	add_child(dice2)
	
	# Set their positions
	dice1.global_transform.origin = Vector3(0, 0.175, randf_range(0.05, 0.07))
	dice2.global_transform.origin = Vector3(0, 0.175, randf_range(-0.05, -0.07))
	
	# Set random rotations
	dice1.rotation = Vector3(
		randf_range(0, PI * 2),
		randf_range(0, PI * 2),
		randf_range(0, PI * 2)
	)
	dice2.rotation = Vector3(
		randf_range(0, PI * 2),
		randf_range(0, PI * 2),
		randf_range(0, PI * 2)
	)
	
	# Apply random angular velocities
	var angular_velocity: Vector3 = Vector3(
		randf_range(-1, 10),
		randf_range(-1, 10),
		randf_range(-1, 10)
	)
	dice1.angular_velocity = angular_velocity
	
	var angular_velocity2: Vector3 = Vector3(
		randf_range(-1, 10),
		randf_range(-1, 10),
		randf_range(-1, 10)
	)
	dice2.angular_velocity = angular_velocity2

	# Apply an random initial impulse to the dice
	var initial_impulse: Vector3 = Vector3(
	  randf_range(-1, 1),
	  randf_range(0, 0),  # Upward impulse
	  randf_range(-1, 1)
	)

	dice1.apply_impulse(initial_impulse)

	var initial_impulse2: Vector3 = Vector3(
	   randf_range(-1, 1),
	   randf_range(0, 0),  # Upward impulse
	   randf_range(-1, 1)
	)

	dice2.apply_impulse(initial_impulse2)

	
func _on_dice_body_entered(body: Node):
	SFX.play(dice_audio)
	print("Dice body entered: ", body.name)
	

func get_top_face(dice: RigidBody3D) -> int:
	var face_normals: Dictionary = {
	   4: Vector3.UP,       # +Y
	   6: Vector3.BACK,     # -Z
	   5: Vector3.LEFT,     # -X
	   2: Vector3.RIGHT,    # +X
	   1: Vector3.FORWARD,  # +Z
	   3: Vector3.DOWN      # -Y
   }

	var max_dot = -INF
	var top_face = -1

	for face in face_normals.keys():
		var local_normal = face_normals[face]
		var global_normal = dice.global_transform.basis * local_normal
		var dot = global_normal.dot(Vector3.UP)

		print("Face ", face, "	normal: ", local_normal, " 	Global normal: ", global_normal.normalized(), "   	Dot product: ", dot)
#		if dot >= 0.45 and dot <= 1.0:
		if dot > max_dot:
			print("Face ", face, " is a candidate with dot product: ", dot)
			max_dot = dot
			top_face = face

	return top_face  # Default to face 1 if no match found

	
func is_body_still(body: Node3D, threshold := 0.0001) -> bool:
	if body is CharacterBody3D:
		return body.velocity.length() < threshold
	elif body is RigidBody3D:
		return body.linear_velocity.length() < threshold
	else:
		return true # Or handle other body types as needed, or return false
