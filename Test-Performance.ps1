[CmdletBinding()] 
param(
	[String]$FileIdExe,
	[String]$Folder,
	[float]$Threashold = 1000,
	[String[]]$Ignoreables = @(".gitattributes","LICENSE","README.md","Test-Files.ps1", "*.txt", "*.json", "*.ps1"),
	[Switch]$ShowAll
)
Set-Alias -Name fileid -Value (Resolve-Path -Path ($FileIdExe) -ErrorAction Stop)
Write-Verbose -Message ("Using FileId executable: " + (Get-Alias fileid).Definition )

$perfData = Get-ChildItem -Path $Folder -Exclude $Ignoreables -Recurse -File | ForEach-Object {
	$file = $_.FullName;
	$time = Measure-Command -Expression { fileid $file xml }
	New-Object PSObject -Property @{ 
		File=$file
		Milliseconds=$time.TotalMilliseconds 
	}
}
if ($ShowAll) {
	
} else {
	$perfData = $perfData | Where-Object { $_.Milliseconds -gt $Threashold}
}

$perfData | sort Milliseconds | ft File,Milliseconds -AutoSize