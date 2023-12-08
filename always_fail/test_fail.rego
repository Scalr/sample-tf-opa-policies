package terraform


deny[reason] {
    true


    reason := sprintf("Variables: %v",[tfplan.variables])
}
