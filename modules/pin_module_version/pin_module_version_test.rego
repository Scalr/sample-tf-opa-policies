package terraform

import rego.v1

test_module_valid_versions if {
	result = deny with input as data.mock.valid_versions
	count(result) == 0
}

test_module_invalid_version if {
	result = deny with input as data.mock.invalid_version
	count(result) == 1
}

test_module_invalid_version_nested if {
	result = deny with input as data.mock.invalid_version_nested
	count(result) == 2
}

test_module_undefined_version if {
	result = deny with input as data.mock.undefined_version
	count(result) == 1
}

test_module_invalid_all_versions if {
	result = deny with input as data.mock.invalid_all_versions
	count(result) == 6
}
