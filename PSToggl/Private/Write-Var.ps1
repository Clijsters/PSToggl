function Write-Var {
	param(
		# The name of the variable to verbose
		[Parameter(Mandatory = $true)]
		[String] $VarName
	)

    Try {
        Write-Debug ((Get-Variable $VarName).Name.PadRight(12) + (Get-Variable $VarName).Value)
    } Catch {
        Write-Debug ($VarName.PadRight(12) + "Could not be resolved")
    }
}
