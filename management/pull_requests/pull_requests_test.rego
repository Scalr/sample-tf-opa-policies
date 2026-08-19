package terraform

import rego.v1

test_pull_request_author_merged_by_are_same if {
	result = deny with input as data.mock.same
	count(result) == 1
}

test_pull_request_author_merged_by_are_not_same if {
	result = deny with input as data.mock.not_same
	count(result) == 0
}

test_commit_without_pull_request if {
	result = deny with input as data.mock.no_pr
	count(result) == 0
}
