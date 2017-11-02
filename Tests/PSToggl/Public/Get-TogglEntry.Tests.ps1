# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglEntry" {
        $exampleObject = @{
            description = "Test entry";
            wid         = 123;
            pid         = 123;
            tid         = 123;
            start       = [datetime]::Now;
            stop        = [datetime]::Now;
            duration    = 0;
            at          = [datetime]::Now;
        }

        $exampleClient = @{
            id    = 1;
            name  = "Test Client";
            wid   = 123;
            at    = [datetime]::Now;
            notes = "Some note";
        }

        Mock Get-TogglProject {

        }

        Mock Invoke-TogglMethod {
            param(
                [string] $UrlSuffix,
                [psobject] $InputObject,
                [ValidateSet("GET", "POST", "PUT", "DELETE")]
                [String] $Method
            )
            if ($UrlSuffix -like "*current*") {
                return @{"data" = $exampleObject}
            }
            else {
                return $exampleObject
            }
        }

        Mock ConvertTo-TogglEntry {
            $InputObject | ConvertTo-TogglObject -ObjectConfig $TogglConfiguration.ObjectTypes.Entry
        }

        It "Calls Invoke-TogglMethod" {
            {Get-TogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName "Invoke-TogglMethod"
        }

        It "Changes the Url when -Current is set" {
            {Get-TogglEntry -Current} | Should Not Throw
            Assert-MockCalled -CommandName Invoke-TogglMethod -ParameterFilter {$UrlSuffix -like "*/current"}
        }

        It "Accepts PSToggl.Client as pipeline input and obtains Projects to filter" {
            $element = New-Object -TypeName psobject -Property $exampleClient
            $element.PSObject.TypeNames.Insert(0, "PSToggl.Client")
            {$element | Get-TogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName Get-TogglProject -Scope It -ParameterFilter {$InputObject -eq $element}
            #TODO
        }

        It "Returns response's data attribute when -Current is set" {
            (Get-TogglEntry -Current).description | Should Be $exampleObject.description
            (Get-TogglEntry -Current).psobject.TypeNames[0] | Should Be "PSToggl.Entry"
        }

        It "Calls ConvertTo-TogglEntry and supplies the object returned by Invoke-TogglMethod" {
            {Get-TogglEntry} | Should Not Throw
            Assert-MockCalled -CommandName "ConvertTo-TogglEntry" -ParameterFilter {$InputObject -eq $exampleObject}
        }

        It "Returns the entries converted with ConvertTo-TogglEntry" {
            (Get-TogglEntry).description | Should Be $exampleObject.description
        }
    }
}
