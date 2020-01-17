package terraform


test_instance_types_allowed {
    result = deny with input as data.mock.allowed
    count(result) == 0
}

test_instance_types_denied_aws {
    result = deny with input as data.mock.denied_aws
    count(result) == 1
}

test_instance_types_denied_azure {
    result = deny with input as data.mock.denied_azure
    count(result) == 1
}

test_instance_types_denied_google {
    result = deny with input as data.mock.denied_google
    count(result) == 1
}

test_instance_types_denied_all {
    result = deny with input as data.mock.denied_all
    count(result) == 3
}
