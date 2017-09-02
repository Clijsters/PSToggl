# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglTag" {
        $exampleObject = @(
            @{name = "foo"; id = 1; wid = 345}
            @{name = "bar"; id = 2; wid = 345}
            @{name = "baz"; id = 3; wid = 345}
        )

        Mock Invoke-TogglMethod {
            return $exampleObject
        }

        Mock ConvertTo-TogglTag {
            foreach ($item in $InputObject) {
                $element = New-Object -TypeName psobject -Property $item
                $element.PSObject.TypeNames.Insert(0, "PSToggl.Tag")
                return $element
            }
        }

        It "Calls Invoke-TogglMethod with the correct UrlSuffix" {
            {Get-TogglTag} | Should Not Throw
            Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {$UrlSuffix -eq "workspaces/" + $TogglConfiguration.User.Workspace + "/tags"}
        }

        It "Switches the workspace if -Workspace is passed" {
            {Get-TogglTag -Workspace 1234} | Should Not Throw
            Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {$UrlSuffix -eq "workspaces/1234/tags"}
        }

        It "Filters tags by its -Name" {
            (Get-TogglTag -Name "foo") | Where-Object {$_.id -eq 2} | Should BeNullOrEmpty
            (Get-TogglTag -Name "foo") | Where-Object {$_.id -eq 1} | Should Not BeNullOrEmpty
        }


        It "Calls ConvertTo-TogglTag and supplies the object returned by Invoke-TogglMethod" {
            {Get-TogglTag} | Should Not Throw
            Assert-MockCalled -CommandName "ConvertTo-TogglTag" -ParameterFilter {$InputObject -eq $exampleObject[0]}
        }

        It "Returns the entries converted with ConvertTo-TogglTag" {
            (Get-TogglTag)[0].PSObject.TypeNames[0] | Should Be "PSToggl.Tag"
        }

    }
}
