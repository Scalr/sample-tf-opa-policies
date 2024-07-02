# Restricts IAM roles for provider and workspace

package terraform
import input.tfplan as tfplan
import input.tfrun as tfrun


allowed_roles_map := {
    "arn:aws:iam::4423:role/dev": [
        "test-",
        "qa-",
        "staging-",
        "dev-"
    ],
    "arn:aws:iam::4422:role/release_admin": [
       "prod-",
       "demo-",
       "test-",
       "qa-",
       "staging-",
       "dev-"
    ]
}

eval_expression(plan, expr) = constant_value {
    constant_value := expr.constant_value
} else = reference {
    ref = expr.references[0]
    startswith(ref, "var.")
    var_name := replace(ref, "var.", "")
    reference := plan.variables[var_name].value
}

array_contains(arr, value) = true {
    arr[_] == value
}

# Extracts provider configs for AWS from the input
aws_provider_aliases[alias] = provider {
    provider := tfplan.configuration.provider_config[alias]
    provider.name == "aws"
}

# Creates a map of providers to role arn from AWS list created above
providers_roles_arn[alias] = role_arn {
    provider := aws_provider_aliases[alias]
    role_arn := eval_expression(tfplan, provider.expressions.assume_role[0].role_arn)
}

# Check the role in the provider against the allowed list for each provider in the input
deny[reason] {
    role_arn := providers_roles_arn[alias]
    # Creates an array of allowed_roles from keys of the map
    allowed_roles := [key | allowed_roles_map[key]]
    not array_contains(allowed_roles, role_arn)
    reason := sprintf(
        "%s: AWS provider with role %q is not allowed",
        [alias, role_arn]
    )
}

# Uses the map to match workspaces to roles. Only workspaces containing elements of the map for a given
# role will be allowed.
deny[reason] {
    role_arn := providers_roles_arn[alias]
    workspaces := allowed_roles_map[key]
    role_arn == key
    workspace_name := tfrun.workspace.name
    count([ws_pattern | ws_pattern := workspaces[_]; contains(workspace_name, ws_pattern)]) == 0

    reason := sprintf(
        "%s: Workspace %q is not allowed to use role %q",
        [alias, workspace_name, role_arn]
    )
}
