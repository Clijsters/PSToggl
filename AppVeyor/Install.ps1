# Some credits of this file go to Javy de Koning

Write-Host 'Installing Dependencies...' -ForegroundColor Yellow

$packageProvider = Install-PackageProvider -Name NuGet -Force
Write-Host " - NuGet version '$($packageProvider.version)'"

Write-Host ' - Pester'
Install-Module -Name Pester -Repository PSGallery -Force

Write-Host ' - PSScriptAnalyzer'
Install-Module PSScriptAnalyzer -Repository PSGallery -force

Write-Host "Done."

Write-Host "Installing PSToggl..." -ForegroundColor Yellow
Get-Location

Import-LocalizedData -BindingVariable TogglConfiguration -BaseDirectory $PSScriptRoot\..\PSToggl\Private -FileName InternalConfiguration.psd1
$TogglConfiguration.User = @{
    APIKey    = "12aef345c55974deb6";
    Workspace = "1258621"
}

Import-Module "$PSScriptRoot\..\PSToggl\PSToggl.psm1"
