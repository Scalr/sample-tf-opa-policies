# Enforces the denial of CIDR 0.0.0.0/0 in security groups

package terraform 

import input.tfplan as tfplan

# Add CIDRS that should be disallowed
invalid_cidrs = [
  "0.0.0.0/0"
]

array_contains(arr, elem) {
  arr[_] = elem
}

# Checks security groups embdedded ingress rules
deny[reason] {
  r := tfplan.resource_changes[_]
  r.type == "aws_security_group"
  in := r.change.after.ingress[_]
  invalid := invalid_cidrs[_]
  array_contains(in.cidr_blocks,invalid)
  reason := sprintf(
              "%-40s :: security group invalid ingress CIDR %s",
              [r.address,invalid]
            )
}

# Checks security groups embdedded egress rules
deny[reason] {
  r := tfplan.resource_changes[_]
  r.type == "aws_security_group"
  eg := r.change.after.egress[_]
  invalid := invalid_cidrs[_]
  array_contains(eg.cidr_blocks,invalid)
  reason := sprintf(
              "%-40s :: security group invalid egress CIDR %s",
              [r.address,invalid]
            )
}

# Checks security groups rules
deny[reason] {
  r := tfplan.resource_changes[_]
  r.type == "aws_security_group_rule"
  invalid := invalid_cidrs[_]
  array_contains(r.change.after.cidr_blocks,invalid)
  reason := sprintf(
              "%-40s :: security group rule invalid  CIDR %s",
              [r.address,invalid]
            )
}