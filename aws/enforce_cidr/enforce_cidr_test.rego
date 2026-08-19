package terraform

import rego.v1

test_valid_sg if {
	result = deny with input as data.mock.valid_sg
	count(result) == 0
}

test_invalid_sg if {
	result = deny with input as data.mock.invalid_sg
	count(result) > 0
}

test_valid_sgr if {
	result = deny with input as data.mock.valid_sgr
	count(result) == 0
}

test_invalid_sgr if {
	result = deny with input as data.mock.invalid_sgr
	count(result) > 0
}
