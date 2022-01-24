module geometry_tests

import os

struct RunConfig {
	shape  string
	size   int    = 5
	symbol string = '*'
	output string
}

const (
	all_options_test_cases = [
		RunConfig{
			shape: 'square'
			size: 5
			symbol: '|'
			output: '|||||\n|||||\n|||||\n|||||\n|||||\n'
		},
		RunConfig{
			shape: 'pyramid'
			size: 3
			symbol: '^'
			output: '  ^\n ^^^\n^^^^^\n'
		},
		RunConfig{
			shape: 'diamond'
			size: 4
			symbol: '*'
			output: '   *\n  ***\n *****\n*******\n *****\n  ***\n   *\n'
		},
	]
	shape_only_test_cases = [
		RunConfig{
			shape: 'square'
			output: '*****\n*****\n*****\n*****\n*****\n'
		},
		RunConfig{
			shape: 'pyramid'
			output: '    *\n   ***\n  *****\n *******\n*********\n'
		},
		RunConfig{
			shape: 'left-triangle'
			output: '*\n**\n***\n****\n*****\n'
		},
	]
)

fn split_into_lines(output string) []string {
	return output.split_any('\n\r').filter(it != '')
}

fn test_all_options() {
	for case in geometry_tests.all_options_test_cases {
		result := os.execute_or_panic('${@VEXE} run . --shape $case.shape --size $case.size --symbol "$case.symbol"')

		assert result.exit_code == 0
		assert split_into_lines(result.output) == split_into_lines(case.output)
	}
}

fn test_shapes_only() {
	for case in geometry_tests.shape_only_test_cases {
		result := os.execute_or_panic('${@VEXE} run . --shape $case.shape')

		assert result.exit_code == 0
		assert split_into_lines(result.output) == split_into_lines(case.output)
	}
}
