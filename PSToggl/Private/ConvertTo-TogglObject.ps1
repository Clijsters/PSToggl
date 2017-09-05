function ConvertTo-TogglObject {
    [CmdletBinding()]
    param(
        # A PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
        $InputObject, <#Alias?#>

        # The field configuration
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ObjectConfig
    )

    begin {
        New-Item function::local:Write-Verbose -Value (
            New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
        ).NewBoundScriptBlock{
            param($Message)
            if ($verbose) {
                & $verb -Message "=>$fixedName $Message" -Verbose
            } else {
               & $verb -Message "=>$fixedName $Message"
            }
        } | Write-Verbose
    }

    ##
    ## TODO TESTS
    ##
    process {
        foreach ($item in $InputObject) {
            Write-Verbose "Processing item: $($item | ConvertTo-Json -Compress)..."
            $item | Write-Verbose
            #todo if item is empty???
            $object = @{}
            if ($item.GetType().Name -eq "HashTable") {
                write-Verbose "`$item is of type HashTable"
                $element = New-Object -TypeName psobject -Property $item
            }
            else {
                Write-Verbose "`$item is of type $($item.GetType().Name)"
                $element = $item
            }

            foreach ($field in $ObjectConfig.Fields) {
                Write-Verbose "`tProcessing field `"$($field.name)`""
                $inputField = $element.PSObject.Members[$field.name].Value
                if ($null -ne $inputField) {
                    $object[$field.name] = $inputField -as $field.type
                }
                else {
                    if ($null -ne $field.default) {
                        Write-Verbose "`tDefaulting null-valued field"
                        $object[$field.name] = $field.default -as $field.type
                    }
                    elseif ($field.required) {
                        throw "Property `"$($field.name)`" is required"
                    }
                }
                Write-Verbose "`tValue: `"$inputField`""
            }

            $result = New-Object -TypeName psobject -Property $object
            Write-Verbose "`tInserting TypeName `"$($ObjectConfig.TypeName)`""
            $result.PSObject.TypeNames.Insert(0, $ObjectConfig.TypeName)
            <#
            IMHO this is a really great idea for dynamic configs. Unfortunately code in psd1 is not allowed.
            //TODO: Create an Issue and let's see if someone has an idea
            foreach ($validator in $objectConfig.Validators) {
                if (-not $validator.callback.invoke($result)) {
                    Write-Debug ($validator.name + " returned false. Throwing ArgumentException with message: " + $validator.message)
                    Throw [System.ArgumentException]::new("Error validating fields: " + $validator.message)
                }
            }
            #>
            Write-Output $result
        }
    }
}
