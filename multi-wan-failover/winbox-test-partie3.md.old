# Configuration Multi-WAN MikroTik RB951Ui-2HnD

## PARTIE 3 : Tests et Vérification

### A. Tests depuis le Terminal MikroTik (Winbox → New Terminal)

#### 1. Vérifier les interfaces et leurs statuts
```routeros
/interface print stats
```
**À vérifier** : Toutes les interfaces (ether1, ether2, ether3) doivent être "R" (Running)

#### 2. Vérifier les adresses IP configurées
```routeros
/ip address print
```
**À vérifier** : 
- ether2 → 192.168.8.50/24
- ether3 → 192.168.80.50/24
- bridge → 192.168.88.1/24 (votre LAN)

#### 3. Vérifier les routes
```routeros
/ip route print detail
```
**À vérifier** :
- 3 routes par défaut (0.0.0.0/0) avec distances différentes (1, 2, 3)
- 2 routes spécifiques pour 192.168.8.1/32 et 192.168.80.1/32
- Les routes doivent être marquées "DAC" (Dynamic, Active, Connected)

#### 4. Vérifier les règles Mangle
```routeros
/ip firewall mangle print
```
**À vérifier** : 2 règles pour marquer le trafic vers les box

#### 5. Vérifier les règles NAT
```routeros
/ip firewall nat print
```
**À vérifier** : Règles de masquerade pour ether2 et ether3

#### 6. Ping depuis le MikroTik vers les box
```routeros
/ping 192.168.8.1 count=5
/ping 192.168.80.1 count=5
/ping 8.8.8.8 count=5
```
**Résultat attendu** : 0% packet loss pour les 3

#### 7. Traceroute depuis le MikroTik
```routeros
/tool traceroute 192.168.8.1
/tool traceroute 192.168.80.1
```
**Résultat attendu** : 1 seul hop (direct)

#### 8. Tester la route spécifique (CRUCIAL)
```routeros
/ip route check dst-address=192.168.8.1
/ip route check dst-address=192.168.80.1
```
**Résultat attendu** : 
- Pour 192.168.8.1 → gateway devrait être 192.168.8.1 via ether2
- Pour 192.168.80.1 → gateway devrait être 192.168.80.1 via ether3

#### 9. Surveiller le trafic en temps réel
```routeros
/tool torch interface=ether2
# Appuyez sur Ctrl+C pour arrêter
/tool torch interface=ether3
```
**Utilisation** : Pendant que vous pingez depuis un PC du LAN vers les box, vous verrez le trafic passer

#### 10. Vérifier les compteurs de règles Mangle
```routeros
/ip firewall mangle print stats
```
**Résultat attendu** : Les compteurs de paquets et bytes doivent augmenter quand vous testez

---

### B. Tests depuis un PC sur le LAN

#### Prérequis
Votre PC doit être configuré :
- **IP** : 192.168.88.x (par exemple 192.168.88.100)
- **Masque** : 255.255.255.0
- **Passerelle** : 192.168.88.1 (le MikroTik)
- **DNS** : 8.8.8.8 ou 192.168.88.1

---

#### 1. Test de connectivité de base

**Windows (CMD ou PowerShell) :**
```cmd
ping 192.168.88.1
ping 192.168.8.1
ping 192.168.80.1
ping 8.8.8.8
ping google.com
```

**Linux/Mac :**
```bash
ping -c 5 192.168.88.1
ping -c 5 192.168.8.1
ping -c 5 192.168.80.1
ping -c 5 8.8.8.8
ping -c 5 google.com
```

**Résultat attendu** : 0% packet loss pour tout

---

#### 2. Traceroute vers les box (TEST CRUCIAL)

**Windows :**
```cmd
tracert -d 192.168.8.1
tracert -d 192.168.80.1
tracert -d 8.8.8.8
```

**Linux/Mac :**
```bash
traceroute -n 192.168.8.1
traceroute -n 192.168.80.1
traceroute -n 8.8.8.8
```

**Résultat attendu pour les box** :
```
Traceroute vers 192.168.8.1 :
1    <1 ms    192.168.88.1      (le MikroTik)
2    <5 ms    192.168.8.1       (la box)

Traceroute vers 192.168.80.1 :
1    <1 ms    192.168.88.1      (le MikroTik)
2    <5 ms    192.168.80.1      (la box)
```

**Si la route est correcte** : Vous devriez voir seulement 2 hops (MikroTik → Box)

**Si la route n'est PAS correcte** : Vous verrez plus de hops ou un timeout

---

#### 3. Test avancé : Vérifier l'interface de sortie

**Windows (PowerShell en Administrateur) :**
```powershell
# Installer psping (outil Microsoft)
# Télécharger depuis : https://learn.microsoft.com/sysinternals/downloads/psping

# Puis tester avec un port spécifique
Test-NetConnection -ComputerName 192.168.8.1 -Port 80 -InformationLevel Detailed
Test-NetConnection -ComputerName 192.168.80.1 -Port 80 -InformationLevel Detailed
```

**Linux :**
```bash
# Utiliser mtr (my traceroute) - plus détaillé
sudo mtr -r -c 10 192.168.8.1
sudo mtr -r -c 10 192.168.80.1

# Ou utiliser tcptraceroute
sudo tcptraceroute 192.168.8.1 80
sudo tcptraceroute 192.168.80.1 80
```

---

#### 4. Test d'accès aux interfaces web des box

**Depuis un navigateur web :**
```
http://192.168.8.1
http://192.168.80.1
```

**Résultat attendu** : Vous devriez voir la page d'administration de chaque box

---

#### 5. Test de performance et latence

**Windows :**
```cmd
# Ping continu pour surveiller la stabilité
ping -t 192.168.8.1
# Appuyez sur Ctrl+C pour arrêter et voir les statistiques

ping -t 192.168.80.1
```

**Linux/Mac :**
```bash
# Ping continu
ping 192.168.8.1

# Test avec statistiques détaillées
ping -c 100 192.168.8.1 | tail -2

# Test de bande passante (si iperf3 installé sur les box)
iperf3 -c 192.168.8.1
```

---

#### 6. Vérifier la table de routage du PC

**Windows :**
```cmd
route print
# Ou
netstat -r
```

**Linux/Mac :**
```bash
ip route
# Ou
route -n
# Ou
netstat -rn
```

**À vérifier** : La route par défaut doit pointer vers 192.168.88.1 (le MikroTik)

---

#### 7. Test DNS et résolution

**Windows/Linux/Mac :**
```bash
nslookup google.com
nslookup google.com 8.8.8.8
```

**Résultat attendu** : Résolution correcte des noms de domaine

---

### C. Tests Combinés (MikroTik + PC)

#### Test en temps réel
1. **Sur le MikroTik** : Lancer le monitoring
```routeros
/tool torch interface=ether2 src-address=192.168.88.0/24 dst-address=192.168.8.1
```

2. **Sur le PC** : Lancer un ping continu
```cmd
ping -t 192.168.8.1
```

3. **Observer** : Sur le MikroTik, vous devriez voir le trafic ICMP passer par ether2

#### Test de bascule de route
1. Débrancher le câble de ether2
2. Depuis le PC, faire :
```cmd
ping 192.168.8.1
```
3. **Résultat attendu** : Le ping devrait échouer (car la route spécifique ne fonctionne plus)

---

### D. Tableau de Diagnostic Rapide

| Test | Commande | Résultat OK | Problème si échec |
|------|----------|-------------|-------------------|
| Interfaces actives | `/interface print stats` | Toutes "R" | Câble débranché |
| Routes configurées | `/ip route print` | 5 routes visibles | Config incomplète |
| Ping vers Box1 | `ping 192.168.8.1` | 0% loss | Problème réseau/câble |
| Ping vers Box2 | `ping 192.168.80.1` | 0% loss | Problème réseau/câble |
| Traceroute Box1 | `tracert 192.168.8.1` | 2 hops | Routage incorrect |
| Traceroute Box2 | `tracert 192.168.80.1` | 2 hops | Routage incorrect |
| Accès web Box1 | `http://192.168.8.1` | Page visible | NAT/Firewall |
| Accès web Box2 | `http://192.168.80.1` | Page visible | NAT/Firewall |
| Compteurs Mangle | `/ip firewall mangle print stats` | Compteurs > 0 | Rules non appliquées |

---

### E. Script de Test Automatique (MikroTik)

Copiez ceci dans le terminal MikroTik pour un test automatique :
```routeros
:put "========================================";
:put "Test de Configuration Multi-WAN";
:put "========================================";
:put "";

:put "1. Test des interfaces...";
:put [/interface get ether2 running];
:put [/interface get ether3 running];
:put "";

:put "2. Test de ping vers Box 1 (192.168.8.1)...";
:put [/ping 192.168.8.1 count=3];
:put "";

:put "3. Test de ping vers Box 2 (192.168.80.1)...";
:put [/ping 192.168.80.1 count=3];
:put "";

:put "4. Test de ping Internet (8.8.8.8)...";
:put [/ping 8.8.8.8 count=3];
:put "";

:put "5. Vérification des routes...";
/ip route print where dst-address=192.168.8.1/32;
/ip route print where dst-address=192.168.80.1/32;
:put "";

:put "6. Statistiques Mangle...";
/ip firewall mangle print stats;
:put "";

:put "========================================";
:put "Tests terminés !";
:put "========================================";
```

---

## Notes Importantes

1. **Ordre des règles** : L'ordre des règles Mangle et NAT est important. Les règles sont évaluées de haut en bas.

2. **Adaptez l'adresse LAN** : Si votre réseau LAN n'est pas `192.168.88.0/24`, modifiez cette valeur dans les règles mangle.

3. **Distances des routes** :
   - Distance 1 = WAN1 (ether1) - route principale
   - Distance 2 = WAN2 (ether2) - secours
   - Distance 3 = WAN3 (ether3) - secours du secours

4. **Test de connectivité** : Après configuration, testez :
   - L'accès Internet via WAN1
   - L'accès direct aux interfaces de gestion des box (192.168.8.1 et 192.168.80.1)

5. **Sauvegarde** : Une fois que tout fonctionne, faites une sauvegarde :
   - **Files → Backup** dans Winbox
