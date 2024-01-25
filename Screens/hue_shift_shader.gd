@tool
extends CanvasLayer

@onready var shader : ShaderMaterial = $ColorRect.material

## Changes hue, saturation and value of input color.
## [hue] will be added to [color] hue, so [col].hue = [color].hue + [hue].
##[color] saturation and value will be multiplied by [sat] and [value], so [col].saturation(OR)value = [color].saturation(OR)value +* [sat](OR)[value]
@export_range(0, 1) var hue : float = 0.0:
	set(n_hue):
		if not (Engine.is_editor_hint() or is_node_ready()):
			return
		hue = n_hue
		shader.set_shader_parameter("hue", hue)
@export_range(0, 2) var sat : float = 1.0:
	set(n_sat):
		if not (Engine.is_editor_hint() or is_node_ready()):
			return
		sat = n_sat
		shader.set_shader_parameter("sat", sat)
@export_range(0, 2) var val : float = 1.0:
	set(n_val):
		if not (Engine.is_editor_hint() or is_node_ready()):
			return
		val = n_val
		shader.set_shader_parameter("val", val)

func _ready() -> void:
	pass
