package terraform

test_workspace_name_allowed {
    result = deny with input as data.mock.valid_input
    count(result) == 0
}

test_workspace_name_denied {
    result = deny with input as data.mock.invalid_input
    count(result) > 0
}
