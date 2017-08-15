# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglTag" {
        $exampleObject = @{foo = "bar"}

        Mock Invoke-TogglMethod {
            return $exampleObject
        }

        Mock ConvertTo-TogglTag {
            return "dummy"
        }

        It "Calls Invoke-TogglMethod with the configured Workspace Id and correct UrlSuffix" {
            Get-TogglTag
            Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {$UrlSuffix -eq "workspaces/" + $TogglConfiguration.User.Workspace + "/tags"}
        }


        It "Calls ConvertTo-TogglTag and supplies the object returned by Invoke-TogglMethod" {
            Get-TogglTag
            Assert-MockCalled -CommandName "ConvertTo-TogglTag" -ParameterFilter {$InputObject -eq $exampleObject}
        }

        It "Returns the entries converted with ConvertTo-TogglTag" {
            Get-TogglTag | Should Be "dummy"
        }

    }
}
