package terraform


test_workspace_has_active_state {
    result = deny with input as data.mock.has_active_state
    count(result) == 1
}

test_workspace_does_not_have_active_state {
    result = deny with input as data.mock.does_not_have_active_state
    count(result) == 0
}
