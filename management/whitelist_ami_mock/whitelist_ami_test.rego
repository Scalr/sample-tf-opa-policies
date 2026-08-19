package terraform

import rego.v1

test_valid if {
	result = deny with input as data.mock.valid
	count(result) == 0
}

test_invalid_direct if {
	result = deny with input as data.mock.invalid_direct
	count(result) == 4
}

test_invalid_datasource if {
	result = deny with input as data.mock.invalid_datasource
	count(result) == 2
}
