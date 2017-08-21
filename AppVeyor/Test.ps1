Write-Host "Current working directory: $pwd"
$testResultsFile = '.\TestsResults.xml'
$cc = Get-ChildItem ..\PSToggl -Recurse -File -Include *.ps1 -Exclude *.Tests.ps1
$result = Invoke-Pester -Script ..\ -OutputFormat NUnitXml -OutputFile $testResultsFile -PassThru -CodeCoverage $cc

if ($env:APPVEYOR_JOB_ID) {
    Write-Host 'Uploading results'
    (New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $testResultsFile))
    Write-Host "Deleting Result file"
    Remove-Item $testResultsFile -Force -ErrorAction SilentlyContinue
}

if (($result.FailedCount -gt 0) -or ($result.PassedCount -eq 0)) {
    throw "$($result.FailedCount) tests failed."
} else {
    Write-Host 'All tests passed' -ForegroundColor Green
}
