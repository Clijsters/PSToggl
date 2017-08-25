function Start-TogglEntry() {
    <#
    .Synopsis
        Starts a new Time Entry

    .DESCRIPTION
        This function starts a new Toggl time entry.

        This includes:
         - Stopping the current Entry
         - Creating a new Entry with the given information.
         - Optionally add a duration to it.

    .EXAMPLE
        Start-TogglEntry "Meeting"

        Starts a new Time Entry with the Description "Meeting". This will be the most common way to use Start-TogglEntry.
    .EXAMPLE

        Start-TogglEntry -Description "Coding" -ProjectName "MyProj"

    .EXAMPLE
        Start-TogglEntry -Description "Test" -Tags ("Tag1","Tag2") -ProjectName "Offsets"

        ///TODO: WIP
            Get-TogglProject *Intern* | Start-TogglEntry "Meeting"

    .INPUTS
        This function does not accept pipeline Input yet

    .OUTPUTS
        PSToggl.Entry
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

    $entry = @{
        time_entry = [psobject]@{
            description  = $Description;
            tags         = [array]$Tags;
            #duration     = ($Duration * 60);
            created_with = "PoSh";
        };
    }

    if ($ProjectName) {
        $projects = Get-TogglProject -Name $ProjectName
        if ($projects) {
            $projId = $projects[0].id
        }
        if ($projId -gt 0) {
            $entry.time_entry.pid = $projId
        }
        else {
            Throw "No project id found for `"$ProjectName`""
        }
    }

    #TODO: Check for errors and make a TogglEntry out of it
    return (Invoke-TogglMethod -UrlSuffix "time_entries/start" -InputObject $entry).data
}
