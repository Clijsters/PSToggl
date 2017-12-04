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
        [Parameter(Mandatory = $true, ParameterSetName = "byDuration")]
        [int] $Duration,

        #The duration of your activity in minutes
        [Parameter(Mandatory = $true, ParameterSetName = "byStart")]
        [datetime] $Start,

        # The end time of your entry (defaults to now()-Duration)
        [Parameter(Mandatory = $false)]
        [datetime] $End = [datetime]::now()
    )

    begin {
        New-Item function::local:Write-Verbose -Value (
            New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
        ).NewBoundScriptBlock{
            param($Message)
            if ($verbose) {
                & $verb -Message "=>$fixedName $Message" -Verbose
            } else {
               & $verb -Message "=>$fixedName $Message"
            }
        } | Write-Verbose

    }

    process {
    }

    end {
    }
}
