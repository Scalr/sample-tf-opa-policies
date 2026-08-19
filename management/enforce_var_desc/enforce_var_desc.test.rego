package terraform

import rego.v1

test_invalid if {
	result = deny with input as data.mock.invalid
	count(result) == 1
}

test_valid if {
	result = deny with input as data.mock.valid
	count(result) == 0
}
