<#
.SYNOPSIS
Get PowerShell script variables and exclude the $locals and automatic variables from the final output.
.DESCRIPTION
$NoOutput - Suppresses the output of the script
.EXAMPLE
Get-ScriptVariable 'C:\Temp\example.ps1'
.EXAMPLE
Get-ScriptVariable -Path 'C:\Temp\example.ps1' -NoOutput
#>

function Get-ScriptVariable {
    [cmdletbinding()]
    param (
        [ValidateScript( { Test-Path $_ } )]
        [string]$Path,

        [switch]$NoOutput
    )

    [System.Object]$locals = Get-Variable -Scope local

    if ($NoOutput) {
        . $Path | Out-Null
    }
    else {
        . $Path
    }

    Compare-Object -ReferenceObject (Get-Variable -Scope local) -DifferenceObject $locals -Property Name -PassThru |
    Where-Object -Property Name -ine 'locals' |
    Select-Object -Property @(
        'Name',
        'Value',
        @{
            n = 'Type'
            e = { $_.Value.GetType() }
        }) |
    Format-Table -Property Name, Type, Value -AutoSize
}
