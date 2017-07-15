# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "ConvertTo-TogglTask" {
        $sampleInput = @{
            name              = "Test Task";
            wid               = 123;
            pid               = 123;
            uid               = 123;
            active            = $true;
            estimated_seconds = 0;
            at                = [datetime]::Now;
        }
        $out = $sampleInput | ConvertTo-TogglTask

        It "Converts a HashTable to a PSCustomObject" {
            $out.GetType().Name | Should Be "PSCustomObject"
        }

        It "Sets TypeName to PSToggl.Task" {
            $out.PSObject.TypeNames[0] | Should Be "PSToggl.Task"
        }

        foreach ($k in $sampleInput.Keys) {
            # TODO: Will convert property names in future
            It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
                $out.PSObject.Members[$k].Value | Should Be $sampleInput.Item($k)
            }
        }

    }
}
