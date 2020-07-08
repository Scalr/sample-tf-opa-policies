package terraform


test_valid {
    result = deny with input as data.mock.valid
    count(result) == 0
}

test_invalid {
    result = deny with input as data.mock.invalid
    count(result) == 1
}

test_invalid_all {
    result = deny with input as data.mock.invalid_all
    count(result) == 3
}

test_invalid_nested {
    result = deny with input as data.mock.invalid_nested
    count(result) == 2
}
