<#
.SYNOPSIS
Transliteration of the text based on the hash table
.EXAMPLE
Get-Translit 'Съешь же ещё этих мягких французских булок да выпей чаю.'
.EXAMPLE
'В чащах юга жил бы цитрус? Да, но фальшивый экземпляр!' | Get-Translit
.EXAMPLE
Get-Content 'C:\Temp\example.txt' | Get-Translit
#>

function Get-Translit {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]$String
    )

    process {
        [hashtable]$translitTable = @{
            [char]'а' = 'a'; [char]'А' = 'A'
            [char]'б' = 'b'; [char]'Б' = 'B'
            [char]'в' = 'v'; [char]'В' = 'V'
            [char]'г' = 'g'; [char]'Г' = 'G'
            [char]'д' = 'd'; [char]'Д' = 'D'
            [char]'е' = 'e'; [char]'Е' = 'E'
            [char]'ё' = 'yo'; [char]'Ё' = 'Yo'
            [char]'ж' = 'zh'; [char]'Ж' = 'Zh'
            [char]'з' = 'z'; [char]'З' = 'Z'
            [char]'и' = 'i'; [char]'И' = 'I'
            [char]'й' = 'y'; [char]'Й' = 'Y'
            [char]'к' = 'k'; [char]'К' = 'K'
            [char]'л' = 'l'; [char]'Л' = 'L'
            [char]'м' = 'm'; [char]'М' = 'M'
            [char]'н' = 'n'; [char]'Н' = 'N'
            [char]'о' = 'o'; [char]'О' = 'O'
            [char]'п' = 'p'; [char]'П' = 'P'
            [char]'р' = 'r'; [char]'Р' = 'R'
            [char]'с' = 's'; [char]'С' = 'S'
            [char]'т' = 't'; [char]'Т' = 'T'
            [char]'у' = 'u'; [char]'У' = 'U'
            [char]'ф' = 'f'; [char]'Ф' = 'F'
            [char]'х' = 'kh'; [char]'Х' = 'Kh'
            [char]'ц' = 'ts'; [char]'Ц' = 'Ts'
            [char]'ч' = 'ch'; [char]'Ч' = 'Ch'
            [char]'ш' = 'sh'; [char]'Ш' = 'Sh'
            [char]'щ' = 'sch'; [char]'Щ' = 'Sch'
            [char]'ъ' = ''; [char]'Ъ' = ''
            [char]'ы' = 'y'; [char]'Ы' = 'Y'
            [char]'ь' = ''; [char]'Ь' = ''
            [char]'э' = 'e'; [char]'Э' = 'E'
            [char]'ю' = 'yu'; [char]'Ю' = 'Yu'
            [char]'я' = 'ya'; [char]'Я' = 'Ya'
        }

        [string]$result = $null
        foreach ($char in $String.ToCharArray()) {
            if ($null -cne $translitTable[$char]) {
                $result += $translitTable[$char]
            }
            else {
                $result += $char
            }
        }

        return $result
    }
}
