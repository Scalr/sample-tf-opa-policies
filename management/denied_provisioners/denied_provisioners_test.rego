package terraform

import rego.v1

test_valid if {
	result = deny with input as data.mock.valid
	count(result) == 0
}

test_invalid_one if {
	result = deny with input as data.mock.invalid_one
	count(result) == 1
}

test_invalid_all if {
	result = deny with input as data.mock.invalid_all
	count(result) == 2
}

test_invalid_submodule if {
	result = deny with input as data.mock.invalid_submodule
	count(result) == 2
}

test_invalid_nested_module if {
	result = deny with input as data.mock.invalid_nested_module
	count(result) == 3
}
