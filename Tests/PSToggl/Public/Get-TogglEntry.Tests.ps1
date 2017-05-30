# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglEntry" {
        It "Calls Invoke-TogglMethod" {
            Mock -CommandName "Invoke-TogglMethod" {}
            #Get-TogglEntry | Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {}
        }

        It "Calls Convertto-TogglEntry" {
            Mock -CommandName "ConvertTo-TogglEntry" {}
            #Get-TogglEntry | Assert-MockCalles -CommandName "ConvertTo-TogglEntry" -ParameterFilter {}
        }
    }
}
