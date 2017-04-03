function Get-TogglEntry(){
    [CmdletBinding()]
    [OutputType("PSToggl.Entry")]
    param(
        # Get currently running Entry
        [Parameter(Mandatory = $false)]
        [Switch] $Current
    )
    $suffix = if ($Current) {"/current"} else {""}
    $answer = Invoke-TogglMethod -UrlSuffix ("time_entries"+ $suffix)
    Write-Var answer
    return $answer | ConvertTo-TogglEntry
}
