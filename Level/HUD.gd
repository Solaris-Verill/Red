extends CanvasLayer

var flowers = 0

func _ready():
	$flowers.text = str(flowers)
	load_hearts()
	Global.hud = self


func _on_healing_flower_flower_collected():
	flowers = flowers + 1
	_ready()
	
func load_hearts():
	print(Global.max_lives)
	print(Global.lives)
	
	$HeartsFull.size.x = Global.lives * 17
	if Global.lives == 0:
		get_tree().change_scene_to_file("res://Level/level_1.tscn")
		Global.lives = Global.max_lives
		
	if Global.max_lives - Global.lives > 0:
		$HeartsEmpty.visible = true;
		$HeartsEmpty.size.x = (Global.max_lives - Global.lives) * 17
		$HeartsEmpty.position.x = $HeartsFull.position.x + $HeartsFull.size.x * $HeartsFull.scale.x
		
	else:
		$HeartsEmpty.visible = false;
