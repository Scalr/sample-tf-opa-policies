# Enforces the use of specific a specific security group

package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

required_sg := "sg-0434611e67ac24e27"

array_contains(arr, elem) {
  arr[_] = elem
}

deny[reason] {
  r := tfplan.resource_changes[_]
  r.change.after_unknown.vpc_security_group_ids == true

  reason := sprintf(
              "%-40s :: security group '%s' must be specified",
              [r.address,required_sg]
            )
}

deny[reason] {
  r := tfplan.resource_changes[_]
  vsg := r.change.after.vpc_security_group_ids
  not array_contains(vsg, required_sg)

  reason := sprintf(
              "%-40s :: security group '%s' must be included in list",
              [r.address,required_sg]
            )
}