@abstract extends Node2D
class_name Item

signal item_picked_up(item: String)

@abstract func name() -> String
