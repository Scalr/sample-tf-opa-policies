# Check variables have descriptions

package terraform

import input.tfplan as tfplan

get_desc(avar) = desc {
  desc := avar.description
} else = no_desc {
  no_desc := ""
}

deny[reason] {
	
	var = tfplan.configuration.root_module.variables[key]

	get_desc(var) == ""

	reason := sprintf("%-40s :: Variable must have a description", 
	                    [key])
}
