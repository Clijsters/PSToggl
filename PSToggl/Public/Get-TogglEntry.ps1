function Get-TogglEntry() {
    <#
    .SYNOPSIS
        Gets Toggl Time Entries

    .DESCRIPTION
        This Cmdlet queries the Toggl API for Time Entries (time_entries). It returns all Entries, if no parameter is given.
        You can search Entries by its Description, specify a Workspace, and a time span.

        You can pipe any PSToggl object which belongs to a time entry to this Cmdlet, like:
        * Workspace: Returns Time Entries for the given Workspace.
        * Project: Returns Time Entries whose pid matches the given project.
        * Client: Returns Time Entries for the given client. (performance hint: Need to obtain all projects to match pid to customer)
        *(WIP) User (This is a special case, a user contains its time entries as array. If not, will query for it and return))

    .PARAMETER Current
        If set, only the currently running timer is returned. If no time entry is running, it returns nothing.

    .PARAMETER Description
        Specifies the Description of the items to return.

    .PARAMETER From
        Will only return Entries created after the specified datetime.

    .PARAMETER To
        Will only return Entries created before the specified datetime.

    .PARAMETER Workspace
        Specifies the Workspace Id. Defaults to your primary Workspace.

    .INPUTS
        PSToggl.Workspace
        PSToggl.Project
        PSToggl.Client
        ?PSToggl.User?

    .OUTPUTS
        PSToggl.Entry

    .EXAMPLE
        Get-TogglEntry -Description "*meet*"

    .EXAMPLE
        Get-TogglEntry -From (Get-Date).AddDays(-4) -To (Get-Date).AddDays(-3)

        Get-TogglEntry -From 01.01.2018 -To 02.01.2018

    .EXAMPLE
        Get-TogglProjcet -Description "Antons Website" | Get-TogglEntry

    .EXAMPLE
        Get-TogglEntry -From 2018/01/01 | Where-Object {$_.tags -contains "mobile"}

    .NOTES
        Version:        1.2
        Author:         Clijsters
        Creation Date:  03.04.2017
        Purpose/Change: Add Support for -From and -To
    #>
    [CmdletBinding(DefaultParameterSetName = "all")]
    [OutputType("PSToggl.Entry")]
    param(
        # Get currently running Entry
        [Parameter(Position = 1, Mandatory = $false, ParameterSetName = "current")]
        [switch] $Current,

        # Entry Description
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = "byDescription")]
        [string] $Description,

        # Entry name
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = "byObject", ValueFromPipeline = $true)]
        [psobject[]] $InputObject,

        # Start Date (convert to ISO 8601)
        [Parameter(Position = 1, Mandatory = $false, ParameterSetName = "all")]
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName = "byDescription")]
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName = "byObject")]
        [datetime] $From,

        # End Date
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName = "all")]
        [Parameter(Position = 3, Mandatory = $false, ParameterSetName = "byDescription")]
        [Parameter(Position = 3, Mandatory = $false, ParameterSetName = "byObject")]
        [datetime] $To = [datetime]::Now,

        # Workspace id
        [Parameter(Mandatory = $false)]
        [string] $Workspace
    )

    Begin {
        New-Item function::local:Write-Verbose -Value (
            New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
        ).NewBoundScriptBlock{
            param($Message)
            if ($verbose) {
                & $verb -Message "=>$fixedName $Message" -Verbose
            }
            else {
                & $verb -Message "=>$fixedName $Message"
            }
        } | Write-Verbose

        Write-Debug "Parameterset: `"$($PsCmdlet.ParameterSetName)`""
        $suffix = if ($Current) {"/current"} else {""}
        Write-Verbose "Querying API for Toggl Entries..."
        Write-Verbose "Suffix: `"$suffix`""
        #TODO Workspaces - not for current?
        if ($From) {
            $timeSpan = @{start_date = Get-Date -Date $From -Format o; end_date = Get-Date -Date $To -Format o}
            $allEntries = Invoke-TogglMethod -UrlSuffix ("time_entries") -Method "GET" -InputObject $timeSpan
        }
        else {
            $allEntries = Invoke-TogglMethod -UrlSuffix ("time_entries" + $suffix) -Method "GET"
        }
        if ($Workspace) {
            #The Toggl API doesn't support obtaining time_entries per workspace (does it?)
            $allEntries = $allEntries | Where-Object {$_.wid -eq $Workspace}
        }
    }

    Process {
        switch ($PsCmdlet.ParameterSetName) {
            "byObject" {
                Write-Verbose "Processing InputObject of type `"$($InputObject[0].psobject.TypeNames[0])`""
                switch ($InputObject[0].psobject.TypeNames[0]) {
                    "PSToggl.Entry" {
                        $entriesLambda = {
                            param($obj)
                            $obj
                        }
                    }
                    "PSToggl.Project" {
                        $entriesLambda = {
                            param($obj)
                            $allEntries | Where-Object {$_.pid -eq $obj.id}
                        }
                    }
                    "PSToggl.Tag" {
                        $entriesLambda = {
                            param($obj)
                            $allEntries | Where-Object {$_.tags -contains $obj.name} #or id??
                        }
                    }
                    "PSToggl.Client" {
                        $entriesLambda = {
                            param($obj)
                            $allProjects = $obj | Get-TogglProject -Workspace $Workspace | Select-Object id
                            $allEntries | Where-Object {$_.pid -in $allProjects}
                        }
                    }
                }
                $tmpList = New-Object -TypeName System.Collections.ArrayList
                foreach ($item in $InputObject) {
                    $entriesLambda.Invoke($item) | Foreach-Object {$tmpList.Add($_) | Out-Null}
                }
                $entries = $tmpList
            }

            "byDescription" {
                $entries = $allEntries | Where-Object {$_.Description -like $Description}
            }

            "all" {
                $entries = $allEntries
            }
            "current" {
                $entries = $allEntries.data
            }
        }
    }


    End {
        return $entries | ConvertTo-TogglEntry
    }
}
