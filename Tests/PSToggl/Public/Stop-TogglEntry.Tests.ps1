# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Stop-TogglEntry" {
        $exampleObject = @{
            description = "Test entry";
            id          = 654;
            wid         = 123;
            pid         = 123;
            tid         = 123;
            start       = [datetime]::Now;
            #stop        = [datetime]::Now;
            duration    = -30;
            at          = [datetime]::Now;
        }

        Mock Write-Warning {}
        Mock Write-Verbose {}
        Mock Get-TogglEntry { return $exampleObject }
        #Mock Get-TogglProject { return @{ name = "dummy" } }
        Mock Invoke-TogglMethod {}

        It "Obtains the current running entry using Get-TogglEntry" {
            Stop-TogglEntry | Should Not Throw
            Assert-MockCalled -CommandName "Get-TogglEntry" -Scope It -Exactly -Times 1 -ParameterFilter { $Current }
            Assert-MockCalled -CommandName "Write-Warning" -Scope It -Exactly -Times 0
        }

        It "Stops the running entry using a PUT request on the entry id" {
            Stop-TogglEntry | Should Not Throw
            Assert-MockCalled -CommandName "Get-TogglEntry" -Scope It -Exactly -Times 1 -ParameterFilter { $UrlSuffix -eq "time_entries/654/stop" -and $Method -eq "PUT" }
        }

        It "Doesn't try to stop an entry if none is running, writes a warning, but doesn't throw" {
            $exampleObject = null
            Stop-TogglEntry | Should Not Throw #Shouldn't it?
            Assert-MockCalled -CommandName "Write-Warning" -Scope It -ParameterFilter { $InputObject -like "*no entry*" }
            Assert-MockCalled -CommandName "Invoke-TogglMethod" -Scope It -Exactly -Times 0

        }

    }
}
