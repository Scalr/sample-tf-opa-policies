# Prevent specified provisioners from being used.

package terraform

import input.tfplan as tfplan


# List of disallowed provisioner types
denied_provisioners = ["local-exec"]


array_contains(arr, elem) {
  arr[_] = elem
}

module_name(path) = name {
    name := sprintf("module.%s", [path[count(path)-2]])
} else = root {
    root := "root-module"
}

# Walk the configuration looking in root module and any called module for provisioners and cehck against allowed list.
deny[reason] {
    walk(tfplan.configuration.root_module, [path, value])
    resource = value.resources[_]
    provisioner = resource.provisioners[_]
    array_contains(denied_provisioners, provisioner.type)
    module := module_name(path)
    reason := sprintf(
        "%s.%s: provisioner of type %s is not allowed",
        [module, resource.address, provisioner.type]
    )
}
