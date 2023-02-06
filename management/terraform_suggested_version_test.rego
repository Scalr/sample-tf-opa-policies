package terraform

test_not_suggested_versions {
	result = suggested with input as data.mock.not_suggested_version
	count(result) == 1
}

test_suggested_versions {
	result = suggested with input as data.mock.suggested_version
	count(result) == 0
}
