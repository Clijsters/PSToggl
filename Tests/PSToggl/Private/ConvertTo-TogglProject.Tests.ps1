# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
Describe "ConvertTo-TogglProject" {
    $sampleInput = @{name="asdf";wid=123;cid=123;at=[datetime]::Now;color=2;}
    $out = $sampleInput | ConvertTo-TogglProject
    It "Converts a HashTable to a PSCustomObject" {
        $out.GetType().Name | Should Be "PSCustomObject"
    }

    It "Sets TypeName to PSToggl.Project" {
        $out.PSObject.TypeNames[0] | Should Be "PSToggl.Project"
    }

    foreach ($k in $sampleInput.Keys) {
        # TODO: Will convert property names in future
        It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
            $out.PSObject.Members[$k].Value | Should Be $sampleInput.Item($k)
        }
    }

}
}
