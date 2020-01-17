package terraform

import input.tfplan as tfplan


allowed_locations = {
    "aws": ["us-east-1", "us-east-2"],
    "azurerm": ["eastus", "eastus2"],
    "google": ["us-central1-a", "us-central1-b", "us-west1-a"]
}


contains(arr, elem) {
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

get_location(resource, plan) = aws_region {
    "aws" == resource.provider_name
    provider := plan.configuration.provider_config[_]
    "aws" = provider.name
    region_expr := provider.expressions.region
    aws_region := eval_expression(plan, region_expr)
} else = azure_location {
    "azurerm" == resource.provider_name
    azure_location := resource.change.after.location
} else = google_zone {
    "google" == resource.provider_name
    google_zone := resource.change.after.zone
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    location := get_location(resource, tfplan)
    not contains(allowed_locations[resource.provider_name], location)

    reason := sprintf(
        "%s: location %q is not allowed",
        [resource.address, location]
    )
}
