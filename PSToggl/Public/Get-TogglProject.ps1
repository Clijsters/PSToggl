function Get-TogglProject {
    <#
    .Synopsis
        Receives Toggl Projects
    .DESCRIPTION
        This cmdlet queries the Toggl API against projects. If no parameter is given, it returns all accessible projects.
        You can search projects by its name (with wildcards) or by its id (without).
        To filter for other properties (e.g. billable, at), pipe the result to Where-Object.
        You can pipe any PSToggl object which belongs to a project to this cmdlet, like:
        * Workspace: returns projects whose wid mathes the id of the piped object
        * Client: returns projects whose cid matches the id of the piped object
        * User (This is a special case, a user contains its projects as array. If not, will query for it and return)
    .EXAMPLE
        Get-TogglProject -ProjectName "*awesome*"
        Get-TogglProject | Where-Object billable
        Get-TogglClient -name "Customer" | Get-TogglProject
    .INPUTS
        System.Management.Automation.PSObject
            PSToggl.Client
            PSToggl.Workspace
            PStoggl.User
    .OUTPUTS
        System.Management.Automation.PSObject
            PsToggl.Project
    #>
    [CmdletBinding()]
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
