package terraform


test_workspace_tags_allowed {
    result = deny with input as data.mock.valid_tags
    count(result) == 0
}

test_workspace_tags_missing {
    result = deny with input as data.mock.missing_tag
    count(result) == 1
}

test_workspace_tags_missing_all {
    result = deny with input as data.mock.missing_all
    count(result) == 2
}

test_workspace_tags_delete_action {
    result = deny with input as data.mock.delete_action
    count(result) == 0
}
