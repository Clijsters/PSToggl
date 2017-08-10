# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglProject" {
        $exampleObject = @{foo = "bar"}

        Mock Invoke-TogglMethod {
            return $exampleObject
        }

        Mock ConvertTo-TogglProject {
            return "dummy"
        }

        It "Calls Invoke-TogglMethod" {
            Get-TogglProject
            Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {$UrlSuffix -eq "workspaces/" + $TogglConfiguration.User.Workspace + "/projects"}
        }

        It "Calls ConvertTo-TogglProject and supplies the object returned by Invoke-TogglMethod" {
            Get-TogglProject
            Assert-MockCalled -CommandName "ConvertTo-TogglProject" -ParameterFilter {$InputObject -eq $exampleObject}
        }

        It "Returns the entries converted with ConvertTo-TogglProject" {
            Get-TogglProject | Should Be "dummy"
        }

    }
}
