package terraform

test_all_valid {
    result = deny with input as data.mock.all_valid
    count(result) == 0
}

test_all_invalid {
    result = deny with input as data.mock.all_invalid
    count(result) == 2
}

test_some_invalid {
    result = deny with input as data.mock.some_invalid
    count(result) == 1
}