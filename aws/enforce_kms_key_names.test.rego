package terraform

test_s3_invalid {
    result = deny with input as data.mock.s3_invalid
    count(result) > 0
}

test_s3_valid {
    result = deny with input as data.mock.s3_valid
    count(result) == 0
}


test_ebs_invalid {
    result = deny with input as data.mock.ebs_invalid
    count(result) > 0
}

test_ebs_valid {
    result = deny with input as data.mock.ebs_valid
    count(result) == 0
}