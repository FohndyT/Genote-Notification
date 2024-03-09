Import-Module BurntToast
$imageMuta = "C:\Users\fohnd\Desktop\Fohndy\Muta.png"

# Récupère le profil de connexion
$connectionProfile = Get-NetConnectionProfile

# Lien de la page à surveiller
$url = "https://www.usherbrooke.ca/genote/application/etudiant/cours.php"

# Lien de la page de connexion
$connectionUrl = "https://cas.usherbrooke.ca/login?service=https%3A%2F%2Fwww.usherbrooke.ca%2Fgenote%2Fpublic%2Findex.php"

# L'emplacement du fichier d'enregistrement de la page web
$pageContentFilePath = "C:\Users\fohnd\Desktop\Fohndy\Programmation\Genote notification\GenoteContent.txt"

# On regarde si on est connecté à un réseau wifi
if ($null -eq $connectionProfile) 
{
    # Envoie une notification au système
    New-BurntToastNotification -Text "Muta", "Je n'ai pas pu accéder à la page, le système n'est pas connecté à internet" -AppLogo $imageMuta
}

# Accède à la page
$getPage = (Invoke-WebRequest -Uri $url)
# Récupère le lien de la page sur laquelle nous sommes tombés
$responsePage = $getPage.BaseResponse.ResponseUri.AbsoluteUri

if($responsePage -eq $url -or $responsePage -eq $connectionUrl)
{
    # Active l'environnement virtuel de python pour avoir accès à Selenium pour le script python
    $pythonExecutable = "C:\Program Files\Python311\python.exe"
    $pythonScriptPath = "C:\Users\fohnd\Desktop\Fohndy\Programmation\Genote notification\WebOperation.py"

    # Executer le fichier python et récupère la sortie (print())
    $pythonScriptOutput = & $pythonExecutable $pythonScriptPath
    # Vérifie si l'emplacement de l'enregistrement de la page web existe
    if (Test-Path -Path $pageContentFilePath) 
    {
        # Récupère le contenu du fichier d'enregistrement
        $fileContent = Get-Content -Path $pageContentFilePath

        # Compare le fichier d'enregistrement avec le contenu sur la page
        if ($pythonScriptOutput -ne $fileContent) 
        {
            New-BurntToastNotification -Text "Muta", "Des nouvelles notes sont sorties" -AppLogo $imageMuta
        
            # Met à jour le fichier
            $pythonScriptOutput | Out-File -FilePath $pageContentFilePath
        }
        else 
        {
            New-BurntToastNotification -Text "Muta", "Vous n'avez aucune nouvelle note" -AppLogo $imageMuta
        }
    } 
    else 
    {
        # Crée le fichier sinon
        $pythonScriptOutput | Out-File -FilePath $pageContentFilePath
    }
}
else
{
    New-BurntToastNotification -Text "Muta", "Je n'ai pas pu accéder à la page, l'adresse est introuvable" -AppLogo $imageMuta
}



