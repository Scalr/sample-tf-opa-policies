package terraform

test_pull_request_author_merged_by_are_same {
    result = deny with input as data.mock.same
    count(result) == 1
}

test_pull_request_author_merged_by_are_not_same {
    result = deny with input as data.mock.not_same
    count(result) == 0
}

test_commit_without_pull_request {
    result = deny with input as data.mock.no_pr
    count(result) == 0
}

