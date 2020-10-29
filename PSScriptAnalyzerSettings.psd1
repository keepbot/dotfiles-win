@{
    ExcludeRules = @(
        'PSAvoidUsingCmdletAliases',
        'PSAvoidUsingInvokeExpression',
        'PSAvoidUsingWriteHost'
        'PSUseApprovedVerbs',
        # PSUseDeclaredVarsMoreThanAssignments doesn't currently work due to:
        # https://github.com/PowerShell/PSScriptAnalyzer/issues/636
        'PSUseDeclaredVarsMoreThanAssignments',
        'PSUseProcessBlockForPipelineCommand',
        # Do not check functions whose verbs change system state
        'PSUseShouldProcessForStateChangingFunctions',
        'PSUseSingularNouns'
    )
}
