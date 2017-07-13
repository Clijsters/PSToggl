function Get-TogglTag() {
    <#
    .SYNOPSIS
        Gets Toggl Tags

    .DESCRIPTION
        This cmdlet queries the Toggl API for tags. If no parameter is given, it just returns an array with all tags in the current workspace.
        You can search tags by it's name and an $InputObject (see below)

        You can pipe any PSToggl object which belongs to a tag to this cmdlet, like:
        * Workspace: Returns all tags for the given Workspace.
        * Project: Returns tas which are used on time entries in this project.
        * Client: Same like Project.
        * Entry: Returns all tags the entry is tagged with.

    .PARAMETER Name
        The name of a tag

    .PARAMETER Workspace
        A Workspace id to fetch tags from

    .INPUTS
        PSToggl.Workspace
        PSToggl.Project
        PSToggl.Client
        PSToggl.Entry

    .OUTPUTS
        PSToggl.Tag

    .EXAMPLE
        Get-TogglTag -Name "meeting"

    .EXAMPLE
        Get-TogglProjcet -Name "Antons Website" | Get-TogglTag

    .NOTES
        Version:        1.0
        Author:         Clijsters
        Creation Date:  03.04.2017
        Purpose/Change: Initial script development
    #>
    [CmdletBinding()]
    [OutputType("PSToggl.Tag")]
    param(
        # the tag name
        [Parameter(Mandatory = $false)]
        [string] $Name,

        # Workspace id
        [Parameter(Mandatory = $false)]
        [string] $Workspace
    )
    $tags = Invoke-TogglMethod -UrlSuffix ("workspaces/" + $TogglConfiguration.User.Workspace + "/tags") -Method "GET"
    Write-Var tags
    return $tags | ConvertTo-TogglTag
}