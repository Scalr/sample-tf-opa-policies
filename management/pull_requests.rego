package terraform

import input.tfrun as tfrun

deny["Merged by and PR author are the same person"] {
    not is_null(tfrun.vcs)
    pr := tfrun.vcs.pull_request
    not is_null(pr)
    pr.merged_by == pr.author
}
