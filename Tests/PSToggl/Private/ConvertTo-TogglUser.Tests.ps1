# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Split-Path -Leaf $MyInvocation.MyCommand.Path
. ("$here\$sut").Replace("\Tests\", "\").Replace(".Tests.", ".")

InModuleScope PSToggl {
    Describe "ConvertTo-TogglUser" {
        # Sample Object taken from https://github.com/toggl/toggl_api_docs/blob/master/chapters/users.md
        $sampleInput = @{
            api_token                 = "1971800d4d82861d8f2c1651fea4d212";
            default_wid               = 777;
            email                     = "johnt@swift.com";
            fullname                  = "John Swift";
            jquery_timeofday_format   = "h:i A";
            jquery_date_format        = "m/d/Y";
            timeofday_format          = "h:mm A";
            date_format               = "MM/DD/YYYY";
            store_start_and_stop_time = $true;
            beginning_of_week         = 0;
            language                  = "en_US";
            image_url                 = "https://www.toggl.com/system/avatars/9000/small/open-uri20121116-2767-b1qr8l.png";
            sidebar_piechart          = $false;
            at                        = [datetime]::Now;
            retention                 = 9;
            record_timeline           = $true;
            render_timeline           = $true;
            timeline_enabled          = $true;
            # timeline_experiment = $true;
        }
        $out = $sampleInput | ConvertTo-TogglUser

        Context "Behavior" {
            It "Converts a HashTable to a PSCustomObject" {
                $out.GetType().Name | Should Be "PSCustomObject"
            }

            It "Sets TypeName to PSToggl.User" {
                $out.PSObject.TypeNames[0] | Should Be "PSToggl.User"
            }
        }

        Context "Fields" {
            foreach ($k in $sampleInput.Keys) {
                # TODO: Will convert property names in future
                It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
                    $out.PSObject.Members[$k].Value.toString() | Should Be $sampleInput.Item($k).toString()
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
