extends Node
class_name Controller

onready var hand_card_selector := $HandCardSelector
onready var pile_card_selector := $PileCardSelector

export(NodePath) var hand_node_path
onready var hand : Hand = get_node(hand_node_path)
