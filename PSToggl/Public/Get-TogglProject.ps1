function Get-TogglProject {
    <#
    .SYNOPSIS
        Gets Toggl Projects

    .DESCRIPTION
        This cmdlet queries the Toggl API against projects. If no parameter is given, it returns all accessible projects.
        You can search projects by its name (with wildcards) or by its id.
        To filter for other properties (e.g. "billable", "at"), pipe the result to Where-Object.

        You can pipe any PSToggl object which belongs to a project to this cmdlet, like:
        * Workspace: returns projects whose wid mathes the id of the piped object
        * Client: returns projects whose cid matches the id of the piped object
        * User (This is a special case, a user contains its projects as array. If not, will query for it and return)

    .PARAMETER Name

    .PARAMETER Workspace

    .INPUTS
        PSToggl.Client
        PSToggl.Workspace
        PStoggl.User

    .OUTPUTS
        PsToggl.Project

    .EXAMPLE
        Get-TogglProject -Name "*awesome*"
        Returns all Projects containing "awesome" in it's name.

    .EXAMPLE
        Get-TogglProject | Where-Object billable
        Uses Where-Object to filter the output to only return projects which are billable.

    .EXAMPLE
        Get-TogglClient -name "Customer" | Get-TogglProject
        Returns all projects for Customer "Customer". Uses Get-TogglProjects Pipe input.

    .EXAMPLE
        Get-TogglClient -name "Pete" | Get-TogglProject | Where-Object active -EQ $True
        Returns all active projects for Client "Pete"

    .NOTES
        Version:        1.0
        Author:         Clijsters
        Creation Date:  03.04.2017
        Purpose/Change: Initial script development
    #>
    [CmdletBinding()]
    [OutputType("PSToggl.Project")]
    param(
        [Parameter(Mandatory=$false)]
        [string] $ProjectName = $null,

        [Parameter(Mandatory=$false)]
        [string] $Workspace = $primaryWorkspace
    )
    $projects = Invoke-TogglMethod -UrlSuffix "workspaces/$($Workspace)/projects"

        if ($ProjectName) {
            $projects = $projects | Where-Object name -Like $ProjectName
        }
        return $projects
}
