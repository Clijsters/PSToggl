function Get-TogglProject {
	<#
    .Synopsis
		Receives Toggl Projects based on their name
    .DESCRIPTION 
    .EXAMPLE
    .INPUTS
    .OUTPUTS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
		[string] $ProjectName = $null,

        [Parameter(Mandatory=$false)]
		[string] $Workspace = $primaryWorkspace
    )
    $projects = Invoke-TogglMethod -UrlSuffix "workspaces/$($Workspace)/projects"

    If (!$projects) {
        Throw [System.Exception]::new("No Toggl projects found")
    } else {
		if ($ProjectName) {
            $projects = $projects | Where-Object name -Like $ProjectName
        }
        return $projects
    }
}
