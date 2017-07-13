function New-TogglProject {
    <#
    .Synopsis
        Creates a new Toggl Project
    .DESCRIPTION
        This function creates a new Toggl project in a Toggl workspace.

        If no workspace is given, it defaults to your default workspace confgured in config.json.
    .EXAMPLE

        #//TODO / WIP
        New-TogglProject -Name "CoolProg" -PassThru | Start-TogglEntry "Organizational stuff" -Tags ("orga", "TogglMaint", "PoSh")
        Get-JiraIssue -Assignee currentUser | New-TogglProject
    .INPUTS
    .OUTPUTS
        [Toggl.Projcet] returns the created project if PassThru is switched.
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param (
        # Identifies the projects workspace
        [Parameter(Mandatory = $false)]
        [int] $workspaceId = $primaryWorkspace,

        # The name of your new project
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $Name, #name binding

        # The customer to create the project for
        [Parameter(Mandatory = $true)] #Consider defaulting to a def customer and make it optional
        [int] $CustomerId,

        # Color to identify your new project
        [Parameter(Mandatory = $false)]
        [Toggl.Color] $Color #Enum? Class? int? String?...
    )

    begin {
    }

    process {
    }

    end {
    }
}
