function Get-TogglProject {
    <#
    .SYNOPSIS
        Gets Toggl Projects

    .DESCRIPTION
        This cmdlet queries the Toggl API against projects. If no parameter is given, it returns all projects in the current Workspace.
        You can search projects by its name (with wildcards) or by its id.
        To filter for other properties (e.g. "billable", "at"), pipe the result to Where-Object.

        You can pipe any PSToggl object which belongs to a project to this cmdlet, like:
        * Workspace: Queries the given Workspace id for Projects.
        * Client: Returns projects whose cid matches the id of the piped object
        * User (This is a special case, a user contains its projects as array. If not, will query for it and return)

    .PARAMETER Name
        The name of the project to return. You will be able to use wildcards soon.

    .PARAMETER Workspace
        Defaults to your primary Workspace (configured for this module). If provided, this cmdlet returns Projects for the given Workspace.

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
        [Parameter(Mandatory = $false, ParameterSetName = "byName")]
        [string] $Name = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "byName")]
        [Parameter(ParameterSetName = "byObject")]
        [string] $Workspace = $TogglConfiguration.Api.Workspace,

        # InputObject
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "byObject")]
        [psobject] $InputObject
    )

    $projects = Invoke-TogglMethod -UrlSuffix "workspaces/$($Workspace)/projects"

    if ($InputObject) {
        #foreach Obj in InputObject
        switch ($InputObject.psobject.GetTypeName[0]) {
            #The thins is, one can use parametersetnames to identify the provided elements soon in begin{}
            "PSToggl.Client" {  }
            "PSToggl.Workspace" {  }
            "PSToggl.User" {  }
            Default {}
        }
    }
    else {
        if ($Name) {
            $projects = $projects | Where-Object name -Like $Name
        }
        return $projects | ConvertTo-TogglProject
    }
}
