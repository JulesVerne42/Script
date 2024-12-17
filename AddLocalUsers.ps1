Function Random-Password ($length = 6)
    $digits = 48..57
    $letters = 65..90 + 97..122
    $password = get-random -count $length -input ($punc + $digits + $letters) |`
        ForEach -begin { $aa = $null } -process {$aa += [char]$_} -end {$aa}
    Return $password.ToString()
}

Function ManageAccentsAndCapitalLetters
    $StringWithoutAccent = $String -replace '[����]', 'e' -replace '[���]', 'a' -replace '[��]', 'i' -replace '[��]', 'o' -replace '[���]', 'u'
}

$Path = "C:\Scripts"
# Q.2.3
# Q.2.5
$Users = Import-Csv -Path $CsvFile -Delimiter ";" -Header "prenom","nom","societe","fonction","service","description","mail","mobile","scriptPath","telephoneNumber" -Encoding UTF8  | Select-Object -Skip 2
foreach ($User in $Users)
{
    $Prenom = ManageAccentsAndCapitalLetters -String $User.prenom
    $Name = "$Prenom.$Nom"
    If (-not(Get-LocalUser -Name "$Prenom.$Nom" -ErrorAction SilentlyContinue))
        $Description = "$($user.description) - $($User.fonction)"
        # Q.2.4
        # Q.2.11
        $UserInfo = @{
            Name                 = "$Prenom.$Nom"
            FullName             = "$Prenom.$Nom"
            Password             = $Password
            AccountNeverExpires  = $true
            PasswordNeverExpires = $false
        }

        New-LocalUser @UserInfo
        #Q.2.10
        Add-LocalGroupMember -Group "Utilisateur" -Member "$Prenom.$Nom"
        # Q.2.6
        Write-Host "L'utilisateur $Prenom.$Nom a �t� cr�e"
    }
    # Q.2.9
}