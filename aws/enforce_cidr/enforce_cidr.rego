# Enforces the denial of CIDR 0.0.0.0/0 in security groups

package terraform

import rego.v1

import input.tfplan as tfplan

# Add CIDRS that should be disallowed
invalid_cidrs := [
	"0.0.0.0/0",
]

array_contains(arr, elem) if {
	arr[_] = elem
}

# Checks security groups embdedded ingress rules
deny contains reason if {
	r := tfplan.resource_changes[_]
	r.type == "aws_security_group"
	ingress := r.change.after.ingress[_]
	invalid := invalid_cidrs[_]
	array_contains(ingress.cidr_blocks, invalid)
	reason := sprintf(
		"%-40s :: security group invalid ingress CIDR %s",
		[r.address, invalid],
	)
}

# Checks security groups embdedded egress rules
deny contains reason if {
	r := tfplan.resource_changes[_]
	r.type == "aws_security_group"
	eg := r.change.after.egress[_]
	invalid := invalid_cidrs[_]
	array_contains(eg.cidr_blocks, invalid)
	reason := sprintf(
		"%-40s :: security group invalid egress CIDR %s",
		[r.address, invalid],
	)
}

# Checks security groups rules
deny contains reason if {
	r := tfplan.resource_changes[_]
	r.type == "aws_security_group_rule"
	invalid := invalid_cidrs[_]
	array_contains(r.change.after.cidr_blocks, invalid)
	reason := sprintf(
		"%-40s :: security group rule invalid  CIDR %s",
		[r.address, invalid],
	)
}
