# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Write-RunningTogglEntry" {
        Mock Write-Host {}
        $exampleObject = @{
            description = "Test entry";
            wid         = 123;
            pid         = 123;
            tid         = 123;
            start       = [datetime]::Now;
            stop        = [datetime]::Now;
            duration    = 0;
            at          = [datetime]::Now;
        }

        Mock Write-Verbose {}
        Mock Get-TogglEntry {
            return $exampleObject
        }
        Mock Get-TogglProject {
            return @{
                name = "dummy"
            }
        }

        It "Uses Write-Host to write an entry if one is running" {
            Write-RunningTogglEntry
            Assert-MockCalled -CommandName "Write-Host"
        }

        It "Does not write a newline when -ForPrompt is set" {
            Write-RunningTogglEntry -ForPrompt
            Assert-MockCalled -CommandName "Write-Host" -ParameterFilter {$Object -notcontains "`n"}

        }
        <#
        It "Writes the Project name if one is set" {
            Write-RunningTogglEntry -ForPrompt
            Assert-MockCalled -CommandName "Write-Host" -ParameterFilter {$Object -contains "dummy"}

        }
#>
        It "Writes the Entry name if no project is set" {

        }

        $exampleObject = $null

        It "Shows a message if no entry is running" {
            Write-RunningTogglEntry
            Assert-MockCalled -CommandName "Write-Host"
        }

        It "Writes that message to Verbose stream when -ForPrompt is set" {
            Write-RunningTogglEntry -ForPrompt
            Assert-MockCalled -CommandName "Write-Verbose"
        }
    }
}
