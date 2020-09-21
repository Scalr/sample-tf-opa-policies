# Validate that the iam_instance_profile is in the allowed list
#

package terraform

import input.tfplan as tfplan
import input.tfrun as tfrun

allowed_iam_profiles = [
  "my_iam_profile", 
  "my_iam_profile_2",
  "my_iam_profile_3"
]

array_contains(arr, elem) {
  arr[_] = elem
}

eval_expression(expr) = name {
    name := expr[_].name
} else = iamp {
    iamp = expr
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    iam := eval_expression(resource.change.after.iam_instance_profile)
    not array_contains(allowed_iam_profiles, iam)

    reason := sprintf(
      "%-40s :: iam_instance_profile '%s' is not allowed.",
      [resource.address, iam]
    )
}