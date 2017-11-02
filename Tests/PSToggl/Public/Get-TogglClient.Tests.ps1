# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglClient" {
        $exampleObject = @{
            id    = 1;
            name  = "Test Client";
            wid   = 123;
            at    = [datetime]::Now;
            notes = "Some note";
        }

        $exampleProject = @{
            name  = "asdf";
            id = 123;
            wid   = 123;
            cid   = 123;
            at    = [datetime]::Now;
            color = 2;
        }

        $multipleObjects = New-Object -TypeName System.Collections.ArrayList
        0..9 | ForEach-Object {
            $obj = $exampleObject.psobject.Copy()
            $obj.id = $obj.id + $_
            $multipleObjects.Add($obj)
        }

        Mock Get-TogglProject {
            return $exampleProject
        }

        Mock Invoke-TogglMethod {
            param(
                [string] $UrlSuffix,
                [psobject] $InputObject,
                [ValidateSet("GET", "POST", "PUT", "DELETE")]
                [String] $Method
            )
            if ($UrlSuffix -like "*projects*") {
                return $exampleProject
            } else {
                return $exampleObject
            }
        }

        Mock ConvertTo-TogglClient {}
        Mock Write-Verbose {}

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

        It "Takes `$InputObject of type `"PSToggl.Entry`" and properly filters for related clients" {
            @{
                description = "Test entry";
                wid         = 123;
                pid         = 123;
                tid         = 123;
                start       = [datetime]::Now;
                stop        = [datetime]::Now;
                duration    = 0;
                at          = [datetime]::Now;
            } | ConvertTo-TogglEntry | Get-TogglClient
        }

        It "Takes `$InputObject of type `"PSToggl.Project`" and properly filters for related clients" {}

    }
}
