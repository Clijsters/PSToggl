# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Set-TogglProject" {
        $answer = @{
            data = @{
                #TODO
            }
        }

        Mock Invoke-TogglMethod {
            #return $answer
        }


        It "Calls Invoke-TogglMethod with the correct url" {
            #Set-TogglProject
            #Assert-MockCalled -CommandName "Invoke-TogglMethod" # -ParameterFilter {$UrlSuffix -eq ""}
        }

        It "Changes the name if -NewName is passed" {}
        It "Is there anything else to change on a workspace??" {}


    }
}
