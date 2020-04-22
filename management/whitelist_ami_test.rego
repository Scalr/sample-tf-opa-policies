package terraform


test_valid {
    result = deny with input as data.mock.valid
    count(result) == 0
}

test_invalid_direct {
    result = deny with input as data.mock.invalid_direct
    count(result) == 4
}

test_invalid_datasource {
    result = deny with input as data.mock.invalid_datasource
    count(result) == 2
}
