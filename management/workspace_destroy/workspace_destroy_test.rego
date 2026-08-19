package terraform

import rego.v1

test_workspace_has_resources if {
	result = deny with input as data.mock.has_resources
	count(result) == 1
}

test_workspace_does_not_have_resources if {
	result = deny with input as data.mock.does_not_have_resources
	count(result) == 0
}
