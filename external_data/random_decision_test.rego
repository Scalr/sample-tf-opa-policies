package terraform


test_random_decision_success {
    result = deny with random_number as 7
    count(result) == 0
}

test_random_decision_fail {
    result = deny with random_number as 2
    count(result) == 1
}
