package terraform


test_valid {
    result = deny with input as data.mock.valid
    count(result) == 0
}

test_invalid_ami {
    result = deny with input as data.mock.invalid_ami
    count(result) == 2
}

test_invalid_ws {
    result = deny with input as data.mock.invalid_ws
    count(result) == 1
}

test_no_aliases {
    result = deny with input as data.mock.no_aliases
    count(result) == 0
}

test_non_aws {
    result = deny with input as data.mock.non_aws
    count(result) == 0
}