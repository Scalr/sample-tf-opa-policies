package terraform

test_module_valid {
    result = deny with input as data.mock.valid
    count(result) == 0
}

test_module_invalid {
    result = deny with input as data.mock.invalid
    count(result) == 1
}

test_module_missing {
    result = deny with input as data.mock.missing
    count(result) == 1
}

test_module_valid_no_restriction {
    result = deny with input as data.mock.valid_no_restriction
    count(result) == 0
}
