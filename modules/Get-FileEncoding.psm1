<#
.SYNOPSIS
Gets the encoding of a text file
.DESCRIPTION
Defines a family of Unicode text encodings using Byte Order Mark (BOM).
The accuracy of this method is low, since this method only works with text files and ascii is used by default when there is no BOM.
.EXAMPLE
Get-FileEncoding 'C:\Temp\test.txt'
.EXAMPLE
(Get-ChildItem C:\Temp).FullName | Get-FileEncoding
.EXAMPLE
(Get-ChildItem C:\Temp).FullName | Get-FileEncoding -Alternative
#>

function Get-FileEncoding {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Path,

        [Parameter(ValueFromPipeline)]
        [switch]$Alternative
    )

    process {
        if ($Alternate) {
            [byte[]]$bytes = 0
            if ($null -ne (Get-Content $Path)) {
                $bytes = (Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)
            }

            if (!$bytes) { $encoding = 'utf-8' }
            switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0], $bytes[1], $bytes[2], $bytes[3]) {
                '^efbbbf' { $encoding = 'utf-8' }
                '^2b2f76' { $encoding = 'utf-7' }
                '^feff' { $encoding = 'utf-16BE' }
                '^fffe' { $encoding = 'utf-16' }
                '^0000feff' { $encoding = 'utf-32BE' }
                '^fffe0000' { $encoding = 'utf-32' }
                default { $encoding = 'ascii' }
            }

            $result = [PSCustomObject]@{
                'Name'     = Split-Path $Path -leaf
                'Encoding' = $encoding
            }
        }
        else {
            $reader = [System.IO.StreamReader]::new($Path, [System.Text.Encoding]::Default, $true)
            $peek = $reader.Peek()
            $encoding = $reader.CurrentEncoding
            $reader.Close()

            $result = [PSCustomObject]@{
                'Name'     = Split-Path $Path -leaf
                'Encoding' = $encoding.BodyName
            }
        }

        return $result
    }
}
