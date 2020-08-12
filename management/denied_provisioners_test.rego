package terraform


test_valid {
    result = deny with input as data.mock.valid
    count(result) == 0
}

test_invalid_one {
    result = deny with input as data.mock.invalid_one
    count(result) == 1
}

test_invalid_all {
    result = deny with input as data.mock.invalid_all
    count(result) == 2
}

test_invalid_submodule {
    result = deny with input as data.mock.invalid_submodule
    count(result) == 2
}

test_invalid_nested_module {
    result = deny with input as data.mock.invalid_nested_module
    count(result) == 3
}
