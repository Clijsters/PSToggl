# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Start-TogglEntry" {
        $answer = @{
            data =  @{
                description = "Test entry";
                wid         = 123;
                pid         = 123;
                tid         = 123;
                start       = [datetime]::Now;
                stop        = [datetime]::Now;
                duration    = 0;
                at          = [datetime]::Now;
            }
        }

        Mock Invoke-TogglMethod {
            return $answer
        }

        Mock Get-TogglProject {
            if ($Name -eq "Test project") {
                return @(
                    @{
                        name = "test";
                        id   = 123
                    },
                    @{
                        name = "test2";
                        id   = 456
                    }
                )
            }
        }

        Mock ConvertTo-TogglEntry {
            return $InputObject
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

        It "Throws an error if no matching project can be found" {
            {Start-TogglEntry -Description "Test" -ProjectName "Test Proj2"} | Should Throw "No project id found for `"Test Proj2`""
        }

        It "Creates new Tags if necessary" {
            Mock Get-TogglTag {
                return @("meeting", "technical")
            }
            Start-TogglEntry "cool meeting" -Tags @("meeting", "time-wasting")
        }

        It "Returns the API's answer" { #TODO: It should definitely return a TogglEntry, not the psobject
            Start-TogglEntry | Should Be $answer.data
            Assert-MockCalled -CommandName ConvertTo-TogglEntry -Times 1 -Scope It
        }

    }
}
