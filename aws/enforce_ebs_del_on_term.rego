# Enforces delete_on_termination = true
# Default is true so this policy only checks for false if specified

package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun


# Check root volume
deny[reason] {
    r = tfplan.resource_changes[_]
    r.mode == "managed"
    r.type == "aws_instance"
    rbd := r.change.after.root_block_device[_]
    rbd.delete_on_termination == false
    reason := sprintf(
      "%-40s :: delete_on_termination must = true for 'root_block_device'",
      [r.address]
    )
}


deny[reason] {
    r = tfplan.resource_changes[_]
    r.mode == "managed"
    r.type == "aws_instance"
    ebd := r.change.after.ebs_block_device[_]
    ebd.delete_on_termination == false
    reason := sprintf(
      "%-40s :: Device %s :: delete_on_termination must = true for 'ebs_block_device'",
      [r.address, ebd.device_name]
    )
}