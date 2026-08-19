package terraform

import rego.v1

test_all_valid if {
	result = deny with input as data.mock.all_valid
	count(result) == 0
}

test_all_invalid if {
	result = deny with input as data.mock.all_invalid
	count(result) == 2
}

test_some_invalid if {
	result = deny with input as data.mock.some_invalid
	count(result) == 1
}
