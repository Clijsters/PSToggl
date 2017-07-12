# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Start-TogglEntry" {
        It "Calls Invoke-TogglMethod" {
            Mock Invoke-TogglMethod {}
            Start-TogglEntry
            Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {}
        }

        It "Uses Get-TogglProject if a Project Name is given" {
            Mock Get-TogglProject {}
            Start-TogglEntry "Test" -Project "Test project"
            Assert-MockCalles -CommandName "Get-ToglProject" -ParameterFilter {$Name -eq "Test"}
        }

        It "Creates new Tags if necessary" {
            Mock Get-TogglTag {
                return @("meeting", "technical")
            }
            Start-TogglEntry "cool meeting" -Tags @("meeting", "time-wasting")
        }
    }
}
