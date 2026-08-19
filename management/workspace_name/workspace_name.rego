# Checks the worksoace name for a specific suffix.

package terraform

import rego.v1

import input.tfrun as tfrun

deny contains "Forbidden workspace name" if {
	not endswith(tfrun.workspace.name, "-dev")
}
