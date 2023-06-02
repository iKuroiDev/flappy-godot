extends Node

const MAX_SCORE_HISTORY = 3

var hi_score = 0
var scores = [
	0, 0, 0
]

func set_score(score):
	if score > hi_score:
		hi_score = score
	scores.insert(0, score)
	if scores.size() > MAX_SCORE_HISTORY:
		scores.remove(scores.size() - 1)
		
func get_hi_score():
	return hi_score

func get_scores():
	return scores
