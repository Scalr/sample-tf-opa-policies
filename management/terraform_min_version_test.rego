package terraform

test_not_allowed_versions {
	result = deny with input as data.mock.not_allowed_version
	count(result) == 1
}

test_allowed_versions {
	result = deny with input as data.mock.allowed_version
	count(result) == 0
}
