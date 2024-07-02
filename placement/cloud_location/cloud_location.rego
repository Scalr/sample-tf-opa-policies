# Enforce a list of allowed locations / availability zones for each provider

package terraform

import input.tfplan as tfplan


allowed_locations = {
    "aws": ["us-east-1", "us-east-2"],
    "azurerm": ["eastus", "eastus2"],
    "google": ["us-central1-a", "us-central1-b", "us-west1-a"]
}


array_contains(arr, elem) {
  arr[_] = elem
}

get_basename(path) = basename{
    arr := split(path, "/")
    basename:= arr[count(arr)-1]
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
    # registry.terraform.io/hashicorp/aws -> aws
    provider_name := get_basename(resource.provider_name)
    "aws" == provider_name
    provider := plan.configuration.provider_config[_]
    "aws" = provider.name
    region_expr := provider.expressions.region
    aws_region := eval_expression(plan, region_expr)
} else = azure_location {
    provider_name := get_basename(resource.provider_name)
    "azurerm" == provider_name
    azure_location := resource.change.after.location
} else = google_zone {
    provider_name := get_basename(resource.provider_name)
    "google" == provider_name
    google_zone := resource.change.after.zone
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    location := get_location(resource, tfplan)
    provider_name := get_basename(resource.provider_name)
    not array_contains(allowed_locations[provider_name], location)

    reason := sprintf(
        "%s: location %q is not allowed",
        [resource.address, location]
    )
}
