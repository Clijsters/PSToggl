function ConvertTo-TogglWorkspace {
    [CmdletBinding()]
    param(
        # A (set of) HashTable or PSCustomObject to convert
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [PSObject[]]
        $InputObject
    )

    begin {
        $fields = @(
            @{ name = "id";         required = $false;    default = $null;    type = [int]; },
            @{ name = "name";       required = $true;    default = $null;    type = [string]; },
            @{ name = "premium";    required = $true;    default = $null;    type = [bool]; },
            @{ name = "admin";      required = $true;    default = $null;    type = [bool]; },
            @{ name = "default_hourly_rate"; required = $false;    default = $null;    type = [float]; },
            @{ name = "default_currency";    required = $true;    default = $null;    type = [string]; },
            @{ name = "only_admins_may_create_projects"; required = $true;    default = $null;    type = [bool]; },
            @{ name = "only_admins_see_billable_rates";  required = $true;    default = $null;    type = [bool]; },
            @{ name = "rounding";         required = $true;    default = $null;    type = [int]; },
            @{ name = "rounding_minutes"; required = $true;    default = $null;    type = [int]; },
            @{ name = "at";               required = $true;    default = $null;    type = [datetime]; },
            @{ name = "logo_url";         required = $true;    default = $null;    type = [string]; }
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
                    # TODO: Make it type safe
                    $object[$field.name] = $inputField -as $field.type
                } else {
                    if ($null -ne $field.default) {
                        $object[$field.name] = $field.default -as $field.type
                    } elseif ($field.required) {
                        throw "Property `"$($field.name)`" is required"
                    }
                }
            }

            $result = New-Object -TypeName psobject -Property $object
            $result.PSObject.TypeNames.Insert(0, "PSToggl.Workspace")
            $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
                Write-Output $this.name
            }
            Write-Output $result
        }
    }

}
