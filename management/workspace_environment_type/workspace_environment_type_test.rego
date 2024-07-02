package terraform

test_dev_workspace_cost_allowed {
    result = deny with input as data.mock.valid_input
    count(result) == 0
}

test_dev_workspace_cost_denied {
    result = deny with input as data.mock.invalid_input
    count(result) > 0
}
