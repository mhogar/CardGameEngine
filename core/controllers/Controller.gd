extends Node
class_name Controller

onready var card_selector := $CardSelector

export(NodePath) var hand_node_path
onready var hand : Hand = get_node(hand_node_path)
