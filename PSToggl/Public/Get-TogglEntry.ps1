function Get-TogglEntry() {
    <#
    .SYNOPSIS
        Gets Toggl Time Entries

    .DESCRIPTION
        This cmdlet queries the Toggl API for Time Entries (time_entries). It returns all Entries, if no parameter is given.
        You can search Entries by its name, id, project, tags..

        You can pipe any PSToggl object which belongs to a time entry to this cmdlet, like:
        * Workspace: Returns Time Entries for the given Workspace.
        * Project: Returns Time Entries whose pid matches the given project.
        * Client: Returns Time Entries for the given client.
        *(WIP) User (This is a special case, a user contains its time entries as array. If not, will query for it and return))

    .PARAMETER Current
        If set, only the currently running timer is returned. If no time entry is running, it returns nothing.

    .INPUTS
        PSToggl.Workspace
        PSToggl.Project
        PSToggl.Client
        ?PSToggl.User?

    .OUTPUTS
        PSToggl.Entry

    .EXAMPLE
        Get-TogglEntry -Name
        Get-TogglProjcet -Name "Antons Website" | Get-TogglEntry

    .EXAMPLE


    .NOTES
        Version:        1.0
        Author:         Clijsters
        Creation Date:  03.04.2017
        Purpose/Change: Initial script development
    #>
    [CmdletBinding(DefaultParameterSetName = "all")]
    [OutputType("PSToggl.Entry")]
    param(
        # Get currently running Entry
        [Parameter(Position = 1, Mandatory = $false, ParameterSetName = "current")]
        [Switch] $Current,

        # Entry name
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = "byDescription")]
        [string] $Description,

        # Entry name
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = "byObject")]
        [string] $InputObject,

        # Start Date (convert to ISO 8601)
        [Parameter(Position = 1, Mandatory = $false, ParameterSetName = "all")]
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName = "byDescription")]
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName = "byObject")]
        [datetime] $From,

        # End Date
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName = "all")]
        [Parameter(Position = 3, Mandatory = $false, ParameterSetName = "byDescription")]
        [Parameter(Position = 3, Mandatory = $false, ParameterSetName = "byObject")]
        [DateTime] $To
    )

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

    $suffix = if ($Current) {"/current"} else {""}
    $entries = Invoke-TogglMethod -UrlSuffix ("time_entries" + $suffix) -Method "GET"
    if ($Current) {
        return $entries.data | ConvertTo-TogglEntry
    }
    else {
        return $entries | ConvertTo-TogglEntry
    }
}
