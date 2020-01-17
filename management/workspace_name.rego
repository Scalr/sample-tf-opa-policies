package terraform

import input.tfrun as tfrun


deny["Forbidden workspace name"] {
    not endswith(tfrun.workspace.name, "-dev")
}
