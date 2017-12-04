<#
    .SYNOPSIS
        Updates a hash table with the Unique file lines
        Structure:
        RootTable.[FileKey].[SubTable].[Line]
#>
function Add-UniqueFileLineToTable {
    [CmdletBinding()]
    param
    (
        #The table to update
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable] $FileLine,

        #The list of Command from pester to update the table based on
        [Parameter(Mandatory = $true)]
        [Object] $Command,

        #The path to the root of the repo.  This part of the path will not be included in the report.  Needed to normalize all the reports.
        [Parameter(Mandatory = $true)]
        [String] $RepoRoot,

        #The path of the file to write the report to.
        [Parameter(Mandatory = $true)]
        [String] $TableName
    )
    New-Item function::local:Write-Verbose -Value (
        New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
    ).NewBoundScriptBlock{
        param($Message)
        if ($verbose) {
            & $verb -Message "=>CCI\$fixedName $Message" -Verbose
        } else {
           & $verb -Message "=>CCI\$fixedName $Message"
        }
    } | Write-Verbose

    # file paths need to be relative to repo root when querying GIT
    Push-Location -LiteralPath $RepoRoot
    try {
        Write-Verbose "running git ls-files"

        # Get the list of files as Git sees them
        $fileKeys = & git.exe ls-files

        Write-Verbose "fileKeys: $fileKeys"

        # Populate the sub-table
        foreach ($command in $Command) {
            #Find the file as Git sees it
            $file = $command.File
            Write-Verbose "Processing file `"$file`""
            $file = $file -ireplace [regex]::Escape($RepoRoot), ""
            Write-Debug "`$file after replace: $file"
            $fileKey = $file.TrimStart('\').replace('\', '/')
            Write-Debug "`$fileKey trimmed: $fileKey"
            $fileKey = $fileKeys.where{$_ -like $fileKey}
            Write-Debug "`$fileKey transformed: $fileKey"

            if ($null -eq $fileKey) {
                Write-Warning -Message "Unexpected error: `$fileKey was null"
                continue
            }
            elseif ($fileKey.Count -gt 1) {
                Write-Verbose -Message "More than one git file matched file ($file): $($fileKey -join ', ')"
                continue
            } elseif ($fileKey.Count -lt 1) {
                Write-Warning -Message "No file matched $file!"
                continue
            }

            $fileKey = $fileKey | Select-Object -First 1

            if (!$FileLine.ContainsKey($fileKey)) {
                $FileLine.add($fileKey, @{ $TableName = @{}})
            }

            if (!$FileLine.$fileKey.ContainsKey($TableName)) {
                $FileLine.$fileKey.Add($TableName, @{})
            }

            $lines = $FileLine.($fileKey).$TableName
            $lineKey = $($command.line)
            if (!$lines.ContainsKey($lineKey)) {
                $lines.Add($lineKey, 1)
            }
            else {
                $lines.$lineKey ++
            }
        }
    }
    finally {
        Pop-Location
    }
}

<#
  .SYNOPSIS
  Tests if the specified property is a CodeCoverage object
  For use in a ValidateScript attribute

  .PARAMETER CodeCoverage
  The CodeCoverage property of the output of Invoke-Pester with the -PassThru and -CodeCoverage options

#>
function Test-CodeCoverage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Object] $CodeCoverage
    )
    New-Item function::local:Write-Verbose -Value (
        New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
    ).NewBoundScriptBlock{
        param($Message)
        if ($verbose) {
            & $verb -Message "=>CCI\$fixedName $Message" -Verbose
        } else {
           & $verb -Message "=>CCI\$fixedName $Message"
        }
    } | Write-Verbose

    if (!($CodeCoverage | Get-Member -Name MissedCommands)) {
        Write-Verbose "`$CodeCoverage doesn't have Member `"MissedCommands`". Throwing exception."
        throw 'Must be a Pester CodeCoverage object'
    }

    return $true
}

<#
  .SYNOPSIS
  Exports a Pester CodeCoverage report as a CodeCov.io json report

  .PARAMETER CodeCoverage
  The CodeCoverage property of the output of Invoke-Pester with the -PassThru and -CodeCoverage options

  .PARAMETER RepoRoot
  The path to the root of the repo.  This part of the path will not be included in the report.  Needed to normalize all the reports.

  .PARAMETER Path
  The path of the file to write the report to.
#>
function Export-CodeCovIoJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-CodeCoverage -CodeCoverage $_})]
        [Object] $CodeCoverage,

        [Parameter(Mandatory = $true)]
        [String] $RepoRoot,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $Path = (Join-Path -Path $env:TEMP -ChildPath 'codeCov.json')
    )
    New-Item function::local:Write-Verbose -Value (
        New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
    ).NewBoundScriptBlock{
        param($Message)
        if ($verbose) {
            & $verb -Message "=>CCI\$fixedName $Message" -Verbose
        } else {
           & $verb -Message "=>CCI\$fixedName $Message"
        }
    } | Write-Verbose

    Write-Verbose -Message "RepoRoot: $RepoRoot"

    # Get a list of all unique files
    $files = @()
    foreach ($file in ($CodeCoverage.MissedCommands | Select-Object -ExpandProperty File -Unique)) {
        if ($files -notcontains $file) {
            $files += $file
        }
    }

    foreach ($file in ($CodeCoverage.HitCommands | Select-Object -ExpandProperty File -Unique)) {
        if ($files -notcontains $file) {
            $files += $file
        }
    }

    Write-Verbose "files: $files"

    # A table of the file key then a sub-tables of `misses` and `hits` lines.
    $FileLine = @{}

    # define common parameters
    $addUniqueFileLineParams = @{
        FileLine = $FileLine
        RepoRoo  = $RepoRoot
    }

    <#
        Basically indexing all the hit and miss lines by file and line.
        Populate the misses sub-table
    #>
    Add-UniqueFileLineToTable -Command $CodeCoverage.MissedCommands -TableName 'misses' @addUniqueFileLineParams

    Write-Verbose "FileLine: $FileLine"

    # Populate the hits sub-table
    Add-UniqueFileLineToTable -Command $CodeCoverage.HitCommands -TableName 'hits' @addUniqueFileLineParams
    Write-Verbose "FileLine: $FileLine"

    # Create the results structure
    $resultLineData = @{}
    $resultMessages = @{}
    $result = @{
        coverage = $resultLineData
        messages = $resultMessages
    }

    foreach ($file in $FileLine.Keys) {
        Write-Verbose -Message "summarizing for file: $file"

        # Get the hits, if they exist
        $hits = @{}
        if ($FileLine.$file.ContainsKey('hits')) {
            $hits = $FileLine.$file.hits
        }

        # Get the misses, if they exist
        $misses = @{}
        if ($FileLine.$file.ContainsKey('misses')) {
            $misses = $FileLine.$file.misses
        }

        Write-Verbose -Message "fileKeys: $($FileLine.$file.Keys)"
        $max = $hits.Keys | Sort-Object -Descending | Select-Object -First 1
        $maxMissLine = $misses.Keys | Sort-Object -Descending | Select-Object -First 1

        <#
            if max missed line is greater than maxed hit line
            used max missed line as the max line
        #>
        if ($maxMissLine -gt $max) {
            $max = $maxMissLine
        }

        $lineData = @()
        $messages = @{}

        <#
            produce the results
            start at line 0 per codecov doc
        #>
        for ($lineNumber = 0; $lineNumber -le $max; $lineNumber++) {
            $hitInfo = $null
            $missInfo = $null
            switch ($true) {
                # Hit
                ($hits.ContainsKey($lineNumber) -and ! $misses.ContainsKey($lineNumber)) {
                    Write-Verbose -Message "Got code coverage hit at $lineNumber"
                    $lineData += "$($hits.$lineNumber)"
                }

                # Miss
                ($misses.ContainsKey($lineNumber) -and ! $hits.ContainsKey($lineNumber)) {
                    Write-Verbose -Message "Got code coverage miss at $lineNumber"
                    $lineData += '0'
                }

                # Partial Hit
                ($misses.ContainsKey($lineNumber) -and $hits.ContainsKey($lineNumber)) {
                    Write-Verbose -Message "Got code coverage partial at $lineNumber"

                    $missInfo = $misses.$lineNumber
                    $hitInfo = $hits.$lineNumber
                    $lineData += "$hitInfo/$($hitInfo+$missInfo)"
                }

                # Non-Code Line
                (!$misses.ContainsKey($lineNumber) -and !$hits.ContainsKey($lineNumber)) {
                    Write-Verbose -Message "Got non-code at $lineNumber"

                    <#
                        If I put an actual null in an array ConvertTo-Json just leaves it out
                        I'll put this string in and clean it up later.
                    #>
                    $lineData += '!null!'
                }

                default {
                    throw "Unexpected error occured generating codeCov.io report for $file at line $lineNumber with hits: $($hits.ContainsKey($lineNumber)) and misses: $($misses.ContainsKey($lineNumber))"
                }
            }
        }

        $resultLineData.Add($file, $lineData)
        $resultMessages.add($file, $messages)
    }

    Write-Verbose -Message "Branch: $Branch"

    $json = $result | ConvertTo-Json
    $json = $json.Replace('"!null!"', 'null')

    $json | Out-File -Encoding ascii -LiteralPath $Path -Force
    return $Path
}

<#
  .SYNOPSIS
  Uploads a CodeCov.io code coverage report

  .PARAMETER Path
  The path to the code coverage report (gcov not supported)
#>
function Invoke-UploadCoveCoveIoReport {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String] $Path,
        [Parameter(Mandatory = $false)]
        [String] $Token
    )
    New-Item function::local:Write-Verbose -Value (
        New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
    ).NewBoundScriptBlock{
        param($Message)
        if ($verbose) {
            & $verb -Message "=>CCI\$fixedName $Message" -Verbose
        } else {
           & $verb -Message "=>CCI\$fixedName $Message"
        }
    } | Write-Verbose

    $resolvedResultFile = (Resolve-Path -Path $Path).ProviderPath
    Write-Verbose "resolvedResultFile: $resolvedResultFile"

    if ($env:APPVEYOR_REPO_BRANCH) {
        Push-AppVeyorArtifact $resolvedResultFile
    }

    #Assume codecov is reachable
    if ($Token) {
        $uploadResults = codecov -f $resolvedResultFile -t $Token
    } else {
        $uploadResults = codecov -f $resolvedResultFile
    }

    Write-Verbose "uploadResults:"
    Write-Verbose $uploadResults

    if ($env:APPVEYOR_REPO_BRANCH) {
        $logPath = (Join-Path -Path $env:TEMP -ChildPath 'codeCovUpload.log')
        $uploadResults | Out-File -Encoding ascii -LiteralPath $logPath -Force
        $resolvedLogPath = (Resolve-Path -Path $logPath).ProviderPath
        Write-Verbose "resolvedLogPath: $resolvedLogPath"
        Get-Content $resolvedLogPath | Write-Verbose
        Push-AppVeyorArtifact $resolvedLogPath
    }
}
