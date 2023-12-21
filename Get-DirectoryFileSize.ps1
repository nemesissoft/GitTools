<#
.SYNOPSIS
Get cummulative sizes for files in given directories (with recursive option)

.EXAMPLE
"$PSHome\en-US", "$PSHome" | .\Get-DirectoryFileSize.ps1 -Recurse

# get first size 
(.\Get-DirectoryFileSize.ps1 -Directory "$PSHome\en-US", "$PSHome")[0].SizeInMB
#>

param
(
	[Parameter(Mandatory, ValueFromPipeline)]	
    [ValidateScript({ $_ | ForEach-Object {(Test-Path $_)}})]   #[ValidateScript({ $_ | ForEach-Object {(Get-Item $_).PSIsContainer}})]
	[string[]] $Directory,
	
	[switch] $Recurse
)

BEGIN {}
PROCESS
{
	foreach ($folder in $Directory)
	{
		$size = 0
		if ($files = Get-ChildItem $folder -Recurse:$Recurse -File)
		{
			$files | ForEach-Object {
				$size += $_.Length
			}
			
			[PSCustomObject]@{
				'Directory' = $folder; 'SizeInMB' = $size / 1MB
			}
		}			
	}
}
END {}