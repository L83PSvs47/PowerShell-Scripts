<#
.SYNOPSIS
Generate random password
.DESCRIPTION
Complexity:
1 = Upper-case = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
2 = Lower-case = 'abcdefghijklmnopqrstuvwxyz'
4 = Digits = '0123456789'
8 = Special = ' !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~'
.EXAMPLE
Get-RandomPassword
.EXAMPLE
Get-RandomPassword -Length 10 -Complexity 7 -AsSecureString
#>

function Get-RandomPassword {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Length = 20,

        [parameter()]
        [int]$Complexity = 0,

        [parameter()]
        [switch]$AsSecureString
    )

    [int]$upper = [int]$lower = [int]$digits = [int]$special = 0
    [char[]]$charSet = $null
    [char[]]$upperCharSet = ('ABCDEFGHIJKLMNOPQRSTUVWXYZ').ToCharArray()
    [char[]]$lowerCharSet = ('abcdefghijklmnopqrstuvwxyz').ToCharArray()
    [char[]]$digitsCharSet = ('0123456789').ToCharArray()
    [char[]]$specialCharSet = ('!"#$%&()*+,-./:;<=>?@[\]^_`{|}~').ToCharArray()

    switch ($Complexity) {
        { $PSItem -band 1 } { $upper = 1; $charSet += $upperCharSet; }
        { $PSItem -band 2 } { $lower = 1; $charSet += $lowerCharSet; }
        { $PSItem -band 4 } { $digits = 1; $charSet += $digitsCharSet; }
        { $PSItem -band 8 } { $special = 1; $charSet += $specialCharSet; }
        Default {
            $upper = 1; $charSet += $upperCharSet
            $lower = 1; $charSet += $lowerCharSet
            $digits = 1; $charSet += $digitsCharSet
            $special = 1; $charSet += $specialCharSet
        }
    }

    [int]$complexLength = 0
    switch ($upper + $lower + $digits + $special) {
        1 { $complexLength = 1 }
        2 { $complexLength = 2 }
        3 { $complexLength = 4 }
        4 { $complexLength = 6 }
        Default {}
    }

    if ($Length -lt $complexLength) {
        $Length = $complexLength
    }

    $result = New-Object char[]($Length)
    $bytes = New-Object byte[]($Length)
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $rng.GetBytes($bytes)

    for ($i = 0 ; $i -lt $Length ; $i++) {
        $result[$i] = $charSet[$bytes[$i] % $charSet.Length]
    }

    [string]$password = (-join $result)
    if ($upper -gt ($result | Where-Object { $_ -cin $upperCharSet }).Count) { $password = Get-RandomPassword $Length $Complexity }
    if ($lower -gt ($result | Where-Object { $_ -cin $lowerCharSet }).Count) { $password = Get-RandomPassword $Length $Complexity }
    if ($digits -gt ($result | Where-Object { $_ -cin $digitsCharSet }).Count) { $password = Get-RandomPassword $Length $Complexity }
    if ($special -gt ($result | Where-Object { $_ -cin $specialCharSet }).Count) { $password = Get-RandomPassword $Length $Complexity }

    if ($AsSecureString) {
        [securestring]$password = ( ConvertTo-SecureString -String $password -AsPlainText -Force )
    }

    return $password
}
