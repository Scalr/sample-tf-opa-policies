package terraform

import rego.v1

test_resource_tags_allowed if {
	result = deny with input as data.mock.allowed
	count(result) == 0
}

test_resource_tags_missing_aws if {
	result = deny with input as data.mock.missing_aws
	count(result) == 1
}

test_resource_tags_missing_azure if {
	result = deny with input as data.mock.missing_azure
	count(result) == 1
}

test_resource_tags_missing_google if {
	result = deny with input as data.mock.missing_google
	count(result) == 1
}

test_resource_tags_missing_all if {
	result = deny with input as data.mock.missing_all
	count(result) == 6
}
