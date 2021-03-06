Write-Host 'Creating new module manifest'
$moduleName = "PSToggl"
$ModuleManifestPath = "$PSScriptRoot\..\PSToggl\PSToggl.psd1" | Resolve-Path
$ModuleManifest     = Get-Content $ModuleManifestPath -Raw
[regex]::replace($ModuleManifest,'(ModuleVersion = )(.*)',"`$1'$env:APPVEYOR_BUILD_VERSION'") | Out-File -LiteralPath $ModuleManifestPath

if ($env:APPVEYOR_REPO_BRANCH -notmatch 'master')
{
    Write-Host "Finished testing of branch: $env:APPVEYOR_REPO_BRANCH - Exiting"
    exit;
}

$ModulePath = Split-Path $pwd
Write-Host "Adding $ModulePath to 'psmodulepath' PATH variable"
$env:psmodulepath += ';' + $ModulePath

Write-Host 'Publishing module to Powershell Gallery'
Publish-Module -Name $moduleName -NuGetApiKey $env:NuGetApiKey
