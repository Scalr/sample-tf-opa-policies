# Enforces a set of required tag keys. Values are bot checked

package terraform

import input.tfplan as tfplan


required_tags = ["owner", "department"]


array_contains(arr, elem) {
  arr[_] = elem
}

get_basename(path) = basename{
    arr := split(path, "/")
    basename:= arr[count(arr)-1]
}

# Extract the tags catering for Google where they are called "labels"
get_tags(resource) = labels {
    # registry.terraform.io/hashicorp/google -> google
    provider_name := get_basename(resource.provider_name)
    "google" == provider_name
    labels := resource.change.after.labels
} else = tags {
    tags := resource.change.after.tags
} else = empty {
    empty := {}
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    action := resource.change.actions[count(resource.change.actions) - 1]
    array_contains(["create", "update"], action)
    tags := get_tags(resource)
    # creates an array of the existing tag keys
    existing_tags := [ key | tags[key] ]
    required_tag := required_tags[_]
    not array_contains(existing_tags, required_tag)

    reason := sprintf(
        "%s: missing required tag %q",
        [resource.address, required_tag]
    )
}
