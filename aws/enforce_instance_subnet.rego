# Enforces the use of specific subnets on EC2 instances
# This policy first checks that a subnet_id has been specified, i.e. not default for an AZ

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

# Check that subnet has been specified
deny[reason] {
    r = tfplan.resource_changes[_]
    r.mode == "managed"
    r.type == "aws_instance"
    true == r.change.after_unknown.subnet_id

    reason := sprintf(
      "%-40s :: subnet_id must be specied in terraform configuration.",
      [r.address]
    )
}

# Check subnet is in allowed list for EC2 instances
deny[reason] {
    r = tfplan.resource_changes[_]
    r.mode == "managed"
    r.type == "aws_instance"
    not array_contains(allowed_subnets, r.change.after.subnet_id)

    reason := sprintf(
      "%-40s :: subnet_id '%s' is public and not allowed",
      [r.address, r.change.after.subnet_id]
    )
}
