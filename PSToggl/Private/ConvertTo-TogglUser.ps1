function ConvertTo-TogglUser {
    [CmdletBinding()]
    param(
        # A (set of) HashTable or PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
        $InputObject
    )

    begin {
        $fields = @(
            @{ name = "id";             required = $false;   default = $null;    type = [int]; },
            @{ name = "api_token";      required = $true;    default = $null;    type = [string]; },
            @{ name = "default_wid";    required = $true;    default = $null;    type = [int]; },
            @{ name = "email";          required = $false;   default = $null;    type = [string]; },
            @{ name = "jquery_timeofday_format";required = $false;   default = $null;    type = [string]; },
            @{ name = "jquery_date_format";     required = $false;   default = $null;    type = [string]; },
            @{ name = "timeofday_format";       required = $false;   default = $null;    type = [string]; },
            @{ name = "date_format";            required = $false;   default = $null;    type = [string]; },
            @{ name = "store_start_and_stop_time";  required = $false;   default = $null;    type = [bool]; },
            @{ name = "beginning_of_week";          required = $false;   default = $null;    type = [int]; }, # 0-6, Sun=0
            @{ name = "language";           required = $false;   default = $null;    type = [string]; },
            @{ name = "image_url";          required = $false;   default = $null;    type = [string]; },
            @{ name = "sidebar_piechart";   required = $false;   default = $null;    type = [bool]; },
            @{ name = "at";                 required = $true;    default = $null;    type = [datetime]; },
            ####
            @{ name = "new_blog_post";      required = $false;   default = $null;    type = [psobject]; },
            ####
            @{ name = "send_product_emails";  required = $false;   default = $null;    type = [bool]; },
            @{ name = "send_weekly_reports";  required = $false;   default = $null;    type = [bool]; },
            @{ name = "send_timer_notifications";  required = $false;   default = $null;    type = [bool]; },
            @{ name = "openid_enabled";     required = $false;   default = $null;    type = [bool]; },
            @{ name = "timezone";           required = $false;   default = $null;    type = [string]; }
        )
    }

    process {
        foreach ($item in $InputObject) {
            $object = @{}
            if ($item.GetType().Name -eq "HashTable") {
                $input = New-Object -TypeName psobject -Property $item
            } else {
                $input = $item
            }

            foreach ($field in $fields) {
                $inputField = $input.PSObject.Members[$field.name].Value
                if ($null -ne $inputField) {
                    $object[$field.name] = $inputField
                } else {
                    if ($null -ne $field.default) {
                        $object[$field.name] = $field.default
                    } elseif ($field.required) {
                        throw "Property `"$($field.name)`" is required"
                    }
                }
            }

            $result = New-Object -TypeName psobject -Property $object
            $result.PSObject.TypeNames.Insert(0, "PSToggl.User")
            $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
                Write-Output $this.name
            }
            $result | Add-Member -MemberType ScriptMethod -Name "Delete" -Force -Value {
                # Invoke-TogglMethod ...
            }
            Write-Output $result
        }
    }
}
