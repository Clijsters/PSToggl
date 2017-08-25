# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Write-RunningTogglEntry" {
        Mock Write-Host {}
        $exampleObject = @{
            description = "Test entry";
            id          = 654;
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


        It "Uses Get-TogglEntry to obtain the currently running entry" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName Get-TogglEntry -Scope It -ParameterFilter {$Current}
        }

        It "Uses Write-Host to write an entry if one is running" {
            Write-RunningTogglEntry
            Assert-MockCalled -CommandName Write-Host -Scope It
        }

        It "Writes a newline when -ForPromt is not set" {

            Write-RunningTogglEntry
            Assert-MockCalled -CommandName Write-Host -Scope It -ParameterFilter {$Object -like "*`n*"}

        }

        It "Does not write a newline when -ForPrompt is set" {
            Write-RunningTogglEntry -ForPrompt
            Assert-MockCalled -CommandName Write-Host -Scope It -ParameterFilter {$Object -notlike "*`n*"}
        }

        It "Writes the Project name if one is set" {
            Write-RunningTogglEntry -ForPrompt
            Assert-MockCalled -CommandName Write-Host -Scope It -ParameterFilter {$Object -like "*dummy*"}
        }

        $exampleObject.pid = $null
        It "Writes the Entry name if no project is set" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName Write-Host -Scope It -ParameterFilter {$Object -like "*Test entry*"}
        }

        $exampleObject.description = $null
        It "Uses placeholder if no description and no project is set" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName Write-Host -Scope It -ParameterFilter {$Object -like "*??*"}
        }

        $exampleObject = $null

        It "Shows a message if no entry is running" {
            Write-RunningTogglEntry
            Assert-MockCalled -CommandName Write-Host -Scope It -ParameterFilter {$Object -eq "No time entry currently running"}
        }

        It "Writes that message to Verbose stream when -ForPrompt is set" {
            Write-RunningTogglEntry -ForPrompt
            Assert-MockCalled -CommandName Write-Verbose -Scope It
        }
    }
}
