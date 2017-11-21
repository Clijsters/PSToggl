function Get-TogglClient {
    <#
    .SYNOPSIS
        Gets Toggl Clients

    .DESCRIPTION
        This Cmdlet queries the Toggl API for Clients. It returns all Clients (for your default workspace), if no parameter is given.
        You can search thwm by its name, workspace, notes or by compatible objects...

        You can pipe any PSToggl object which - in any way - belongs to a client, to this Cmdlet:
        * Workspace: Returns Clients for the given Workspace.
        * Project: Returns clients matching the Project's cid
        * Time Entry: Gets the client by retrieving its project and filtering by the projects cid.
        * (WIP) User: Not supported yet.

    .PARAMETER Name
        If given, this Cmdlet returns all clients matching the given name. Wildcards allowed.

    .PARAMETER Workspace
        Workspace to search clients in. If not provided, Get-TogglClient will use your default workspace.

    .PARAMETER Notes
        Search for clients matching the given Notes string. Wildcards allowed.

    .INPUTS
        PSToggl.Workspace
        PSToggl.Project
        PSToggl.Entry
        ?PSToggl.User?

    .OUTPUTS
        PSToggl.Client

    .EXAMPLE
        Get-TogglClient "John Doe"

    .EXAMPLE
        Get-TogglClient -Name "Anton" | Get-TogglEntry

    .NOTES
        Version:        1.0
        Author:         Clijsters
        Creation Date:  10.10.2017
        Purpose/Change: Initial script development
    #>
    [CmdletBinding(DefaultParametersetName = "all")]
    [OutputType("PSToggl.Client")]
    param (
        # Client's name
        [Parameter(ParameterSetName = "byName", Position = 1)]
        [string] $Name,

        # Client's name
        [Parameter(ParameterSetName = "byId", Position = 1)]
        [string] $Id,

        # InputObject
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "byObject", Position = 1)]
        [psobject[]] $InputObject,

        # Workspace id
        [Parameter(Mandatory = $false)]
        [string] $Workspace = $TogglConfiguration.User.Workspace,

        # Optional Notes field
        [Parameter(Mandatory = $false)]
        [string] $Notes
    )

    begin {
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
        $allClients = Invoke-TogglMethod -UrlSuffix "workspaces/$($Workspace)/clients"
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            "byObject" {
                Write-Verbose "Processing InputObject of type `"$($InputObject[0].psobject.TypeNames[0])`""
                switch ($InputObject[0].psobject.TypeNames[0]) {
                    # TODO
                    "PSToggl.Entry" {
                        $clientsLambda = {
                            param($obj)
                            Write-Verbose "Obtaining Project for PSToggl.Entry"
                            $proj = $obj | Get-TogglProject
                            Write-Verbose "Filter for Project's cid"
                            $allClients | Where-Object {$_.id -eq $proj.cid}
                        }
                    }
                    "PSToggl.Project" {
                        $clientsLambda = {
                            param($obj)
                            $allClients | Where-Object {$_.id -eq $obj.cid}
                        }
                    }
                    Default {
                        Throw "This InputObject type is not (yet) implemented"
                    }
                }
                $tmpList = New-Object -TypeName System.Collections.ArrayList
                foreach ($item in $InputObject) {
                    $clientsLambda.Invoke($item) | Foreach-Object {$tmpList.Add($_) | Out-Null}
                }
                $clients = $tmpList
            }
            "byName" {
                $clients = $allClients | Where-Object {$_.Name -Like $Name}
            }
            "byId" {
                $clients = $allClients | Where-Object {$_.Id -eq $Id}
            }
            "all" {
                $clients = $allClients
            }
        }
    }

    end {
        return $clients | ConvertTo-TogglClient
    }
}
