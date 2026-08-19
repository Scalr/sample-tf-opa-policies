# Simple check that cost estimate is above threshold.

package terraform

import rego.v1

import input.tfrun as tfrun

deny contains reason if {
	cost = tfrun.cost_estimate.proposed_monthly_cost
	cost > 5
	reason := sprintf("Plan is too expensive: $%.2f, while up to $5 is allowed", [cost])
}
