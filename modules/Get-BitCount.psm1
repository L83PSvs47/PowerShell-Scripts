<#
.SYNOPSIS
Counting the number of set bits in an integer
.DESCRIPTION
The time complexity of the first algorithm is O(1)
The time complexity of the second algorithm is Θ(logn)
.EXAMPLE
Get-BitCount 7
.EXAMPLE
Get-BitCount 7 -Alternative
.EXAMPLE
7 | Get-BitCount
#>

function Get-BitCount {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [int]$Number,

        [Parameter(ValueFromPipeline)]
        [switch]$Alternative
    )

    process {
        [int]$result = 0

        switch ($Alternative) {
            $false {
                $result = ($Number -band 0x55555555) + (($Number -shr 1) -band 0x55555555)
                $result = ($result -band 0x33333333) + (($result -shr 2) -band 0x33333333)
                $result = ($result -band 0x0F0F0F0F) + (($result -shr 4) -band 0x0F0F0F0F)
                $result = ($result -band 0x00FF00FF) + (($result -shr 8) -band 0x00FF00FF)
                $result = ($result -band 0x0000FFFF) + (($result -shr 16) -band 0x0000FFFF)
            }
            $true {
                while ($Number -gt 0) {
                    $result += $Number -band 1
                    $Number = $Number -shr 1
                }
            }
            Default {}
        }

        return $result
    }
}
