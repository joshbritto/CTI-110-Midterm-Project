extends Node

var score = 0
@onready var score_label_front: Label = $ScoreLabelFront

func add_point():
	score += 1
	score_label_front.text = "SCORE: " + str(score)
