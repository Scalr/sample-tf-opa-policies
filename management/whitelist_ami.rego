# This policy introduces AMI ids whitelist for AWS instances.
# There are two rules: the first one disallows the usage of
# all AMIs that are not from allowed list,
# while the second rule whitelists only directly (or via variable) specified AMIs
# thus allowing them to be pulled from aws_ami data source.
# You will probably want to keep only one rule that is relevant for you, 
# removing/commenting out another.

package terraform

import input.tfplan as tfplan


# A whitelist of AMI ids
allowed_amis = [
  "ami-07d0cf3af28718ef8",
  "ami-0a9b2a20d7dc001e0"
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

get_address(value) = address {
    address := value.address
} else = source {
    source := value.source
}

# Force all found AMIs to belong to allowed list
deny[reason] {
    resource := tfplan.resource_changes[_]
    action := resource.change.actions[count(resource.change.actions) - 1]
    array_contains(["create", "update"], action)
    ami := resource.change.after.ami
    not array_contains(allowed_amis, ami)
    reason := sprintf(
        "%s: AMI %q is not allowed. Expected values are: %v",
        [resource.address, ami, allowed_amis]
    )
}

# Force directly specified AMIs to belong to allowed list,
# but allow AMIs from data source
deny[reason] {
    walk(tfplan.configuration.root_module, [path, value])
    ami := eval_expression(tfplan, value.expressions.ami)
    not array_contains(allowed_amis, ami)
    reason := sprintf(
`%s: AMI %q is not allowed.
AMI id should be pulled from aws_ami data source
or otherwise be one of the allowed ones when specified directly:
%v`,
        [get_address(value), ami, allowed_amis]
    )
}