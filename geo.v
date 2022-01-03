module main

import os
import flag
import geometry

fn main() {
	mut fp := flag.new_flag_parser(os.args)

	fp.application(geometry.name)
	fp.version(geometry.version)
	fp.description(geometry.description)
	fp.skip_executable()

	show_help := fp.bool('help', `h`, false, 'Show this help text.')

	mut shape := fp.string('shape', `p`, 'none', 'The shape to use for the geometry.' +
		'\n                            Allowed shapes are: ${geometry.allowed_shapes.join(', ')}')

	size := fp.int('size', `z`, 5, 'The size parameter for the shapes.')
	symbol := fp.string('symbol', `m`, '*', 'The symbol to use for the geometry.').runes()[0]

	if show_help {
		println(fp.usage())
		exit(0)
	}

	if size <= 0 {
		println('Size parameter must be positive.')
		exit(1)
	}

	if shape !in geometry.allowed_shapes && shape != 'none' {
		println('Invalid shape: $shape')
		println(fp.usage())
		exit(1)
	}

	shape_kind := if shape == 'none' { get_shape_input() } else { geometry.shape_map[shape] }

	lines := geometry.generate_shape(kind: shape_kind, size: size, symbol: symbol)
	println(lines.join_lines())
}

// get_shape_input continuously asks the user for a shape until the user enters a valid shape
fn get_shape_input() geometry.GeometricShapeKind {
	for true {
		input_string := os.input_opt('Enter a shape: ') or { 'none' }

		if input_string == 'none' || input_string !in geometry.allowed_shapes {
			println('Invalid shape: $input_string')
			println('Available options are: ${geometry.allowed_shapes.join(', ')}')
			continue
		}

		return geometry.shape_map[input_string]
	}
	return geometry.GeometricShapeKind.left_triangle
}
