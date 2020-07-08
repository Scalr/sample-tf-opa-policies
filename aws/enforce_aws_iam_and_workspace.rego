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

# check only aws providers with aliases
aws_provider_aliases[alias] = provider {
    provider := tfplan.configuration.provider_config[alias]
    provider.alias
    provider.name == "aws"
}

providers_roles_arn[alias] = role_arn {
    provider := aws_provider_aliases[alias]
    role_arn := eval_expression(tfplan, provider.expressions.assume_role[0].role_arn)
}


deny[reason] {
    role_arn := providers_roles_arn[alias]
    allowed_roles := [key | allowed_roles_map[key]]
    not array_contains(allowed_roles, role_arn)
    reason := sprintf(
        "%s: AWS provider with role %q is not allowed",
        [alias, role_arn]
    )
}

deny[reason] {
    role_arn := providers_roles_arn[alias]
    workspaces := allowed_roles_map[key]
    role_arn == key
    workspace_name := tfrun.workspace.name
    count([ws_pattern | ws_pattern := workspaces[_]; contains(workspace_name, ws_pattern)]) == 0

    reason := sprintf(
        "%s: Worksapce %q is not allowed to use role %q",
        [alias, workspace_name, role_arn]
    )
}