package terraform

test_valid {
    result = deny with input as data.mock.valid
    count(result) == 0
}

test_invalid {
    result = deny with input as data.mock.invalid
    count(result) == 1
}

test_missing {
    result = deny with input as data.mock.missing
    count(result) == 1
}