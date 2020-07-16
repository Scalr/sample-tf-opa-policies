package terraform

import input.tfplan as tfplan

# Blacklisted Terraform providers
not_allowed_provider = [
  "azurerm"
]


array_contains(arr, elem) {
  arr[_] = elem
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    action := resource.change.actions[count(resource.change.actions) - 1]
    array_contains(["create", "update"], action)  # allow destroy action

    array_contains(not_allowed_provider, resource.provider_name)

    reason := sprintf(
        "%s: provider type %q is not allowed",
        [resource.address, resource.provider_name]
    )
}
