version = "v1"

policy "instance_types" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "resource_tags" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "workspace_name" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "workspace_tags" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}
