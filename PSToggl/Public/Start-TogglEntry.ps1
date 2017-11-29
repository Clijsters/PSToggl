function Start-TogglEntry() {
    <#
    .Synopsis
        Starts a new Time Entry

    .DESCRIPTION
        This function starts a new Toggl time entry.

        This includes:
         - Stopping the current Entry
         - Creating a new Entry with the given information.
         (TODO)- Optionally add a duration to it.

    .INPUTS
        This function does not accept pipeline Input yet

    .OUTPUTS
        PSToggl.Entry

    .EXAMPLE
        Start-TogglEntry "Meeting"

        Starts a new Time Entry with the Description "Meeting". This will be the most common way to use Start-TogglEntry.

    .EXAMPLE
        Start-TogglEntry -Description "Test" -Tags ("Tag1","Tag2") -ProjectName "Offsets"

        ///TODO: WIP
            Get-TogglProject *Intern* | Start-TogglEntry "Meeting"

   .EXAMPLE
        Start-TogglEntry -Description "Coding" -ProjectName "MyProj"

    .NOTES
        Version:        1.0
        Author:         Clijsters
        Creation Date:  03.04.2017
        Purpose/Change: Initial script development
     #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param(
        # The Description and title of your new entry
        [Parameter(Mandatory = $false)]
        [String] $Description = "",

        # The name of the Project to assign this entry to.
        [Parameter(Mandatory = $false)]
        [String] $ProjectName = $null,

        # Tags to identify related entries
        [Parameter(Mandatory = $false)]
        [String[]] $Tags

        # Duration in minutes
        #[Parameter(Mandatory = $false)]
        #[int] $Duration = 0
    )

    New-Item function::local:Write-Verbose -Value (
        New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
    ).NewBoundScriptBlock {
        param($Message)
        if ($verbose) {
            & $verb -Message "=>$fixedName $Message" -Verbose
        } else {
           & $verb -Message "=>$fixedName $Message"
        }
    } | Write-Verbose

    $entry = @{
        time_entry = [psobject]@{
            description  = $Description;
            tags         = [array]$Tags;
            #duration     = ($Duration * 60);
            created_with = "PoSh";
        };
    }

    if ($ProjectName) {
        Write-Verbose "ProjectName given. Searching for -Name=$ProjectName"
        $projects = Get-TogglProject -Name $ProjectName
        if ($projects) {
            Write-Verbose "Found $($projects.count) projects. Selecting 1st one."
            $projId = $projects[0].id
        }
        if ($projId -gt 0) {
            Write-Verbose "`$projId=$projId"
            $entry.time_entry.pid = $projId
        }
        else {
            Throw "No project id found for `"$ProjectName`""
        }
    }

    (Invoke-TogglMethod -UrlSuffix "time_entries/start" -InputObject $entry).data | ConvertTo-TogglEntry
}
