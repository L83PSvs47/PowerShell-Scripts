<#
.SYNOPSIS
Get MSI file version
.EXAMPLE
Get-MSIVersion "C:\Temp\example.msi"
#>

function Get-MSIVersion {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Path
    )

    try {
        [System.__ComObject]$windowsInstaller = New-Object -com WindowsInstaller.Installer
        [System.__ComObject]$database = $windowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $null, $windowsInstaller, @($Path, 0))
        [string]$query = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
        [System.__ComObject]$view = $database.GetType().InvokeMember("OpenView", "InvokeMethod", $null, $database, ($query))
        $view.GetType().InvokeMember("Execute", "InvokeMethod", $null, $view, $null)
        [System.__ComObject]$record = $view.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $view, $null)
        [string]$productVersion = $record.GetType().InvokeMember("StringData", "GetProperty", $null, $record, 1)
    }
    catch {
        $productVersion = 'Failed to get MSI file version'
    }

    return $productVersion
}
