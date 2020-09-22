# Enforces the use of specific subnets on AS Load Balancers subnet groups

package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

# Add only private subnets to this list.
# NOTE: OPA cannot validate that a subnet is private unless the terraform config is actaully creating the subnet.
allowed_subnets = [
    "subnet-019c416174b079502",
    "subnet-04dbded374ed11690"
  ]

array_contains(arr, elem) {
  arr[_] = elem
}

lbs = [
  "aws_elb",
  "aws_lb"
]

# Check subnets are in allowed list 
deny[reason] {
    r = tfplan.resource_changes[_]
    r.mode == "managed"
    r.type == lbs[_]
    sid := r.change.after.subnets[_]
    not array_contains(allowed_subnets, sid)

    reason := sprintf(
      "%-40s :: subnet_id '%s' is public and not allowed!",
      [r.address, sid]
    )
}