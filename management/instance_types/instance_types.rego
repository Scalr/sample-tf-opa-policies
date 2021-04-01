# Multi provider rule to enforce instance type/size

package terraform

import input.tfplan as tfplan

# Allowed sizes by provider (examples). Edit as required
allowed_types = {
    "aws": ["t2.nano", "t2.micro"],
    "azurerm": ["Standard_A0", "Standard_A1"],
    "google": ["n1-standard-1", "n1-standard-2"]
}

# Attribute names for instance type/size by provider.
#  Add additional elements for other resources and clouds

instance_type_key = {
    "aws": [ "instance_type" ],
    "azurerm": [ "size", "sku" ],
    "google": [ "machine_type" ]
}

array_contains(arr, elem) {
  arr[_] = elem
}

get_basename(path) = basename{
    arr := split(path, "/")
    basename:= arr[count(arr)-1]
}

# Extracts the instance type/size
get_instance_type(resource) = instance_type {
    # registry.terraform.io/hashicorp/aws -> aws
    instance_type := resource.change.after[instance_type_key[resource.type]]
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    provider_name := get_basename(resource.provider_name)
    # Extract array of type attribute names for the provider
    provider_types := instance_type_key[provider_name]
    # Iterate on each type name
    type := provider_types[_]
    # Extract the type value
    instance_type := resource.change.after[type]
    
    not array_contains(allowed_types[provider_name], instance_type)

    reason := sprintf(
        "%-60s ::  '%s' of '%s' is not allowed",
        [resource.address, type, instance_type]
    )
    
}
