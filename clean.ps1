Write-Host "Deleting Files"

$filesToDelete  = "*.aux","*.bbl","*.blg","*.glg","*.glo","*.gls","*.glsdefs","*.lof","*.log","*.lot","*.out","*.run.xml","*.toc","*.xdy","main.pdf","main-blx.bib","_minted-main","*.loAnhang","*bcf"
foreach ($item in $filesToDelete) {
    Remove-Item .\$item -Recurse
}
Write-Host "Files are deleted"