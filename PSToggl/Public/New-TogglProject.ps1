function New-TogglProject {
    <#
    .Synopsis
        Creates a new Toggl Project

    .DESCRIPTION
        This function creates a new Toggl Project in a Workspace.

        If no workspace is given, it defaults to your default workspace configured in ~/.PSToggl or $TogglConfiguration

    .EXAMPLE
        New-TogglProject -Name "CoolStuff" -PassThru | Start-TogglEntry "Organizational stuff" -Tags ("orga", "TogglMaint", "PoSh")

        Creates a new Toggl Project, passes it through

    .EXAMPLE
        Get-JiraIssue -Assignee currentUser | New-TogglProject -ErrorAction String
        Creates a Toggl Project for each Jira Issue assigned to you.

        The following is currently not supported but will be the suggested way...
        Tip: If you want to copy the model idea behind JIRA, create a timer Template for each Issue and a Project for each Project.

    .INPUTS
    .OUTPUTS
        PSToggl.Project
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
