package terraform

import rego.v1

test_s3_invalid if {
	result = deny with input as data.mock.s3_invalid
	count(result) > 0
}

test_s3_valid if {
	result = deny with input as data.mock.s3_valid
	count(result) == 0
}

test_ebs_invalid if {
	result = deny with input as data.mock.ebs_invalid
	count(result) > 0
}

test_ebs_valid if {
	result = deny with input as data.mock.ebs_valid
	count(result) == 0
}
