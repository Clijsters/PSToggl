function Stop-TogglEntry() {
    <#
    .Synopsis
        Stops the running toggl entry, if one is running.

    .DESCRIPTION
        This function stops the running entry, if one is running.

        This involves:
         - If an entry is given, no further checks apply. Stop-TogglEntry will call /stop on that, even when it's not running or existent.
         - If not, the current running entry is obtained using Get-TogglEntry -Current and /stop get's called on that.
         - If -Workspace is provided, the same applies to the Workspace id given.

    .INPUTS
        TBD: An Entry object to stop.
        TBD: A Workspace Object, where the entry may be running.

    .OUTPUTS
        PSToggl.Entry

    .EXAMPLE
        Stop-TogglEntry
        If an Entry is currently running, it will be stopped and returned to the pipeline. If not, a warning is provided.

    .EXAMPLE
        The following features are not supported yet:

        Stop-TogglEntry -Workspace 12345
        Get-TogglEntry -Current | Stop-TogglEntry
        Add-TogglTag "testing" -Current | Stop-TogglEntry

    .NOTES
        Version:        1.0
        Author:         Clijsters
        Creation Date:  07.07.2020
        Purpose/Change: Initial script development
     #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param(
        <#
        # Workspace id
        [Parameter(Mandatory = $false)]
        [string] $Workspace = $TogglConfiguration.User.Workspace,

        # Entry id
        [Parameter(Mandatory = $false)]
        [string] $Entry
        #>
    )

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

    $currentEntry = Get-TogglEntry -Current
    Write-Verbose "Current Entry: $currentEntry"
    #Write-Verbose "Workspace: $Workspace"

    if ($currentEntry) {
        Write-Verbose "Invoking Toggl Method to stop entry $($currentEntry.id)"
        (Invoke-TogglMethod -UrlSuffix "time_entries/$($currentEntry.id)/stop" -Method "PUT").data | ConvertTo-TogglEntry
    }
    else {
        Write-Verbose "currentEntry was null. Exiting."
        Write-Warning "No Entry running."
    }

}
