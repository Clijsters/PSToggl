# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Invoke-TogglMethod" {
        $restAnswer = @{
            code = 404;
            data = @{
                test = $true;
                foo = "bar";
            }
        }
        Mock Invoke-RestMethod {
            return $restAnswer
        }

        It "Defaults to GET Request for empty InputObject" {
            Invoke-TogglMethod -UrlSuffix "/test"
            Assert-MockCalled -CommandName "Invoke-RestMethod" -ParameterFilter {$Method -eq "GET"}
        }

        It "Defaults to POST Request if an InputObject is given" {
            Invoke-TogglMethod -UrlSuffix "/test" -InputObject @{ key = "val" }
            Assert-MockCalled -CommandName "Invoke-RestMethod" -ParameterFilter {$Method -eq "POST"}
        }

        It "Returns the whole API Response object if it succeeded" {
            Invoke-TogglMethod -UrlSuffix "/test" | Should Be $restAnswer
        }
    }
}
