#Q.2.7 Importation du module de Functions.psm1Import-Module -Name "C:\Scripts\Functions.psm1"Function Random-Password ($length = 6){    $punc = 46..46
    $digits = 48..57
    $letters = 65..90 + 97..122
    $password = get-random -count $length -input ($punc + $digits + $letters) |`
        ForEach -begin { $aa = $null } -process {$aa += [char]$_} -end {$aa}
    Return $password.ToString()
}

Function ManageAccentsAndCapitalLetters{    param ([String]$String)    
    $StringWithoutAccent = $String -replace '[éèêë]', 'e' -replace '[àâä]', 'a' -replace '[îï]', 'i' -replace '[ôö]', 'o' -replace '[ùûü]', 'u'    $StringWithoutAccentAndCapitalLetters = $StringWithoutAccent.ToLower()    $StringWithoutAccentAndCapitalLetters
}

$Path = "C:\Scripts"$CsvFile = "$Path\Users.csv"$LogFile = "$Path\Log.log"
# Q.2.3 Modifier "-skip 2" en "-skip 1" pour ignorer seulement la ligne header du csv et non pas également la première ligne utilisateur
# Q.2.5 Suppression des champs "societe", "service", "mail", "mobile", "scriptPath", "telephoneNumber"
$Users = Import-Csv -Path $CsvFile -Delimiter ";" -Header "prenom","nom","fonction","description", -Encoding UTF8  | Select-Object -Skip 1
foreach ($User in $Users)
{
    $Prenom = ManageAccentsAndCapitalLetters -String $User.prenom    $Nom = ManageAccentsAndCapitalLetters -String $User.Nom
    $Name = "$Prenom.$Nom"
    If (-not(Get-LocalUser -Name "$Prenom.$Nom" -ErrorAction SilentlyContinue))    {        $Pass = Random-Password        $Password = (ConvertTo-secureString $Pass -AsPlainText -Force)
        $Description = "$($user.description) - $($User.fonction)"
        # Q.2.4 Ajout de l'attribut description
        # Q.2.11 Application de la valeur "PasswordNeverExpires = $true"
        $UserInfo = @{
            Name                 = "$Prenom.$Nom"
            FullName             = "$Prenom.$Nom"
            Password             = $Password
            AccountNeverExpires  = $true
            PasswordNeverExpires = $true
            Description          = $Description
        }

        New-LocalUser @UserInfo
        # Q.2.8 Journalisation des logs
        Log -FilePath "$LogFile" -Content "L'utilisateur $Prenom $Nom a été crée avec succès"
        #Q.2.10 Correction du nom du groupe utilisateurs
        Add-LocalGroupMember -Group "Utilisateurs" -Member "$Prenom.$Nom"
        # Q.2.6 Ajout de la variable et de la couleur verte
        Write-Host "L'utilisateur $Prenom.$Nom a été crée avec le mot de passe $Pass" -ForegroundColor Green
    }
    # Q.2.9 Message d'erreur car l'utilisateur existe déjà
    else {
    Write-Host "Le compte $Name existe déjà !" -ForegroundColor Red
    }
}

