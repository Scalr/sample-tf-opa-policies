package terraform


test_resource_tags_allowed {
    result = deny with input as data.mock.allowed
    count(result) == 0
}

test_resource_tags_missing_aws {
    result = deny with input as data.mock.missing_aws
    count(result) == 1
}

test_resource_tags_missing_azure {
    result = deny with input as data.mock.missing_azure
    count(result) == 1
}

test_resource_tags_missing_google {
    result = deny with input as data.mock.missing_google
    count(result) == 1
}

test_resource_tags_missing_all {
    result = deny with input as data.mock.missing_all
    count(result) == 6
}