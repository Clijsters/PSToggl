function Write-RunningTogglEntry() {
    [CmdletBinding()]
    param(
        # Special case - format for prompt
        [Switch]
        $ForPrompt
    )

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

    $Running = Get-TogglEntry -Current
    $noMsg = "No time entry currently running"
    if ($Running.id -GT 0) {
        Write-Verbose "`$Running.id = $($Running.id)"
        $minutes = [System.Math]::Round((New-TimeSpan -Start ([datetime]($Running.Start)) -End ([datetime]::Now)).TotalMinutes, 0)
        if ($Running.pid) {
            Write-Verbose "`$Running.pid = $($Running.pid)"
            $color = [System.ConsoleColor]::Cyan
            #TODO Pipeline
            $description = (Get-TogglProject -Id $Running.pid -Workspace $Running.wid).Name
        }
        else {
            Write-Verbose "No project id set"
            $color = [System.ConsoleColor]::Red
            $description = if ($Running.description) {$Running.description} else {"??"}
        }

        if ($ForPrompt) {
            Write-Verbose "Preparing Strings for prompt status"
            $start = "["
            $split = " - "
            $end = "]"
        }
        else {
            Write-Verbose "Preparing Strings for standard output"
            $start = "TOGGL: "
            $split = " is running since "
            $end = "`n"
        }

        if ($description.Length -gt 35) {
            $description = $description.Remove(30) + "..."
        }

        Write-Host $start -NoNewline -ForegroundColor Yellow
        Write-Host $description -ForegroundColor $color -NoNewline
        Write-Host "$($split + $minutes)m$($end)" -NoNewline -ForegroundColor Yellow
    }
    elseif (!$ForPrompt) {
        Write-Host $noMsg
    } else {
        Write-Verbose $noMsg
    }
}
