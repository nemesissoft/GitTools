<#
    .SYNOPSIS
      Obtain all relese notes for given repository from Github API
    .OUTPUTS
      Collection of release notes 
    .EXAMPLE
    # get all release notes 
    $notes = .\Get-GithubAllReleaseNotes.ps1 -repoName "nemesissoft/Nemesis.TextParsers"
    
    # save notes to file
    $NL = [System.Environment]::NewLine

    $lines = $notes | Select-Object @{N = ’Entry’; E = { `
     "# Release $($_.TagName) - $($_.Name) $NL" +  `
     "Published [$($_.PublishedAt.ToString('yyyy-MM-dd HH:mm:ss')) GMT]($($_.Url)) by [$($_.AuthorLogin)]($($_.AuthorUrl))"   `
     + $NL + $NL + $_.’Body’  `
    } }

    ($lines | Select-Object -ExpandProperty Entry) -join "$NL$NL$NL" | Set-Content -Encoding UTF8 "ReleaseNotes.md"
#>

param (      
  [Parameter(Mandatory = $True)] [Alias("rn")] [string]$repoName
)

try {
  $uri = "https://api.github.com/repos/$repoName/releases?per_page=100"           
  $webContent = Invoke-WebRequest -Uri $uri

  $result = $webContent.Content | ConvertFrom-Json | Select-Object `
  @{N = ’TagName’; E = { $_.tag_name } }, `
  @{N = ’Name’; E = { $_.name } }, `
  @{N = ’Body’; E = { $_.body } }, `
  @{N = ’Url'; E = { $_.html_url } }, `
  @{N = ’PublishedAt'; E = { $_.published_at } }, `
  @{N = ’AuthorLogin'; E = { $_.author.login } }, `
  @{N = ’AuthorUrl'; E = { $_.author.html_url } }

  return $result
}
catch {
  Write-Error "An error occurred during obtaining release notes"
  Write-Error $_
  return $null
}