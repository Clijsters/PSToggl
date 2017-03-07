function Write-RunningTogglTimer(){
    $Running = Get-TogglTimer -Current
    if ($Running.id -GT 0) {
        Write-Host "TOGGL: " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
        if ($Running.description) {
            Write-Host $Running.description -ForegroundColor Yellow -NoNewline -BackgroundColor Black
        } else {
            Write-Host "No Description" -ForegroundColor Red -NoNewline -BackgroundColor Black
        }
        Write-Host (" is running since " + $Running.Start + ")") -BackgroundColor Black
    }
}
