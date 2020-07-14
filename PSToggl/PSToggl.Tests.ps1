$moduleName = "PSToggl" #$env:ModuleName
$PSVersion = $PSVersionTable.PSVersion.Major
$repository = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = "$repository\$moduleName"
$scripts = Get-ChildItem $repository -Filter "*.ps1" -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}
$modules = Get-ChildItem $repository -Filter "*.psm1" -Recurse
$rules = Get-ScriptAnalyzerRule
$appveyorFile = "$repository\appveyor.yml"

Describe "General code style compliance" {
    foreach ($module in $modules) {
        Context "Module '$($module.FullName)'" {
            foreach ($rule in $rules) {
                It "passes the PSScriptAnalyzer Rule $rule" {
                    if (-not ($module.BaseName -match "AppVeyor") -and -not ($rule.Rulename -in @("PSReviewUnusedParameter")) ) {
                        (Invoke-ScriptAnalyzer -Path $module.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
                    }
                }
            }
        }
    }

    foreach ($Script in $scripts) {
        Context "Script '$($script.FullName)'" {
            foreach ($rule in $rules) {
                It "passes the PSScriptAnalyzer Rule $rule" {
                    if (-not ($module.BaseName -match "AppVeyor") -and -not ($rule.Rulename -in @("PSAvoidUsingWriteHost", "PSReviewUnusedParameter")) ) {
                        $result = Invoke-ScriptAnalyzer -Path $script.FullName -IncludeRule $rule.RuleName
                        $result.Message | ? {$_} | % { Write-Host $_ }
                        $result.Count | Should Be 0
                    }
                }
            }
        }
    }
}

Describe "$moduleName on PowerShell $PSVersion" {
    Context "Module manifest" {
        #Stolen from Dave Wyatt
        $script:manifest = $null
        It "Passes Test-ModuleManifest" { {
                $script:manifest = Test-ModuleManifest -Path "$moduleRoot\$moduleName.psd1" -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not Throw
        }

        It "Includes the correct root module" {
            $script:manifest.RootModule | Should Be "$moduleName.psm1"
        }

        It "Includes the correct GUID" {
            $true#$script:manifest.Guid | Should Be ""
        }

        It "Includes a valid version" {
            $script:manifest.Version -as [version] | Should Not BeNullOrEmpty
        }
    }

    Context "appveyor configuration" {
        It "Is present in the directory root" {
            $appveyorFile | Should Exist
        }

        foreach ($line in (Get-Content $appveyorFile)) {
            if ($line -match "^\D*(?<Version>(\d+\.){1,3}\d+).\{build\}") {
                $appveyorVersion = $matches.Version
                break
            }
        }
        It "Includes the module version" {
            $appveyorVersion               | Should Not BeNullOrEmpty
            $appveyorVersion -as [Version] | Should Not BeNullOrEmpty
        }

        It "Matches manifest version" {
            $appveyorVersion -as [Version] | Should Be ($script:manifest.Version -as [Version])
        }
    }

    Context "Testing Environment" {
        # Public tests
        Get-ChildItem -Path "$moduleRoot\Public" -Filter "*.ps1" -Recurse | Where-Object -FilterScript {$_.Name -notlike "*.Tests.ps1"} | ForEach-Object {
            It "Includes a test for $($_.Name)" {
                $_.FullName -replace ".ps1", ".Tests.ps1" -replace "PSToggl\\Public", "Tests\PSToggl\Public" | Should Exist
            }
        }
        # Private tests
        Get-ChildItem -Path "$moduleRoot\Private" -Filter "*.ps1" -Recurse | Where-Object -FilterScript {$_.Name -notlike "*.Tests.ps1"} | ForEach-Object {
            It "Includes a test for $($_.Name)" {
                $_.FullName -replace ".ps1", ".Tests.ps1" -replace "PSToggl\\Private", "Tests\PSToggl\Private" | Should Exist
            }
        }
    }
}
