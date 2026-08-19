package terraform

import rego.v1

test_module_valid if {
	result = deny with input as data.mock.valid
	count(result) == 0
}

test_module_invalid if {
	result = deny with input as data.mock.invalid
	count(result) == 1
}

test_module_missing if {
	result = deny with input as data.mock.missing
	count(result) == 1
}

test_module_valid_no_restriction if {
	result = deny with input as data.mock.valid_no_restriction
	count(result) == 0
}
