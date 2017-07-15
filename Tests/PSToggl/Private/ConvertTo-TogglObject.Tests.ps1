# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "ConvertTo-TogglObject" {
        $objectConfig = @{
            TypeName = "PSToggl.Project";
            DocUrl   = "";
            Fields   = @(
                @{ name = "id"; required = $false; default = $null; type = [int]; },
                @{ name = "name"; required = $true; default = $null; type = [string]; },
                @{ name = "wid"; required = $true; default = $null; type = [int]; },
                @{ name = "cid"; required = $false; default = $null; type = [int]; },
                @{ name = "active"; required = $true; default = $true; type = [bool]; },
                @{ name = "is_private"; required = $true; default = $true; type = [bool]; },
                @{ name = "at"; required = $true; default = $null; type = [datetime]; },
                @{ name = "color"; required = $true; default = $null; type = [int]; }
            );
        };

        $sampleInput = @{
            name  = "asdf";
            wid   = 123;
            cid   = 123;
            at    = [datetime]::Now;
            color = 2;
        }

        $out = $sampleInput | ConvertTo-TogglObject -ObjectConfig $objectConfig

        It "Sets TypeName to '$($objectConfig.TypeName)'" {
            $out.PSObject.TypeNames[0] | Should Be $objectConfig.TypeName
        }

        foreach ($k in $sampleInput.Keys) {
            It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
                $out.PSObject.Members[$k].Value | Should Be $sampleInput.Item($k)
            }
        }

        foreach ($field in ($objectConfig.Fields | Where-Object {-not ($_.name -in $sampleInput.Keys)})) {
            It "sets not provided field $($field.name) to default value '$($field.default)'" {
                $out.PSObject.Members[$field.name].Value | Should Be $field.default
            }
        }

        It "Throws an error if a mandatory fields are missing" {
            $t = $sampleInput
            $t.name = $null
            {ConvertTo-TogglObject -InputObject $t -ObjectConfig $objectConfig} | Should Throw
        }
    }
}
