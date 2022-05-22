<#
.SYNOPSIS
Get data from REST API
.PARAMETER Password
Password as SecureString
.EXAMPLE
Get-RestApi -Uri 'https://example.com/api'
.EXAMPLE
Get-RestApi -Uri 'https://example.com/api' -Token 'a4df6603-4189-4850-819f-8b6c44d49bc7' -User 'user' -Password (ConvertTo-SecureString -String 'P@s$w0rd' -AsPlainText -Force) -OutFile 'C:\Temp\api.txt'
.EXAMPLE
Get-RestApi -Uri 'C:\Temp\api.txt'
#>

function Get-RestApi {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,

        [Parameter()]
        [string]$Token,

        [Parameter()]
        [string]$User,

        [Parameter()]
        [SecureString]$Password,

        [Parameter()]
        [System.IO.FileInfo]$OutFile
    )

    [string]$unsecurePassword = $null
    if ($Password) {
        [System.IntPtr]$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $unsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    }

    [string]$pair = "${User}:${unsecurePassword}"
    [byte[]]$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    [string]$base64 = [System.Convert]::ToBase64String($bytes)

    [string]$basicAuthValue = "Basic $base64"
    [hashtable]$headers = @{
        'Authorization' = $basicAuthValue
        'User-Token'    = $Token
        'ContentType'   = 'application/json; charset=utf-8'
    }

    if ($OutFile) {
        Invoke-RestMethod -Uri $Uri -Headers $headers -OutFile $OutFile
    }
    else {
        [string]$rawData = Invoke-RestMethod -Uri $Uri -Headers $headers
        [string]$result = ([Text.Encoding]::UTF8.GetString([Text.Encoding]::GetEncoding(28591).GetBytes($rawData))).Substring(1)

        return $result
    }
}
