Push-Location
try {
    Set-Location $Env:TEMP
    $tempFolder = (New-Item "./gitignore_$(Get-Date -Format "yyyyMMdd_HHmmss")" -ItemType Directory).FullName
    Set-Location $tempFolder
    
    git clone --no-checkout --depth 1 https://github.com/github/gitignore 2>&1 | out-null
    Set-Location "./gitignore"
            
    $patterns = (git ls-tree --full-name --name-only -r HEAD | Select-String -Pattern '^([^/\\]+)\.gitignore$') | Select-Object @{Label = "Pattern"; Expression = { $_.Matches.Groups[1].Value.ToString() } }

    $patternsText = $patterns | Join-String -Property Pattern -Separator "$([System.Environment]::NewLine)"

    Set-Location ../..
    Remove-Item -Path $tempFolder -Recurse -Force

    return $patternsText
}
catch {        
    Write-Error "There was an error while retriving .gitignore templates from a GitHub repository: $($_)"    
}
finally {
    Pop-Location
}

