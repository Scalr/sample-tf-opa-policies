package terraform

import input.tfplan as tfplan

# Allowed Terraform resources
allowed_resources = [
  "aws_security_group",
  "aws_instance"
]


array_contains(arr, elem) {
  arr[_] = elem
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    not array_contains(allowed_resources, resource.type)

    reason := sprintf(
        "%s: resource type %q is not allowed",
        [resource.address, resource.type]
    )
}
