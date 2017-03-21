function ConvertTo-TogglTimer {
    [CmdletBinding()]
    param(
        # A (set of) HashTable or PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
        $InputObject
    )

    begin {
        # TODO: Need an extra validator (lambda to be supplied with fields) because special cases like this
        # need them. wid is only required if pid and tid are not supplied.
        $fields = @(
            @{ name = "id";             required = $false;   default = $null;    type = [int]; },
            @{ name = "description";    required = $false;    default = $null;    type = [string]; },
            @{ name = "wid";        required = $true;    default = $null;    type = [int]; },
            @{ name = "pid";        required = $false;   default = $null;    type = [int]; },
            @{ name = "tid";        required = $false;    default = $null;    type = [int]; },
            @{ name = "billable";   required = $true;    default = $null;    type = [bool]; },
            @{ name = "start";      required = $true;    default = $null;    type = [datetime]; },
            @{ name = "stop";       required = $true;    default = $null;    type = [datetime]; },
            @{ name = "duration";   required = $true;    default = $null;    type = [int]; }, # If currently running, its negative.
            @{ name = "created_with";   required = $true;    default = "PSToggl";    type = [string]; },
            @{ name = "tags";           required = $false;    default = $null;    type = [string[]]; },
            @{ name = "duronly";        required = $false;    default = $false;    type = [bool]; },
            @{ name = "at";             required = $true;    default = $null;    type = [datetime]; }
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
            $result.PSObject.TypeNames.Insert(0, "PSToggl.Timer")
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
