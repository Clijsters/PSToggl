function Write-Var {
	param(
		# The name of the variable to verbose
		[Parameter(Mandatory = $true)]
		[String] $VarName
	)

    Try {
        Write-Verbose ((Get-Variable $VarName).Name.PadRight(12) + (Get-Variable $VarName).Value)
    } Catch {
        Write-Verbose ($VarName.PadRight(12) + "Could not be resolved")
    }
}
