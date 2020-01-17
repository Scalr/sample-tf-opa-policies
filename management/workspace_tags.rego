package terraform

import input.tfplan as tfplan
import input.tfrun as tfrun


contains(arr, elem) {
  arr[_] = elem
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    action := resource.change.actions[count(resource.change.actions) - 1]
    contains(["create", "update"], action)

    ws_tags := [ key | tfrun.workspace.tags[key] ]
    cloud_tag := resource.provider_name
    not contains(ws_tags, cloud_tag)

    reason := sprintf("Workspace must be marked with %q tag to create resources in %s cloud",
                      [cloud_tag, cloud_tag])
}
