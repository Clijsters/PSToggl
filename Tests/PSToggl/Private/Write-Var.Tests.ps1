# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "Write-Var" {
        $testVar = "Anton"
        Mock Write-Debug {}

        It "Writes the name of testVar to Debug" {
            Write-Var testVar | Assert-MockCalled -CommandName "Write-Debug" -ParameterFilter {$message -like "*testVar*"}
        }

        It "Writes the value of testVar to Debug" {
            Write-Var testVar | Assert-MockCalled -CommandName "Write-Debug" -ParameterFilter {$message -like "*Anton*"}
        }

        It "Writes its own message to Debug if the variable cannot be resolved" {
            $pref = $ErrorActionPreference
            $ErrorActionPreference = "SilentlyContinue"
            Write-Var testVsdfar | Assert-MockCalled -CommandName "Write-Debug" -ParameterFilter {$message -like "*Could not be resolved*"}
            $ErrorActionPreference = $pref
        }

    }
}
