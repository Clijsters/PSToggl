# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Write-RunningTogglEntry" {
        It "Uses Write-Host to write an entry if one is running" {

        }

        It "Shows a message if none is running" {

        }
    # To be continued...
    }
}
