extends Node

onready var table := $Table
onready var hand := $Table/Hand
onready var play_pile := $Table/PlayPile

onready var tween := $Tween


func _ready():
	pass
	

func move_card(index : int, src : Deck, dest : Deck):
	var card := src.remove_card(index)
	add_child(card)
	
	card.position = table.transform.xform(hand.get_card_relative_position(card))
	card.reset_anims()
	
	tween.interpolate_property(card, "position", card.position, table.transform.xform(play_pile.position), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed", [dest, card])
	tween.start()
	

func _on_Hand_select_card(index : int):
	move_card(index, hand, play_pile)


func _on_Tween_tween_all_completed(deck : Deck, card: Card):
	remove_child(card)
	
	card.position = Vector2()
	deck.add_card(card)
