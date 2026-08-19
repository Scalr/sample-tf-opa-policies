package terraform

import rego.v1

test_random_decision_success if {
	result = deny with random_number as 7
	count(result) == 0
}

test_random_decision_fail if {
	result = deny with random_number as 2
	count(result) == 1
}
