package terraform


test_valid_s3_bucket {
    result = deny with input as data.mock.valid_s3_bucket_input
    count(result) == 0
}

test_invalid_s3_bucket_acls {
    result = deny with input as data.mock.invalid_s3_bucket_acls_input
    count(result) == 2
}

test_invalid_s3_bucket_encryption {
    result = deny with input as data.mock.invalid_s3_bucket_encryption_input
    count(result) == 2
    array_contains(result, "aws_s3_bucket.a: expected sse_algorithm to be one of [\"aws:kms\", \"AES256\"]")
    array_contains(result, "module.child.aws_s3_bucket.b: requires server-side encryption with expected sse_algorithm to be one of [\"aws:kms\", \"AES256\"]")
}