extends Node2D

const Room = preload("res://Generation/Room.tscn")
const Player = preload("res://Player/Player.tscn")
const Grass = preload("res://World/Grass.tscn")
const Bat = preload("res://Enemies/Bat.tscn")
const Barrel = preload("res://World/Barrel.tscn")
const Generator = preload("res://Generation/Generator.tscn")
const Portal = preload("res://Generation/Portal.tscn")

onready var Map = $TileMap
onready var YSort = $YSort

var tile_size = 32
var num_rooms = 15
var min_size = 6 
var max_size = 12
var hspread = 100
var cull = 0
var path
var start
var end

func _ready():
	randomize()
	make_rooms()
	
func make_rooms():
	for _i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
	yield(get_tree().create_timer(1.1), "timeout")
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			var newRoomX = (floor(room.position.x / 64) * 64)
			var newRoomY = (floor(room.position.y / 64) * 64)
			var newRoomExtents = room.get_node("CollisionShape2D").shape.extents
			var newRoomPos = Vector2(newRoomX, newRoomY)
			room.queue_free()
			var newRoom = Room.instance()
			newRoom.make_room_without_collision(newRoomPos, newRoomExtents)
			newRoom.mode = RigidBody2D.MODE_STATIC
			room_positions.append(newRoom.position)
			$Rooms.add_child(newRoom)
	yield(get_tree(), "idle_frame")
	path = find_mst(room_positions)
	$CanvasLayer/Floor.text = "Floor " + str(GameData.Floor)
	$CanvasLayer/Floor.visible = true
	$CanvasLayer/Continue.visible = true

func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2),
				Color(32, 228, 0), false)
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(pp, cp, Color(1, 1, 0), 15, true)  

func _process(_delta):
		update()

func _input(event):
	if event.is_action_pressed("ui_select"):
		for n in $Rooms.get_children():
			n.queue_free()
		path = null
		make_rooms()
	if event.is_action_pressed("ui_focus_next"):
		$CanvasLayer.queue_free()
		make_map()
		var player = Player.instance()
		YSort.add_child(player)
		player.position = start.position
		var player_camera = player.get_node("Camera2D")
		player_camera.make_current()

func find_mst(nodes):
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF #Min dist so far
		var min_p = null #Position of that node
		var p = null #Position
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
	return path
	
func make_map():
	Map.clear()
	start_room()
	end_room()
	var corridors = []
	var paths = []
	var index = 0
	make_walls()
	make_corridors(index, corridors) 
	index = 0
	make_paths(index, paths)
	make_floors()
	Map.update_bitmask_region()
	populate(1.5, Bat, 0.01, 2, 5)
	

func carve_path(pos1, pos2, index):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = index % 2
	if y_diff == 0: y_diff = index % 2
	var x_y = pos1
	var y_x = pos2
	if index % 2 > 0:
		x_y = pos2
		y_x = pos1
	
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, 2)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, 2)
		
func carve_path_outline(pos1, pos2, index):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = index % 2
	if y_diff == 0: y_diff = index % 2
	var x_y = pos1
	var y_x = pos2
	if index % 2 > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x - x_diff, pos2.x + x_diff, x_diff):
		Map.set_cell(x, x_y.y + 1, 1)
	for y in range(pos1.y - y_diff, pos2.y + y_diff, y_diff):
		Map.set_cell(y_x.x + 1, y, 1)
	
	for x in range(pos1.x - x_diff, pos2.x + x_diff, x_diff):
		Map.set_cell(x, x_y.y - 1, 1)
	for y in range(pos1.y - y_diff, pos2.y + y_diff, y_diff):
		Map.set_cell(y_x.x - 1, y, 1)
	
func start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start = room
			min_x = room.position.x

func end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end = room
			max_x = room.position.x
	var portal = Portal.instance()
	portal.position = end.position
	add_child(portal)

func make_walls():
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var ul = (room.position / tile_size).floor() - s
		for x in range(0, s.x * 2):
			for y in range(0, s.y * 2):
				Map.set_cell(ul.x + x, ul.y + y, 1)

func make_corridors(index, corridors):
	for room in $Rooms.get_children():
		var p = path.get_closest_point(room.position)
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(path.get_point_position(p))
				var end = Map.world_to_map(path.get_point_position(conn))
				carve_path_outline(start, end, index)
				index +=1 
		corridors.append(p)

func make_paths(index, paths):
	for room in $Rooms.get_children():
		var p = path.get_closest_point(room.position)
		for conn in path.get_point_connections(p):
			if not conn in paths:
				var start = Map.world_to_map(path.get_point_position(p))
				var end = Map.world_to_map(path.get_point_position(conn))
				carve_path(start, end, index)
				index +=1 
		paths.append(p)

func make_floors():
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var ul = (room.position / tile_size).floor() - s
		for x in range(1, s.x * 2 - 1):
			for y in range(1, s.y * 2 - 1):
				Map.set_cell(ul.x + x, ul.y + y, 2)

func populate(margin, thingToSpawn, chanceToSpawn, spawnSizeMin, spawnSizeMax):
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		for x in range(margin, s.x * 2 - margin):
			for y in range(margin, s.y * 2 - margin - 1):
				if rand_range(0, 1) < chanceToSpawn:
					var generator = Generator.instance()
					generator.thingToSpawn = thingToSpawn
					generator.amountToSpawn = spawnSizeMin + (randi() % (spawnSizeMax - spawnSizeMin))
					YSort.add_child(generator)
					generator.position = Vector2(room.position.x + x * tile_size - room.size.x, room.position.y - room.size.y + y * tile_size)


func onPortalEntered():
	get_parent().generate_new_level(ImportData.floor_data + 10)
	queue_free()
