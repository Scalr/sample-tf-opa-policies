package terraform

import input.tfplan as tfplan

suggested_version = "1.3.5"

# Matches that minimum version is met
suggested["Suggested version"] {
	version := tfplan.terraform_version

	version < suggested_version

	reason := sprintf("Terraform version %s will soon be deprecated. Please migrate to version %s", [version, suggested_version])
}
