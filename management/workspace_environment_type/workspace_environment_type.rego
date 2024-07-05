package terraform

import input.tfrun as tfrun

deny["Monthly cost for dev workspace exceeds $100"] {
    tfrun.workspace.environment_type == "development"
    tfrun.cost_estimate.proposed_monthly_cost > 100
}
