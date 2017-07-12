function ConvertTo-TogglGroup {
    [CmdletBinding()]
    [OutputType("PSToggl.Group")]
    param(
        # A (set of) HashTable or PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
        $InputObject
    )

    begin {
        $objectConfig = $TogglConfiguration.ObjectTypes.Group
        $objectName = "Group"
    }

    process {
        $result = $InputObject | ConvertTo-TogglObject -ObjectName $objectName -ObjectConfig $objectConfig

        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output $this.name
        }
        Write-Output $result
    }
}
