extends Node

var max_lives = 5
var lives = max_lives
var hud
var respawn1
var respawn2

func lose_life():
	lives -= 1
	hud.load_hearts()
