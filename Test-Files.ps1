[CmdletBinding()] 
param(
	[String]$FileIdExe,
	[String]$Folder,
	[String[]]$Ignoreables = @(".gitattributes","LICENSE","README.md","Test-Files.ps1", "*.txt", "*.json", "*.ps1"),
	[Switch]$ShowAll
)


Set-Alias -Name fileid -Value (Resolve-Path -Path ($FileIdExe) -ErrorAction Stop)

Write-Verbose -Message ("Using FileId executable: " + (Get-Alias fileid).Definition )

Get-ChildItem -Path $Folder -Exclude $Ignoreables | ForEach-Object {
    $ext = $_.Name
    $testFolderExt = $_.FullName
    $children = Get-ChildItem -Path $testFolderExt -Recurse -File
    if ($children.Length -gt 0) {
        $children | ForEach-Object {
            $r = fileid $_.FullName json | ConvertFrom-Json -ErrorAction Stop -ErrorVariable $convertError
            if ($convertError) {
				Write-Error ("Error converting JSON from file: " + $_.FullName)
				break
            }
            $actual = $r.extensions.extension
            $expected = $_.Extension.Trim('.')
            
            ## Handle the case where the expected extension contains a "."
            if ($expected.Contains("_")) {
				$expected = $expected.Replace("_",".")
            }

            if ($actual -is [array]) {
                if ($actual -notcontains $expected -or $ShowAll) {
                    New-Object PSObject -Property @{
                        File = $_.FullName
                        Expected = $expected
                        Actual = $actual
                    }
				}
			} elseif ($actual -ne $expected -or $ShowAll) {
                New-Object PSObject -Property @{
                    File = $_.FullName
                    Expected = $expected
                    Actual = $actual
                }
            }
		}   
	} else {
        Write-Warning -Message ("No files for extension: " + $ext)   
	}
}