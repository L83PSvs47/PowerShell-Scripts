<#
.SYNOPSIS
Get exe or dll file version
.EXAMPLE
Get-FileVersionEXE 'C:\Temp\example.exe'
.EXAMPLE
Get-Item C:\Temp\*.dll | Get-FileVersionEXE
.EXAMPLE
'C:\Temp\example1.dll','C:\Temp\example2.dll' | Get-FileVersionEXE
#>

function Get-FileVersionEXE {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.IO.FileInfo]$Path
    )

    process {
        if (($Path.FullName -like '*.exe') -or ($Path.FullName -like '*.dll')) {
            try {
                $productVersion = (Get-Item -Path $Path.FullName).VersionInfo.ProductVersion
                $fileVersion = (Get-Item -Path $Path.FullName).VersionInfo.FileVersion
            }
            catch {
                $productVersion = '-'
                $fileVersion = '-'
            }

            $result = [PSCustomObject]@{
                'Name'           = Split-Path -Path $Path -Leaf
                'ProductVersion' = $productVersion
                'FileVersion'    = $fileVersion
            }

            return $result
        }
    }
}
