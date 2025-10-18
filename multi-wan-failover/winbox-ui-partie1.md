# Configuration Multi-WAN MikroTik RB951Ui-2HnD

## ⚠️ Concernant votre question sur les risques

**Pas de risque** de faire un soft reset via Winbox 6h après un hard reset. Ce sont deux opérations indépendantes :
- Le hard reset a déjà effacé tout
- Le soft reset va simplement réinitialiser la configuration actuelle
- Vous pouvez le faire autant de fois que nécessaire

---

## PARTIE 1 : Guide Pas à Pas avec Winbox (Pour Débutants)

### Étape 1 : Connexion Initiale
1. Ouvrir **Winbox**
2. Cliquer sur **"..."** (Neighbors) pour scanner le réseau
3. Sélectionner votre RB951Ui-2HnD (MAC address visible)
4. Login : **admin** (mot de passe vide par défaut après hard reset)
5. Cliquer sur **Connect**

### Étape 2 : Soft Reset (Configuration Propre)
1. Dans Winbox, aller dans **System → Reset Configuration**
2. **DÉCOCHER** "No Default Configuration" (on veut garder la config de base)
3. **COCHER** "Do Not Backup"
4. Cliquer sur **Reset Configuration**
5. Le routeur va redémarrer (attendre 1-2 minutes)
6. Se reconnecter avec Winbox

### Étape 3 : Configuration de Base
1. Aller dans **System → Identity**
   - Changer le nom : `MikroTik-MultiWAN` (par exemple)
   - Cliquer **OK**

2. Aller dans **System → Password**
   - Définir un nouveau mot de passe sécurisé
   - Cliquer **OK**

### Étape 4 : Configuration du Réseau LAN
1. Aller dans **IP → Addresses**
2. **Double-cliquer** sur l'adresse existante (probablement sur bridge)
3. Modifier l'adresse en : `192.168.88.1/24` (ou votre réseau LAN souhaité)
4. Cliquer **OK**

### Étape 5 : Configuration des Interfaces WAN

#### 5.1 Retirer ether2 et ether3 du bridge
1. Aller dans **Bridge → Ports**
2. Trouver les entrées pour **ether2** et **ether3**
3. Sélectionner chaque ligne et cliquer sur le **bouton rouge (-)** pour supprimer
4. Laisser **ether5** et **wlan1** dans le bridge (pour le LAN)

#### 5.2 Configurer ether1 (WAN1 - déjà configuré normalement)
- Vérifier dans **IP → DHCP Client** qu'il y a un client DHCP sur ether1
- Si absent, l'ajouter (voir étape suivante pour la méthode)

#### 5.3 Configurer ether2 (WAN2 - Box 192.168.8.1)
1. Aller dans **IP → Addresses**
2. Cliquer sur le **bouton bleu (+)** pour ajouter
3. Remplir :
   - **Address** : `192.168.8.50/24`
   - **Network** : `192.168.8.0` (se remplit automatiquement)
   - **Interface** : `ether2`
4. Cliquer **OK**

5. Aller dans **IP → Routes**
6. Cliquer sur le **bouton bleu (+)**
7. Remplir :
   - **Dst. Address** : `0.0.0.0/0`
   - **Gateway** : `192.168.8.1`
   - **Distance** : `2` (priorité plus basse que WAN1)
   - **Routing Table** : `wan2_table`
   - **Comment** : `WAN2-Route`
8. Cliquer **OK**

#### 5.4 Configurer ether3 (WAN3 - Box 192.168.80.1)
1. Aller dans **IP → Addresses**
2. Cliquer sur le **bouton bleu (+)**
3. Remplir :
   - **Address** : `192.168.80.50/24`
   - **Network** : `192.168.80.0`
   - **Interface** : `ether3`
4. Cliquer **OK**

5. Aller dans **IP → Routes**
6. Cliquer sur le **bouton bleu (+)**
7. Remplir :
   - **Dst. Address** : `0.0.0.0/0`
   - **Gateway** : `192.168.80.1`
   - **Distance** : `3`
   - **Routing Table** : `wan3_table`
   - **Comment** : `WAN3-Route`
8. Cliquer **OK**

### Étape 6 : Configuration du NAT pour chaque WAN

#### 6.1 NAT pour ether2
1. Aller dans **IP → Firewall → NAT**
2. Cliquer sur le **bouton bleu (+)**
3. Onglet **General** :
   - **Chain** : `srcnat`
   - **Out. Interface** : `ether2`
4. Onglet **Action** :
   - **Action** : `masquerade`
   - **Comment** : `NAT-WAN2`
5. Cliquer **OK**

#### 6.2 NAT pour ether3
1. Cliquer à nouveau sur le **bouton bleu (+)**
2. Onglet **General** :
   - **Chain** : `srcnat`
   - **Out. Interface** : `ether3`
3. Onglet **Action** :
   - **Action** : `masquerade`
   - **Comment** : `NAT-WAN3`
4. Cliquer **OK**

### Étape 7 : Routage Forcé vers les Box (PARTIE CRUCIALE)

Cette partie force les requêtes vers 192.168.8.1 à passer par ether2 et vers 192.168.80.1 à passer par ether3.

#### 7.1 Mangle pour marquer le trafic vers Box 1
1. Aller dans **IP → Firewall → Mangle**
2. Cliquer sur le **bouton bleu (+)**
3. Onglet **General** :
   - **Chain** : `prerouting`
   - **Src. Address** : `192.168.88.0/24` (votre réseau LAN)
   - **Dst. Address** : `192.168.8.1`
4. Onglet **Action** :
   - **Action** : `mark routing`
   - **New Routing Mark** : `to_box1`
   - **Passthrough** : **COCHÉ**
   - **Comment** : `Route-to-Box1`
5. Cliquer **OK**

#### 7.2 Mangle pour marquer le trafic vers Box 2
1. Cliquer sur le **bouton bleu (+)**
2. Onglet **General** :
   - **Chain** : `prerouting`
   - **Src. Address** : `192.168.88.0/24`
   - **Dst. Address** : `192.168.80.1`
3. Onglet **Action** :
   - **Action** : `mark routing`
   - **New Routing Mark** : `to_box2`
   - **Passthrough** : **COCHÉ**
   - **Comment** : `Route-to-Box2`
4. Cliquer **OK**

#### 7.3 Routes spécifiques pour le trafic marqué
1. Aller dans **IP → Routes**
2. Cliquer sur le **bouton bleu (+)**
3. Pour Box 1 :
   - **Dst. Address** : `192.168.8.1/32`
   - **Gateway** : `192.168.8.1`
   - **Routing Mark** : `to_box1`
   - **Comment** : `Force-to-Box1`
4. Cliquer **OK**

5. Cliquer à nouveau sur le **bouton bleu (+)**
6. Pour Box 2 :
   - **Dst. Address** : `192.168.80.1/32`
   - **Gateway** : `192.168.80.1`
   - **Routing Mark** : `to_box2`
   - **Comment** : `Force-to-Box2`
7. Cliquer **OK**

### Étape 8 : Vérification

1. Aller dans **IP → Routes**
   - Vous devriez voir 3 routes par défaut (0.0.0.0/0) avec des distances différentes
   - Vous devriez voir 2 routes spécifiques pour les box

2. Tester depuis un PC sur le LAN :
```
   ping 192.168.8.1
   ping 192.168.80.1
```

3. Dans Winbox, aller dans **Tools → Torch**
   - Sélectionner l'interface à surveiller pour voir le trafic
