extends Controller
class_name AIController

var rng : RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
