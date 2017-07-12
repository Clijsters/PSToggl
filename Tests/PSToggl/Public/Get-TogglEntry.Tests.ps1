# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglEntry" {
        $exampleObject = @{foo = "bar"}
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

        It "Calls Convertto-TogglEntry and supplies the object returned by Invoke-TogglMethod" {
            Get-TogglEntry
            Assert-MockCalled -CommandName "ConvertTo-TogglEntry" -ParameterFilter {$InputObject -eq $exampleObject}
        }

        It "Returns the entries converted with ConvertTo-TogglEntry" {
            Get-TogglEntry | Should Be "dummy"
        }
    }
}
