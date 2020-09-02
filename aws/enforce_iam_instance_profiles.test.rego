package terraform

test_iam_invalid {
    result = deny with input as data.mock.iam_invalid
    count(result) > 0
}

test_iam_valid {
    result = deny with input as data.mock.iam_valid
    count(result) == 0
}
