$stopwatch = New-Object System.Diagnostics.Stopwatch
$stopwatch.Start()
pdflatex -shell-escape main
bibtex main
pdflatex -shell-escape main
pdflatex -shell-escape main
$stopwatch.Stop()
$stopwatch

$tmp = Get-Date -Format "HH:mm"
Write-Host "Executed at $tmp" 
Write-Host "----------------"