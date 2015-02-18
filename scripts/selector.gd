
extends AnimatedSprite

var anim
var current_cost = 0

var action_controller = null
var movement_controller = null

func init(controller):
	action_controller = controller
	movement_controller = controller.movement_controller

func reset():
	action_controller = null
	movement_controller = null

func set_player(player):
	if player == 0:
		anim.play("blue")
	if player == 1:
		anim.play("red")

func set_neutral():
	anim.play("neutral")
	
func calculate_cost():
	current_cost = 0
	
	if action_controller == null || movement_controller == null:
		return # not initiated
		
	var active_field = action_controller.active_field
	var marked_field = action_controller.abstract_map.get_field(action_controller.root_node.selector_position)
	
	if action_controller.player_ap < 1:
		return # no ap left

	if active_field == null || active_field.object == null || active_field.object.group != 'unit':
		return # empty active field
	if marked_field == null || marked_field.terrain_type == -1:
		return # tile is not part of the map
		
	var unit = active_field.object
	var target = marked_field.object
	
	if target != null: 
		if target.group == 'terrain':
			return # impassible terrain
		if target.player == unit.player:
			return # own building
		
		if target.group == 'unit' && unit.can_attack():
			current_cost = unit.attack_ap
		if target.group == 'building':
			current_cost = movement_controller.get_terrain_cost(active_field, movement_controller.get_terrain_type(marked_field))
	else:
		current_cost = movement_controller.get_terrain_cost(active_field, movement_controller.get_terrain_type(marked_field))
	

func _ready():
	anim = self.get_node("anim")
	anim.play("neutral")
	pass


