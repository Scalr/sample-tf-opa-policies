version = "v1"

policy "cloud_location" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "user" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}
