# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "New-TogglEntry" {

        Mock Invoke-TogglMethod {
            param(
                [string] $UrlSuffix,
                [psobject] $InputObject,
                [ValidateSet("GET", "POST", "PUT", "DELETE")]
                [String] $Method
            )
        }

        Mock ConvertTo-TogglEntry {
            #return "dummy"
        }

        It "Calls Invoke-TogglMethod" {
        }

        It "Calculates `$Duration based on -Start and -End" {
        }

        It "Calculates `$Start based on -Duration and -End" {
        }

        It "Converts -ProjectName to a valid pid" {
        }

        It "Returns the newly created TogglEntry" {
        }

        It "Accepts PSToggl.Project as InputObject and sets the corresponding pid" {
        }

        It "Accepts TogglEntry as InputObject and uses it as a template" {
        }
    }
}
