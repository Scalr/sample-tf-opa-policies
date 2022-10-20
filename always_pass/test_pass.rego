package terraform


deny[reason] {
    false

    reason := sprintf("Variables: %v",[tfplan.variables])
}
