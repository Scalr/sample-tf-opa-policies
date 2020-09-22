# Implements an allowed list of resource types.
#
# NOTE: This policy would also prevent the use of all providers except AWS.
#       To allow other clouds with no restrictions on resource types add the following line to the rule
#       before "not array_contains..."
#
#       startswith(resources.type,"aws_")

package terraform

import input.tfplan as tfplan

# Allowed Terraform resources
allowed_resources = [
  "aws_security_group",
  "aws_instance",
  "aws_s3_bucket"
]


array_contains(arr, elem) {
  arr[_] = elem
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    action := resource.change.actions[count(resource.change.actions) - 1]
    array_contains(["create", "update"], action)  # allow destroy action

    not array_contains(allowed_resources, resource.type)

    reason := sprintf(
        "%s: resource type %q is not allowed",
        [resource.address, resource.type]
    )
}
