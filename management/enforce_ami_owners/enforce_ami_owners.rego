# Enforces all aws_ami data sources to have owners list of allowed values only
# (the actual presence of non-empty `owners` attribute
# is validated by Terraform AWS provider itself since v2.0.0)

package terraform

import input.tfplan as tfplan


# The list of owners aws_ami data sources are limited to.
# Valid values are: an AWS account ID, `self` (the current account),
# or an AWS owner alias (e.g. `amazon`, `aws-marketplace`, `microsoft`)
allowed_owners = [
  "self",
  "012345678901"
]


array_contains(arr, elem) {
  arr[_] = elem
}

eval_expression(plan, expr) = constant_value {
    constant_value := expr.constant_value
} else = reference {
    ref = expr.references[0]
    startswith(ref, "var.")
    var_name := replace(ref, "var.", "")
    reference := plan.variables[var_name].value
}

deny[reason] {
    walk(tfplan.configuration.root_module, [path, value])
    "data" == value.mode
    "aws_ami" == value.type
    owners := eval_expression(tfplan, value.expressions.owners)
    owner = owners[_]
    not array_contains(allowed_owners, owner)
    reason := sprintf(
        "%s: owner %q is not allowed. Expected owners are: %v",
        [value.address, owner, allowed_owners]
    )
}
