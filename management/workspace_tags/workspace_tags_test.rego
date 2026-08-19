package terraform

import rego.v1

test_workspace_tags_allowed if {
	result = deny with input as data.mock.valid_tags
	count(result) == 0
}

test_workspace_tags_missing if {
	result = deny with input as data.mock.missing_tag
	count(result) == 1
}

test_workspace_tags_missing_all if {
	result = deny with input as data.mock.missing_all
	count(result) == 2
}

test_workspace_tags_delete_action if {
	result = deny with input as data.mock.delete_action
	count(result) == 0
}
