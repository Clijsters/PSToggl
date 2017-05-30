# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "ConvertTo-TogglObject" {
        It "Creates a Client Object with all necessary attributes" {

        }
        It "Creates a Task Object with all necessary attributes" {

        }
        It "Creates an Entry Object with all necessary attributes" {

        }
    }
}
