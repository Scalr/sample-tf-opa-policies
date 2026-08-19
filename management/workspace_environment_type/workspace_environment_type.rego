package terraform

import rego.v1

import input.tfrun as tfrun

deny contains "Monthly cost for dev workspace exceeds $100" if {
	tfrun.workspace.environment_type == "development"
	tfrun.cost_estimate.proposed_monthly_cost > 100
}
