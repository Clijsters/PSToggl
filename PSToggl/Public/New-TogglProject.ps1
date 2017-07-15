function New-TogglProject {
    <#
    .Synopsis
        Creates a new Toggl Project

    .DESCRIPTION
        This function creates a new Toggl Project in a Workspace.

        If no workspace is given, it defaults to your default workspace configured in ~/.PSToggl or $TogglConfiguration (or config.json)

    .EXAMPLE
        New-TogglProject "homepage" -CustomerId 12345

        Creates a new Toggl Project for the customer with the id 12345

    .EXAMPLE
        New-TogglProject -Name "CoolStuff" | Start-TogglEntry "Organizational stuff" -Tags ("orga", "TogglMaint", "PoSh")

        Creates a new Toggl Project, passes it through the pipeline and starts an entry on it.

    .EXAMPLE
        The following is currently not supported but will be the suggested way...

        Get-JiraIssue -Query "assignee = currentUser()" | New-TogglProject -CustomerId 12345 -ErrorAction SilentlyContinue

        Creates a Toggl Project for each Jira Issue assigned to you.
        Tip: If you want to copy the model idea behind JIRA, create a timer Template for each Issue and a Project for each Project.
        This one is going to be implemented for PSJira (now JiraPS). You need it installed and configured for it to work.

    .INPUTS
        String[]
        PSToggl.Customer

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
