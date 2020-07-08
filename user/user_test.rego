package terraform


test_cli_user_allowed {
    result = deny with input as data.mock.valid_cli_user
    count(result) == 0
}

test_cli_user_denied {
    result = deny with input as data.mock.invalid_cli_user
    count(result) == 1
}

test_vcs_user_allowed {
    result = deny with input as data.mock.valid_vcs_user
    count(result) == 0
}

test_vcs_user_denied {
    result = deny with input as data.mock.invalid_vcs_user
    count(result) == 1
}

test_vcs_user_not_aws {
    result = deny with input as data.mock.vcs_user_not_aws
    count(result) == 0
}
