param(
    [Parameter(Mandatory = $True)] [Alias("tn")][ValidateNotNullOrEmpty()][string]$templateName = $(throw "Template name is mandatory!") # i.e. "VisualStudio"
) 
 
$url = "https://raw.githubusercontent.com/github/gitignore/main/$($templateName).gitignore"
Write-Debug "Downloading .gitignore template from $($url)"

try {
    $resp = Invoke-WebRequest $url

    if ($resp.StatusCode -eq 200) {
        return $resp.Content
    }
}
catch {        
    Write-Error "There was an error while downloading $($templateName) .gitignore template from a GitHub repository: $($_)"    
}
return ""