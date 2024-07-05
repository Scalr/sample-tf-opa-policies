version = "v1"

policy "enforce_kms_key_names" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}
