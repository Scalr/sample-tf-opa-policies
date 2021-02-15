package terraform

test_invalid {
    result = deny with input as data.mock.invalid
    count(result) == 1
}

test_valid {
    result = deny with input as data.mock.valid
    count(result) == 0
}
