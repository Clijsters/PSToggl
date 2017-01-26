function Get-TogglProject(){
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
        [Parameter(Mandatory=$false)][string]$ProjectName = $null,
        [Parameter(Mandatory=$false)][string]$Workspace = $primaryWorkspace, #TODO: Config path
        [Parameter(Mandatory=$false)][switch]$Full = $true #Just to stay compatible
    )
    $projects = Invoke-TogglMethod -UrlSuffix "workspaces/$($Workspace)/projects"

    If ($projects) {
        if ($ProjectName) {
            $projects = $projects | Where-Object name -Like $ProjectName
        }
        # Write-Host "Available Toggl Projects: "
        if ($Full) {
            $projects
        } else {
            $projects | Select-Object id,name,actual_Hours | Format-Table
        }
    } else {
        Write-Error "No Toggl projects found"
    }
}
