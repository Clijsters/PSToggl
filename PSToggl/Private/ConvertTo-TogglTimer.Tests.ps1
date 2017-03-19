# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

#InModuleScope PSToggl {
Describe "ConvertTo-TogglTimer" {
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
    $out = $sampleInput | ConvertTo-TogglTimer
    It "Converts a HashTable to a PSCustomObject" {
        $out.GetType().Name | Should Be "PSCustomObject"
    }

    It "Sets TypeName to PSToggl.Timer" {
        $out.PSObject.TypeNames[0] | Should Be "PSToggl.Timer"
    }

    It "Defaults 'created_with' to 'PSToggl'" {
        $out.PSObject.Members["created_with"] | Should Be "PSToggl"
    }

    foreach ($k in $sampleInput.Keys) {
        # TODO: Will convert property names in future
        It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
            $out.PSObject.Members[$k].Value | Should Be $sampleInput.Item($k)
        }
    }

}
#}
