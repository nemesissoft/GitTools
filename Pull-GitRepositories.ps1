Push-Location

Get-ChildItem -Directory -Force -Recurse *.git | 
ForEach-Object { 
    $folder = $_.Parent.FullName;
    Set-Location $folder; 
    Write-Host "Pulling changes from '$folder'"; 
    git pull 
}

Pop-Location