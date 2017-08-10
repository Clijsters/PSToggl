function Write-RunningTogglEntry() {
    param(
        # Special case - format for prompt
        [Switch]
        $ForPrompt
    )
    $Running = Get-TogglEntry -Current
    if ($Running.id -GT 0) {
        $minutes = [System.Math]::Round((New-TimeSpan -Start ([datetime]($Running.Start)) -End ([datetime]::Now)).TotalMinutes, 0)
        if ($Running.pid) {
            $color = [System.ConsoleColor]::Cyan
            #TODO Pipeline
            $description = (Get-TogglProject -Id $Running.pid -Workspace $Running.wid).Name
        }
        else {
            $color = [System.ConsoleColor]::Red
            $description = if ($Running.description) {$Running.description} else {"??"}
        }

        if ($ForPrompt) {
            $start = " ["
            $split = " .. "
            $end = "]"
        }
        else {
            $start = "TOGGL: "
            $split = " is running since "
            $end = "`n"
        }

        Write-Host $start -NoNewline -ForegroundColor Yellow
        Write-Host $description -ForegroundColor $color -NoNewline
        Write-Host "$($split + $minutes)m$($end)" -NoNewline -ForegroundColor Yellow

    }
    elseif (!$ForPrompt) {
        Write-Verbose "No time entry currently running"
    }
}
