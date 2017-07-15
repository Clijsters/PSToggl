function ConvertTo-TogglTag {
    [CmdletBinding()]
    [OutputType("PSToggl.Tag")]
    param(
        # A (set of) HashTable or PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
        $InputObject
    )

    begin {
        $objectConfig = $TogglConfiguration.ObjectTypes.Tag
    }

    process {
        $result = $InputObject | ConvertTo-TogglObject -ObjectConfig $objectConfig

        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output $this.name
        } -PassThru | Add-Member -MemberType ScriptMethod -Name "Delete" -Force -Value {
            # Invoke-TogglMethod ...
        }
        Write-Output $result
    }
}
