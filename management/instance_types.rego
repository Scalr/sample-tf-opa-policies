package terraform

import input.tfplan as tfplan


allowed_types = {
    "aws": ["t2.nano", "t2.micro"],
    "azurerm": ["Standard_A0", "Standard_A1"],
    "google": ["n1-standard-1", "n1-standard-2"]
}


instance_type_key = {
    "aws": "instance_type",
    "azurerm": "vm_size",
    "google": "machine_type"
}

contains(arr, elem) {
  arr[_] = elem
}

get_instance_type(resource) = instance_type {
    instance_type := resource.change.after[instance_type_key[resource.provider_name]]
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    instance_type := get_instance_type(resource)
    not contains(allowed_types[resource.provider_name], instance_type)

    reason := sprintf(
        "%s: instance type %q is not allowed",
        [resource.address, instance_type]
    )
}
