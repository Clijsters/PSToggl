function Write-RunningTogglEntry() {
    param(
        # Special case - format for prompt
        [Switch]
        $ForPrompt
    )
    $Running = Get-TogglEntry -Current
    if ($Running.id -GT 0) {
        # Consider using project name for prompt. Should take a kind of cached list pid - project
        $description = if ($Running.description) {$Running.description} else {"noDesc"}
        if (!$ForPrompt) {
            Write-Host "TOGGL: " -NoNewline -ForegroundColor Yellow
        }
        else {
            Write-Host " [" -NoNewline -ForegroundColor Yellow
        }
        [System.ConsoleColor]$color = if ($Running.pid) {[System.ConsoleColor]::Cyan} else {[System.ConsoleColor]::Red}
        if (!$ForPrompt) {
            Write-Host $description -ForegroundColor $color -NoNewline
            Write-Host " is running since " -ForegroundColor Yellow -NoNewline
        }
        else {
            if ($Running.pid) {
                $description = (Get-TogglProject -Id $Running.pid).Name
            }
            Write-Host $description -ForegroundColor $color -NoNewline
            Write-Host " .. " -ForegroundColor Yellow -NoNewline
        }
        Write-Host (([datetime]($Running.Start)).TimeOfDay.ToString()) -NoNewline -ForegroundColor Yellow

        if ($ForPrompt) {
            Write-Host "]" -ForegroundColor Yellow -NoNewline
        } else {
            Write-Host "`n"
        }
    }
    else {
        Write-Host "[Don't forget to track!]" -ForegroundColor Red -NoNewline
    }
}
