package terraform

import input.tfplan as tfplan

min_version = "1.0.0"

# Matches that minimum version is met
deny[reason] {
	version := tfplan.terraform_version

	version < min_version

	reason := sprintf("Terraform version %s is not allowed. Please pick a version equal to or greater than %s", [version, min_version])
}
