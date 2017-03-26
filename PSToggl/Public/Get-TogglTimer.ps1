function Get-TogglTimer(){
    [CmdletBinding()]
    [OutputType("PSToggl.Timer")]
    param(
        # Get only current running timer
        [Parameter(Mandatory = $false)]
        [Switch] $Current
    )
    $suffix = if ($Current) {"/current"} else {""}
    $answer = Invoke-TogglMethod -UrlSuffix ("time_entries"+ $suffix)
    Write-Var answer
    return $answer
}
