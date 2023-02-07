package terraform

import input.tfplan as tfplan

min_version = "1.0.0"

# Matches that minimum version is met
deny[reason] {

	semver.compare(tfplan.terraform_version, min_version) < 0

	reason := sprintf("Terraform version %s is not allowed. Please pick a version equal to or greater than %s", [tfplan.terraform_version, min_version])
}
