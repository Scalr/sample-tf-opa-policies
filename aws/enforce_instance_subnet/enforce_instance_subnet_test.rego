package terraform

import rego.v1

test_no_subnet if {
	result = deny with input as data.mock.no_subnet
	count(result) > 0
}

test_invalid_subnet if {
	result = deny with input as data.mock.invalid_subnet
	count(result) > 0
}

test_valid_subnet if {
	result = deny with input as data.mock.valid_subnet
	count(result) == 0
}
