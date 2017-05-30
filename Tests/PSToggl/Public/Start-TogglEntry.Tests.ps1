# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Start-TogglEntry" {
        It "Calls Invoke-TogglMethod" {
            Mock -CommandName "Invoke-TogglMethod" {}
            #Get-TogglEntry | Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {}
        }

        It "Uses Get-TogglProject if a Project Name is given" {
            Mock -CommandName "Get-TogglProject" {}
            #Get-TogglEntry | Assert-MockCalles -CommandName "ConvertTo-TogglEntry" -ParameterFilter {}
        }

        It "Creates new Tags if necessary" {
        }
    }
}
