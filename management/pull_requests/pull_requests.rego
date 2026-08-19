package terraform

import rego.v1

import input.tfrun as tfrun

deny contains "Merged by and PR author are the same person" if {
	not is_null(tfrun.vcs)
	pr := tfrun.vcs.pull_request
	not is_null(pr)
	pr.merged_by == pr.author
}
