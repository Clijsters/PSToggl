function Get-TogglProject {
    <#
    .SYNOPSIS
        Gets Toggl Projects

    .DESCRIPTION
        This Cmdlet queries the Toggl API against projects. If no parameter is given, it returns all projects in the current Workspace.
        You can search projects by its name (with wildcards) or by its id.
        To filter for other properties (e.g. "billable", "at"), pipe the result to Where-Object.

        You can pipe any PSToggl object which belongs to a project to this Cmdlet, like:
        * Workspace: Queries the given Workspace id for Projects.
        * Client: Returns projects whose cid matches the id of the piped object
        * Entry: Returns the Timers project
        * User (This is a special case, a user contains its projects as array. If not, will query for it and return)

    .PARAMETER Name
        The name of the project to return. You will be able to use wildcards soon.

    .PARAMETER Workspace
        Defaults to your primary Workspace (configured for this module). If provided, this Cmdlet returns Projects for the given Workspace.

    .INPUTS
        PSToggl.Client
        PSToggl.Workspace
        PSToggl.Entry
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
        Version:        1.2
        Author:         Clijsters
        Creation Date:  03.04.2017
        Purpose/Change: Accept PSToggl.Workspace
    #>
    [CmdletBinding(DefaultParametersetName = "all")]
    [OutputType("PSToggl.Project")]
    param(
        [Parameter(ParameterSetName = "byName")]
        [string] $Name = $null,

        [Parameter(Mandatory = $false)]
        [int] $Workspace = $TogglConfiguration.User.Workspace,

        [Parameter(ParameterSetName = "byId")]
        [int] $Id,

        # InputObject
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "byObject")]
        [psobject[]] $InputObject
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
        $projects = Invoke-TogglMethod -UrlSuffix "workspaces/$($Workspace)/projects"
    }

    Process {
        switch ($PsCmdlet.ParameterSetName) {
            "byObject" {
                Write-Verbose "Processing InputObject of type `"$($InputObject[0].psobject.TypeNames[0])`""
                switch ($InputObject[0].psobject.TypeNames[0]) {
                    "PSToggl.Entry" {
                        $projectLambda = {
                            param($obj)
                            if ($obj.wid -ne $Workspace) {
                                $projects = Get-TogglProject -Workspace $obj.wid
                            }
                            $projects | Where-Object {$_.id -EQ $obj.pid}
                        }
                    }
                    "PSToggl.Project" {
                        $projectLambda = {
                            param($obj)
                            $obj
                        }
                    }
                    "PSToggl.Client" {
                        $projectLambda = {
                            param($obj)
                            $projects | Where-Object {
                                $_.cid -EQ $obj.id}
                            }
                        }
                    <# As there are no getters, this code is never reached and therefore untested
                        "PSToggl.Workspace" {
                        $projectLambda = {
                            param($obj)
                            $projects | Where-Object {$_.wid -EQ $obj.id}
                        }
                    }
                    "PSToggl.User" {
                        $projectLambda = {
                            param($obj)
                            Throw "Not implemented"
                        }
                    }
                    #>
                    Default {
                        Throw "Not implemented"
                    }
                }
                $tmpList = New-Object -TypeName System.Collections.ArrayList
                foreach ($item in $InputObject) {
                    $projectLambda.Invoke($item) | Foreach-Object {$tmpList.Add($_) | Out-Null}
                }
                $projects = $tmpList
            }
            "byName" {
                $projects = $projects | Where-Object {$_.Name -Like $Name}
            }
            "byId" {
                $projects = $projects | Where-Object {$_.Id -EQ $Id}
            }
            "all" {
                $projects = $projects
            }
        }
    }

    End {
        return $projects | ConvertTo-TogglProject
    }
}
