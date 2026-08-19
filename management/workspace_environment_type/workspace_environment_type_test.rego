package terraform

import rego.v1

test_dev_workspace_cost_allowed if {
	result = deny with input as data.mock.valid_input
	count(result) == 0
}

test_dev_workspace_cost_denied if {
	result = deny with input as data.mock.invalid_input
	count(result) > 0
}
