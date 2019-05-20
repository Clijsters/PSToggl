# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Write-RunningTogglEntry" {
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

        Mock Write-Host {}
        Mock Write-Verbose {}
        Mock Get-TogglEntry { return $exampleObject }
        Mock Get-TogglProject { return @{ name = "dummy" } }

        It "Uses Get-TogglEntry to obtain the currently running entry" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName "Get-TogglEntry" -Scope It -ParameterFilter {$Current}
        }

        It "Writes the currently running entry to the host" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$Object -like "*dummy*"}
        }

        It "Writes a newline when -ForPromt is not set" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$Object -like "*`n*"}
        }

        It "Does not write a newline when -ForPrompt is set" {
            {Write-RunningTogglEntry -ForPrompt} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$Object -notlike "*`n*" -and $NoNewLine}
        }

        It "Writes the Project name if one is set" {
            {Write-RunningTogglEntry -ForPrompt} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$Object -like "*dummy*" -and $Object -notlike "*Test entry*"}
        }

        It "Uses Cyan for project name" {
            {Write-RunningTogglEntry -ForPrompt} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$ForegroundColor -eq [System.ConsoleColor]::Cyan}
        }

        $exampleObject.pid = $null
        It "Writes the Entry name if no project is set" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$Object -like "*Test entry*"}
        }

        $exampleObject.description = "fjlghtoqwpopernjsdfasdmnfaasdfddddasdghgks"

        It "Shortens the description if exceeds length of 35" {
            {Write-RunningTogglEntry -ForPrompt} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$object -like "*..."}
        }

        It "Uses red, if no project is set" {
            {Write-RunningTogglEntry -ForPrompt} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$ForegroundColor -eq [System.ConsoleColor]::Red}
        }

        $exampleObject.description = $null
        It "Uses placeholder if no description and no project is set" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$Object -like "*??*"}
        }

        $exampleObject = $null

        It "Writes a message to the host if no entry is running" {
            {Write-RunningTogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Host" -Scope It -ParameterFilter {$Object -eq "No time entry currently running"}
        }

        It "Writes a message to Verbose stream if no entry is running and -ForPrompt is set" {
            {Write-RunningTogglEntry -ForPrompt} | Should Not Throw
            Assert-MockCalled -CommandName "Write-Verbose" -Scope It
        }
    }
}
