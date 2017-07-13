function ConvertTo-TogglWorkspace {
    [CmdletBinding()]
    [OutputType("PSToggl.Workspace")]
    param(
        # A (set of) HashTable or PSCustomObject to convert
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [PSObject[]]
        $InputObject
    )

    begin {
        $objectConfig = $TogglConfiguration.ObjectTypes.Workspace
    }

    process {
        $result = $InputObject | ConvertTo-TogglObject -ObjectConfig $objectConfig

        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output $this.name
        }
        Write-Output $result
    }
}

