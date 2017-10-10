# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglClient" {
        $exampleObject = @{
        }

        Mock Invoke-TogglMethod {
            param(
                [string] $UrlSuffix,
                [psobject] $InputObject,
                [ValidateSet("GET", "POST", "PUT", "DELETE")]
                [String] $Method
            )
                return $exampleObject
        }

        Mock ConvertTo-TogglClient {
            $InputObject | ConvertTo-TogglObject -ObjectConfig $TogglConfiguration.ObjectTypes.Entry
        }

        It "Calls Invoke-TogglMethod" {
            {Get-TogglClient} | Should Not Throw
            Assert-MockCalled -CommandName "Invoke-TogglMethod"
        }

        It "Calls ConvertTo-TogglClient and supplies the object returned by Invoke-TogglMethod" {
            {Get-TogglClient} | Should Not Throw
            Assert-MockCalled -CommandName "ConvertTo-TogglClient" -ParameterFilter {$InputObject -eq $exampleObject}
        }

        It "Returns the entries converted with ConvertTo-TogglClient" {
            (Get-TogglClient).description | Should Be $exampleObject.description
        }
    }
}
