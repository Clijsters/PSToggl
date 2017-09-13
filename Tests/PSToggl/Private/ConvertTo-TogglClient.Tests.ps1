# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "ConvertTo-TogglClient" {
        $sampleInput = @{
            name  = "Test Client";
            wid   = 123;
            at    = [datetime]::Now;
            notes = "Some note";
        }
        $out = $sampleInput | ConvertTo-TogglClient

        Context "Behavior" {
            It "Converts a HashTable to a PSCustomObject" {
                $out.GetType().Name | Should Be "PSCustomObject"
            }

            It "Sets TypeName to PSToggl.Client" {
                $out.PSObject.TypeNames[0] | Should Be "PSToggl.Client"
            }
        }

        Context "Fields" {
            foreach ($k in $sampleInput.Keys) {
                # TODO: Will convert property names in future
                It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
                    $out.PSObject.Members[$k].Value.toString() | Should Be $sampleInput.Item($k).tostring()
                }
            }
        }

        Context "Methods" {
            It "Adds a running ToString() Method" {
                {$out.ToString()} | Should Not Throw
            }
            It "Adds a running Delete() Method" {
                {$out.Delete()} | Should Not Throw
            }
        }

    }
}
