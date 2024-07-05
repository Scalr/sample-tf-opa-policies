version = "v1"

policy "enforce_s3_buckets_encryption" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}
