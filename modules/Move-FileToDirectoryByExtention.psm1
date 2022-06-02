<#
.SYNOPSIS
Moves the file to a directory with the same file extension
.EXAMPLE
Move-FileToDirectoryByExtention 'C:\Temp\temp.txt'
.EXAMPLE
'C:\Temp\temp.txt' | Move-FileToDirectoryByExtention
.EXAMPLE
Get-Item 'C:\Temp\*.*' | Move-FileToDirectoryByExtention
#>

function Move-FileToDirectoryByExtention {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [System.IO.FileInfo]$Path
    )

    process {
        if (Test-Path -Path $Path -PathType Leaf) {
            $directory = "$($Path.Directory)\$($Path.Extension.Replace('.', ''))"
            if (! (Test-Path -Path $directory) ) {
                New-Item -Path $directory -Type Directory | Out-Null
            }

            Write-Verbose -Message "$($Path.FullName) >> $directory"
            Move-Item -Path $Path.FullName -Destination $directory
        }
    }
}
