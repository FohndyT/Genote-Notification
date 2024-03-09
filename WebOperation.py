import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions

with open('C:\\Users\\fohnd\Documents\Fohndy\GenoteNotification\Texte.txt') as file:
    lines = file.readlines()
    lines = [line.strip() for line in lines]
    myUsername = lines[0]
    myPassword = lines[1]


# Accède au chrome driver
s = Service(executable_path=r'C:\\Users\\fohnd\Documents\chromedriver-win64\chromedriver.exe')
# Ouvre chrome de façon discrète
o = Options()
o.add_argument('--headless')
driver = webdriver.Chrome(service=s, options=o)
# Accède à la page de connexion
driver.get("https://cas.usherbrooke.ca/login?service=https%3A%2F%2Fwww.usherbrooke.ca%2Fgenote%2Fpublic%2Findex.php")

# Envoie une erreur après 10 secondes si le champ pour l'identifiant n'est pas trouvé
username = WebDriverWait(driver, 10).until(
    # Trouve le champ d'entrée pour l'identifiant
    expected_conditions.presence_of_element_located((By.ID, "username"))
)
# Envoie l'identifiant
username.send_keys(myUsername)

password = WebDriverWait(driver, 10).until(
    # Trouve le champ d'entrée pour le mot de passe
    expected_conditions.presence_of_element_located((By.ID, "password"))
)
# Envoie le mot de passe
password.send_keys(myPassword)

button = WebDriverWait(driver, 10).until(
    # Trouve le bouton connexion
    expected_conditions.element_to_be_clickable((By.CLASS_NAME, "btn-submit"))
)
# Clique le bouton connexion
button.click()

link = WebDriverWait(driver, 10).until(
    # Trouve le lien pour accéder aux notes
    expected_conditions.element_to_be_clickable((By.LINK_TEXT, "Consulter vos notes d'évaluations"))
)
# Clique sur le lien
link.click()


tdElements = WebDriverWait(driver, 10).until(
    # Trouve les cellules des tableaux dans le code html de la page dont le nom de la classe est coursetudiant
    expected_conditions.presence_of_all_elements_located((By.CLASS_NAME, "coursetudiant"))
)

listElements = []
# Récupère les valeurs numériques afficher sur la page
for td in tdElements:
    try:
        listElements.append(int(td.text))
    except:
        pass

# Trie les valeurs en ordre croissant
listElements.sort()

list = ""

# Transforme tous les éléments de la liste en un string
for i in listElements:
    list += str(i)
    list += " "

print(list)

# Quitte la session
driver.quit()
