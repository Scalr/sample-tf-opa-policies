package terraform

test_valid_acl {
    result = deny with input as data.mock.valid_bucket_acl
    count(result) == 0
}

test_invalid_acl {
    result = deny with input as data.mock.invalid_bucket_acl
    count(result) == 1
}

test_valid_control {
    result = deny with input as data.mock.valid_access_control
    count(result) == 0
}

test_invalid_control {
    result = deny with input as data.mock.invalid_access_control
    count(result) == 1
}
