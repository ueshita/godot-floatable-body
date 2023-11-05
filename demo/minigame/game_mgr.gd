extends Node3D

enum GameState {
	None, Title, InGame, Result,
}
var game_state: GameState

var game_time := 100.0
var start_time := 3.0
var end_time := game_time + start_time
var time_count := 0.0

var enemy_spawn_interval := 2.0
var last_enemy_spawn_time := 0.0
var player_spawn_interval := 10.0
var last_player_spawn_time := 0.0
var coin_spawn_interval := 8.0
var last_coin_spawn_time := 0.0

var coin_count := 0


func _ready():
	set_game_state(GameState.Title)
	%CharaMgr.coin_earned.connect(func(): coin_count += 1)


func _process(delta: float):
	match game_state:
		GameState.Title:
			_title_process(delta)
		GameState.InGame:
			_ingame_process(delta)
		GameState.Result:
			_result_process(delta)

	var player_count = %CharaMgr.get_player_count()
	%GUI.set_life(player_count)


func _input(event: InputEvent):
	match game_state:
		GameState.Title:
			_title_input(event)
		GameState.InGame:
			_ingame_input(event)
		GameState.Result:
			_result_input(event)


func set_game_state(state: GameState):
	match game_state:
		GameState.Title: _title_end_state()
		GameState.InGame: _ingame_end_state()
		GameState.Result: _result_end_state()

	game_state = state
	
	match game_state:
		GameState.Title: _title_begin_state()
		GameState.InGame: _ingame_begin_state()
		GameState.Result: _result_begin_state()


func _title_begin_state():
	%GUI.set_title_visible(true)
	%CharaMgr.reset_all_units()

func _title_end_state():
	%GUI.set_title_visible(false)

func _title_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			set_game_state(GameState.InGame)

func _title_process(delta: float):
	%GUI.set_time(game_time)


func _ingame_begin_state():
	time_count = 0
	coin_count = 0
	enemy_spawn_interval = 2.0
	last_enemy_spawn_time = -2.0
	player_spawn_interval = 10.0
	last_player_spawn_time = 0.0
	coin_spawn_interval = 8.0
	last_coin_spawn_time = 0.0
	%CameraCursor.set_cursor_visible(true)
	%CharaMgr.set_ingame(true)

func _ingame_end_state():
	%CharaMgr.set_ingame(false)
	%CameraCursor.set_cursor_visible(false)

func _ingame_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			%CharaMgr.player_move_to(%CameraCursor.get_cursor_pos())

func _ingame_process(delta: float):
	time_count += delta
	%GUI.set_time(clamp(end_time - time_count, 0.0, game_time))
	
	if time_count >= start_time:
		var time = time_count - start_time
		if time - last_enemy_spawn_time >= enemy_spawn_interval:
			last_enemy_spawn_time = time
			%CharaMgr.spawn_enemy()

		# Shorten interval 
		enemy_spawn_interval -= (enemy_spawn_interval * 0.02 * delta)
		enemy_spawn_interval = max(enemy_spawn_interval, 0.2)
		#print(enemy_spawn_interval)
		
		if time - last_player_spawn_time >= player_spawn_interval:
			last_player_spawn_time = time
			%CharaMgr.spawn_player(5.0)

		if time - last_coin_spawn_time >= coin_spawn_interval:
			last_coin_spawn_time = time
			%CharaMgr.spawn_coin()

	if time_count >= end_time:
		set_game_state(GameState.Result)


func _result_begin_state():
	time_count = 0.0
	
	var player_count = %CharaMgr.get_player_count()
	var total_score = 0
	total_score += player_count * 500
	total_score += coin_count * 200
	
	%GUI.set_result_values(player_count, coin_count, total_score)
	%GUI.set_result_visible(true)
	%GUI.result_done.connect(_result_done)

func _result_end_state():
	%GUI.result_done.disconnect(_result_done)
	%GUI.set_result_visible(false)

func _result_process(delta: float):
	time_count += delta

func _result_input(event: InputEvent):
	pass

func _result_done():
	set_game_state(GameState.Title)
