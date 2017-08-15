# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglEntry" {
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

        Mock Invoke-TogglMethod {
            return $exampleObject
        }

        Mock ConvertTo-TogglEntry {
            return "dummy"
        }

        It "Calls Invoke-TogglMethod" {
            Get-TogglEntry
            Assert-MockCalled -CommandName "Invoke-TogglMethod"
        }

        It "Calls ConvertTo-TogglEntry and supplies the object returned by Invoke-TogglMethod" {
            Get-TogglEntry
            Assert-MockCalled -CommandName "ConvertTo-TogglEntry" -ParameterFilter {$InputObject -eq $exampleObject}
        }

        It "Returns the entries converted with ConvertTo-TogglEntry" {
            Get-TogglEntry | Should Be "dummy"
        }

    }
}
