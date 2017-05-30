function New-TogglEntry {
    <#
    .Synopsis
        Creates a new Toggl Entry
    .DESCRIPTION
    .EXAMPLE
    .INPUTS
    .OUTPUTS
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param(
        # The Description and title of the entry
        [Parameter(Mandatory = $false)]
        [string] $Description = $null,

        # The name of the Project to assign this entry to.
        [Parameter(Mandatory = $false)]
        [string] $ProjectName = $null,

        # Tags to identify related entries
        [Parameter(Mandatory = $false)]
        [string[]] $Tags,

        #The duration of your activity in minutes
        [Parameter(Mandatory = $true)]
        [int] $Duration,

        # The start time of your entry (defaults to now()-Duration)
        [Parameter(Mandatory = $false)]
        [datetime] $Start = [datetime]::now()
    )

    begin {
    }

    process {
    }

    end {
    }
}
