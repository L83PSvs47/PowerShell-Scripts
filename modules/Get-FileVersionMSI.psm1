<#
.SYNOPSIS
Get msi file version
.EXAMPLE
Get-FileVersionMSI 'C:\Temp\example.msi'
.EXAMPLE
Get-ChildItem C:\Temp | Get-FileVersionMSI
.EXAMPLE
'C:\Temp\example1.msi','C:\Temp\example2.msi' | Get-FileVersionMSI
#>

function Get-FileVersionMSI {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.IO.FileInfo]$Path
    )

    process {
        if ($Path.FullName -like '*.msi') {
            try {
                [System.__ComObject]$windowsInstaller = New-Object -ComObject WindowsInstaller.Installer
                [System.__ComObject]$database = $windowsInstaller.GetType().InvokeMember('OpenDatabase', 'InvokeMethod', $null, $windowsInstaller, @($Path.FullName, 0))
                [string]$query = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
                [System.__ComObject]$view = $database.GetType().InvokeMember('OpenView', 'InvokeMethod', $null, $database, ($query))
                $view.GetType().InvokeMember('Execute', 'InvokeMethod', $null, $view, $null)
                [System.__ComObject]$record = $view.GetType().InvokeMember('Fetch', 'InvokeMethod', $null, $view, $null)
                [string]$productVersion = $record.GetType().InvokeMember('StringData', 'GetProperty', $null, $record, 1)
            }
            catch {
                [string]$productVersion = '-'
            }

            $result = [PSCustomObject]@{
                'Name'           = Split-Path -Path $Path -Leaf
                'ProductVersion' = $productVersion
            }

            return $result
        }
    }
}
