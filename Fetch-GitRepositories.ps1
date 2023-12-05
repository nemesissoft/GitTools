using namespace System.IO;
param ([switch]$WhatIf, [switch]$Verbose, [switch]$Quiet)
$currentDir = (get-location).Path;

if ($Verbose.IsPresent) {
    $VerbosePreference = "Continue";
}

function BuildGitCommand {
    $expression = 'git fetch';
    if ($Quiet.IsPresent) {
        $expression += ' -q';
    }
    if ($Verbose.IsPresent) {
        $expression += ' -v --progress';
    }
    if ($WhatIf.IsPresent) {
        $expression += ' --dry-run';
    }
    $expression += " origin";
    return $expression;
}

foreach ($item in $([Directory]::GetDirectories($currentDir, '.git', [SearchOption]::AllDirectories); )) {
    $dir = get-item -Force $item;
    Push-Location $dir.Parent;
    try {
        Write-Verbose "fetching in $((Get-Location).Path)...";
        $expression = BuildGitCommand;

        Invoke-expression $expression;

    }
    finally {
        Pop-Location;
    }
}