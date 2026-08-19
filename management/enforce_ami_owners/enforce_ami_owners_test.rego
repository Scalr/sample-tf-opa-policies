package terraform

import rego.v1

test_valid if {
	result = deny with input as data.mock.valid
	count(result) == 0
}

test_invalid if {
	result = deny with input as data.mock.invalid
	count(result) == 1
}

test_invalid_all if {
	result = deny with input as data.mock.invalid_all
	count(result) == 3
}

test_invalid_nested if {
	result = deny with input as data.mock.invalid_nested
	count(result) == 2
}
