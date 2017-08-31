Write-Host "Current working directory: $pwd"
$testResultsFile = '.\TestsResults.xml'
$cc = Get-ChildItem ..\PSToggl -Recurse -File -Include *.ps1 -Exclude @("*.Tests.ps1", "Test.ps1", "Install.ps1", "Deploy.ps1")
$result = Invoke-Pester -Script ..\ -OutputFormat NUnitXml -OutputFile $testResultsFile -PassThru -CodeCoverage $cc

if ($env:APPVEYOR_JOB_ID) {
    Write-Host 'Uploading results to AppVeyor'
    (New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $testResultsFile))
    Write-Host "Deleting Result file"
    Remove-Item $testResultsFile -Force -ErrorAction SilentlyContinue
}

$repoRoot = if ($env:APPVEYOR_BUILD_FOLDER) {$env:APPVEYOR_BUILD_FOLDER} else {"$PSScriptRoot\.." | Resolve-Path}
if ($result.CodeCoverage) {
    Import-Module -Name (Join-Path -Path $repoRoot -ChildPath '.codecovio\CodeCovio.psm1')
    $jsonPath = Export-CodeCovIoJson -CodeCoverage $result.CodeCoverage -repoRoot $repoRoot
    Write-Host "CodeCov Results:"
    Get-Content $jsonPath | ConvertFrom-Json
    if ($env:APPVEYOR_JOB_ID) {
        Write-Host 'Uploading CodeCoverage to CodeCov.io...'
        Invoke-UploadCoveCoveIoReport -Path $jsonPath
    }
}

if (($result.FailedCount -gt 0) -or ($result.PassedCount -eq 0)) {
    throw "$($result.FailedCount) tests failed."
}
else {
    Write-Host 'All tests passed' -ForegroundColor Green
}
