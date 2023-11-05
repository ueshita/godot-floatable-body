extends MarginContainer

signal result_done()

@onready var life = $GameState/Life
@onready var time = $GameState/Time


func _ready():
	$Result/VBox/Button.pressed.connect(func(): result_done.emit())


func set_life(value: int):
	life.text = "Duck: %d" % value


func set_time(value: float):
	time.text = "Time: %.2f" % value


func set_title_visible(visible: bool):
	$Title.visible = visible


func set_result_visible(visible: bool):
	$Result.visible = visible


func set_result_values(life: int, coin: int, total_score: int):
	$Result/VBox/Table/LifeValue.text = "%d x %d" % [life, 500]
	$Result/VBox/Table/CoinValue.text = "%d x %d" % [coin, 200]
	$Result/VBox/Table/TotalValue.text = "%d" % total_score
