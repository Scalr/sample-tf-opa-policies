package terraform

import rego.v1

test_iam_invalid if {
	result = deny with input as data.mock.iam_invalid
	count(result) > 0
}

test_iam_valid if {
	result = deny with input as data.mock.iam_valid
	count(result) == 0
}
