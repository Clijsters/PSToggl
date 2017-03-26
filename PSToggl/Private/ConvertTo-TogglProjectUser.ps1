function ConvertTo-TogglProjectUser {
    [CmdletBinding()]
    [OutputType("PSToggl.ProjectUser")]
    param(
        # A (set of) HashTable or PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
        $InputObject
    )

    begin {
        $fields = @(
            @{ name = "id";     required = $false;   default = $null;    type = [int]; },
            @{ name = "pid";   required = $true;    default = $null;    type = [int]; },
            @{ name = "uid";   required = $true;    default = $null;    type = [int]; },
            @{ name = "wid";    required = $false;    default = $null;    type = [int]; },
            @{ name = "manager";  required = $true;   default = $false;    type = [bool]; },
            @{ name = "rate";   required = $false;    default = $null;    type = [float]; }, # Pro
            @{ name = "at";     required = $false;    default = $null;    type = [datetime]; }
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
            $result.PSObject.TypeNames.Insert(0, "PSToggl.ProjectUser")
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
