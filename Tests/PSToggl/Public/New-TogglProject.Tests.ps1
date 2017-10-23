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
            return @{
                data = @{name = $InputObject.project.name}
            }
        }

        #Mock Write-Verbose {}

        Mock ConvertTo-TogglProject {
            $InputObject.name
        }

        It "Properly handles -Verbose" {
            {New-TogglProject -Name "Test Project" -Verbose} | Should Not Throw
        }

        $dummyWid = 4567
        It "Sets wid to `$Workspace ($dummyWid)" {
            {New-TogglProject -Name "Test Project" -Workspace $dummyWid} | Should Not Throw
            Assert-MockCalled -CommandName Invoke-TogglMethod -Scope It -ParameterFilter {$InputObject.project.wid -eq $dummyWid}
        }

        It "Calls Invoke-TogglMethod with a project object" {
            {New-TogglProject -Name "Test Project"} | Should Not Throw
            Assert-MockCalled -CommandName Invoke-TogglMethod -Scope It -ParameterFilter {$InputObject.project}
        }

        $dummyCid = 12345
        It "Sets cid to `$CustomerId ($dummyCid)" {
            {New-TogglProject -Name "Test Project" -CustomerId $dummyCid} | Should Not Throw
            Assert-MockCalled -CommandName Invoke-TogglMethod -Scope It -ParameterFilter {$InputObject.project.cid -eq $dummyCid}
        }

        It "Returns the newly created TogglProject" {
            New-TogglProject -Name "Test Project" | Should Be "Test Project"
        }

        It "Accepts `$Name's as Pipeline input and creates a project for each name" {
            {@("Project1", "Project2") | New-TogglProject} | Should Not Throw
            Assert-MockCalled -CommandName Invoke-TogglMethod -Times 1 -Scope It -ParameterFilter {$InputObject.project.Name -eq "Project1"}
            Assert-MockCalled -CommandName Invoke-TogglMethod -Times 1 -Scope It -ParameterFilter {$InputObject.project.Name -eq "Project2"}
        }
        <#
        It "Accepts PSToggl.Customer as InputObject and sets the corresponding pid" {
            {New-TogglProject -Name "Test Project"} | Should Not Throw
        }

        It "Accepts PSToggl.Entry as InputObject and sets the pid of that to the newly created one" {
            {New-TogglProject -Name "Test Project"} | Should Not Throw
        }

        It "Accepts PSToggl.Workspace as InputObject and uses the wid" {
            {New-TogglProject -Name "Test Project"} | Should Not Throw
        }
#>
    }
}
