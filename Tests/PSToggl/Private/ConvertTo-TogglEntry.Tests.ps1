# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
Describe "ConvertTo-TogglEntry" {
    $sampleInput = @{
        description = "Test entry";
        wid = 123;
        pid = 123;
        tid = 123;
        start = [datetime]::Now;
        stop = [datetime]::Now;
        duration = 0;
        at = [datetime]::Now;
    }
    $out = $sampleInput | ConvertTo-TogglEntry
    It "Converts a HashTable to a PSCustomObject" {
        $out.GetType().Name | Should Be "PSCustomObject"
    }

    It "Sets TypeName to PSToggl.Entry" {
        $out.PSObject.TypeNames[0] | Should Be "PSToggl.Entry"
    }

    It "Defaults 'created_with' to 'PSToggl'" {
        $out.PSObject.Members["created_with"].Value | Should Be "PSToggl"
    }

    foreach ($k in $sampleInput.Keys) {
        # TODO: Will convert property names in future
        It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
            $out.PSObject.Members[$k].Value | Should Be $sampleInput.Item($k)
        }
    }

}
}
