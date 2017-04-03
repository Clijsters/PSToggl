function Start-TogglEntry(){
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

    Start-TogglEntry -Description "Coding" -ProjectName "MyProj"

    Start-TogglEntry -Description "Test" -Tags ("Tag1","Tag2") -ProjectName "Offsets"

    ///TODO: WIP
        Get-TogglProject *Intern* | Start-TogglEntry "Meeting"
    .INPUTS
        This function does not accept pipeline Input yet
    .OUTPUTS
        [object] The Entry created
     #>
    [CmdletBinding()]
    param(
        # The Description and title of your new entry
        [Parameter(Mandatory = $false)]
        [String] $Description = "",

        # Tags to identify related entries
        [Parameter(Mandatory = $false)]
        [String[]] $Tags,

        # The name of the Project to assign this entry to.
        [Parameter(Mandatory = $false)]
        [String] $ProjectName = $null,

        # Optional duration in minutes //TODO: Integration?
        [Parameter(Mandatory = $false)]
        [int] $Duration = 0
    )

    $entry = @{
        time_entry = [psobject]@{
            description = $Description;
            tags = [array]$Tags;
            duration = $Duration*60;
            created_with = "PoSh";
        };
    }

    if ($Duration) {
        $entry.time_entry.duration = $Duration*60
    }

    if ($ProjectName) {
        Write-Var ProjectName
        $projId = (Get-TogglProject -ProjectName $ProjectName)[0].id
        Write-Var projId
        if ($projId -gt 0)  {
            $entry.time_entry.pid = $projId
        } else {
            Throw "No project id found for `"$ProjectName`""
        }
    }

    return (Invoke-TogglMethod -UrlSuffix "time_entries/start" -InputObject $entry).data
}
