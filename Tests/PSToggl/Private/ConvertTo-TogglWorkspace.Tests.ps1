# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path)
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "ConvertTo-TogglWorkspace" {
        $sampleInput = @{
            name                            = "Sample Workspace";
            premium                         = $false;
            admin                           = $true;
            default_currency                = "EUR";
            only_admins_may_create_projects = $false;
            only_admins_see_billable_rates  = $true;
            rounding                        = 1; #Possible: -1, 0, 1
            rounding_minutes                = -1;
            at                              = [datetime]::Now;
            logo_url                        = "https://placekitten.com/100/100"
        }
        $out = $sampleInput | ConvertTo-TogglWorkspace

        It "Converts a HashTable to a PSCustomObject" {
            $out.GetType().Name | Should Be "PSCustomObject"
        }

        It "Sets TypeName to PSToggl.Workspace" {
            $out.PSObject.TypeNames[0] | Should Be "PSToggl.Workspace"
        }

        foreach ($k in $sampleInput.Keys) {
            # TODO: Will convert property names in future
            It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
                $out.PSObject.Members[$k].Value | Should Be $sampleInput.Item($k)
            }
        }

    }
}
