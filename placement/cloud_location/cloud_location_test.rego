package terraform

import rego.v1

test_cloud_location_allowed if {
	result = deny with input as data.mock.allowed
	count(result) == 0
}

test_cloud_location_denied_aws if {
	result = deny with input as data.mock.denied_aws
	count(result) == 1
}

test_cloud_location_denied_azure if {
	result = deny with input as data.mock.denied_azure
	count(result) == 1
}

test_cloud_location_denied_google if {
	result = deny with input as data.mock.denied_google
	count(result) == 1
}

test_cloud_location_denied_all if {
	result = deny with input as data.mock.denied_all
	count(result) == 3
}
