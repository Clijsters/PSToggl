# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Get-TogglProject" {
        $exampleProject = @{
            name  = "asdf";
            wid   = 123;
            cid   = 123;
            at    = [datetime]::Now;
            color = 2;
        }

        $exampleEntry = @{
            description = "Test entry";
            wid         = 123;
            pid         = 123;
            tid         = 123;
            start       = [datetime]::Now;
            stop        = [datetime]::Now;
            duration    = 0;
            at          = [datetime]::Now;
        }

        Mock Invoke-TogglMethod {
            return $exampleProject
        }

        Mock ConvertTo-TogglProject {
            return "dummy"
        }

        Context "Behavior" {
            It "Calls Invoke-TogglMethod" {
                Get-TogglProject
                Assert-MockCalled -CommandName "Invoke-TogglMethod" -ParameterFilter {$UrlSuffix -eq "workspaces/" + $TogglConfiguration.User.Workspace + "/projects"}
            }

            It "Calls ConvertTo-TogglProject and supplies the object returned by Invoke-TogglMethod" {
                Get-TogglProject
                Assert-MockCalled -CommandName "ConvertTo-TogglProject" -ParameterFilter {$InputObject -eq $exampleProject}
            }

            It "Returns the entries converted with ConvertTo-TogglProject" {
                Get-TogglProject | Should Be "dummy"
            }

            It "Uses provided -Workspace" {
                {Get-TogglProject -Workspace 654 -Name "asdf"} | Should Not Throw
                Assert-MockCalled -CommandName Invoke-TogglMethod -ParameterFilter {$UrlSuffix -eq "workspaces/654/projects"}
            }
        }

        Context "ParameterSets" {
            It "Finds Projects byName (with wildcard)" {
                Get-TogglProject -Name "*df*"
            }

            It "Finds projects byId" {
                Get-TogglProject -Id 123
            }
        }

        Context "Inputs" {
            It "Accepts PSToggl.Project as pipeline input" {
                $element = New-Object -TypeName psobject -Property $exampleProject
                $element.PSObject.TypeNames.Insert(0, "PSToggl.Project")
                #TODO
                {$element | Get-TogglProject} | Should Not Throw
            }

            It "Accepts PSToggl.Entry as pipeline input" {
                $element = New-Object -TypeName psobject -Property $exampleEntry
                $element.PSObject.TypeNames.Insert(0, "PSToggl.Entry")
                #TODO
                {$element | Get-TogglProject} | Should Not Throw
            }

            It "Throws an exception if unsupported objects are passed" {
                $element = New-Object -TypeName psobject -Property $exampleProject
                $element.PSObject.TypeNames.Insert(0, "PSToggl.Foo")
                #TODO
                {$element | Get-TogglProject} | Should Throw "Not implemented" #TODO Change naming
            }
        }

    }
}
