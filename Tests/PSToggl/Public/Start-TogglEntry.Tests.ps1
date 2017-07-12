# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Start-TogglEntry" {
        Mock Invoke-TogglMethod {}
        Mock Get-TogglProject {
            return @(
                @{
                    name = "test";
                    id = 123
                },
                @{
                    name = "test2";
                    id = 456
                }
            )
        }

        It "Calls Invoke-TogglMethod with the correct url" {
            Start-TogglEntry
            Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {$UrlSuffix -eq "time_entries/start"}
        }

        It "Uses Get-TogglProject if a Project Name is given" {
            Start-TogglEntry -Description "Test" -ProjectName "Test Project"
            Assert-MockCalled -CommandName "Get-TogglProject" -ParameterFilter {$Name -eq "Test Project"}
        }

        It "Uses the first matching projects id to start an Entry on a given project" {
            Start-TogglEntry -Description "Test" -ProjectName "Test Project"
            Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {$InputObject.time_entry.pid -eq 123}
        }

        It "Creates new Tags if necessary" {
            Mock Get-TogglTag {
                return @("meeting", "technical")
            }
            Start-TogglEntry "cool meeting" -Tags @("meeting", "time-wasting")
        }
    }
}
