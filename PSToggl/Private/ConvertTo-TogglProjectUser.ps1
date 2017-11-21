function ConvertTo-TogglProjectUser {
    [CmdletBinding()]
    [OutputType("PSToggl.ProjectUser")]
    param(
        # A (set of) HashTable or PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
        $InputObject
    )

    begin {
        New-Item function::local:Write-Verbose -Value (
            New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
        ).NewBoundScriptBlock{
            param($Message)
            if ($verbose) {
                & $verb -Message "=>$fixedName $Message" -Verbose
            }
            else {
                & $verb -Message "=>$fixedName $Message"
            }
        } | Write-Verbose

        $objectConfig = $TogglConfiguration.ObjectTypes.ProjectUser
    }

    process {
        Write-Verbose "Passing `$InputObject to ConvertTo-TogglObject"
        $result = $InputObject | ConvertTo-TogglObject -ObjectConfig $objectConfig

        Write-Verbose "Adding ToString() and Delete()"

        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output $this.name
        } -PassThru | Add-Member -MemberType ScriptMethod -Name "Delete" -Force -Value {
            # Invoke-TogglMethod ...
        }
        Write-Output $result
    }
}
