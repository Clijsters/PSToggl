# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "New-TogglProject" {

        Mock Invoke-TogglMethod {
            param(
                [string] $UrlSuffix,
                [psobject] $InputObject,
                [ValidateSet("GET", "POST", "PUT", "DELETE")]
                [String] $Method
            )
        }

        Mock ConvertTo-TogglProject {
            #return "dummy"
        }

        It "Calls Invoke-TogglMethod" {
        }

        It "Converts -CustomerId to a valid customer object" {
        }

        It "Converts -CustomerName to a valid customer object" {
        }

        It "Returns the newly created TogglProject" {
        }

        It "Accepts PSToggl.Customer as InputObject and sets the corresponding pid" {
        }


        It "Accepts PSToggl.Entry as InputObject and sets the pid of that to the newly created one" {
        }

        It "Accepts PSToggl.Workspace as InputObject and uses the wid" {
        }
    }
}
