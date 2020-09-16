package terraform

test_provider_allowed {
    result = deny with input as data.mock.valid_input
    count(result) == 0
}

test_provider_denied {
    result = deny with input as data.mock.invalid_input
    count(result) > 0
}
