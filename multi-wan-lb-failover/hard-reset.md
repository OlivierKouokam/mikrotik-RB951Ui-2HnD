# Méthodes de Hard Reset du RB951Ui-2HnD

## 1. Via le Bouton Reset Physique (Méthode Principale)

### Procédure Standard :

1. **Éteignez** le routeur (débranchez l'alimentation)
2. **Localisez le bouton Reset** (petit trou à l'arrière du routeur)
3. **Maintenez enfoncé** le bouton Reset avec un trombone ou un objet fin
4. **Tout en maintenant le bouton**, rebranchez l'alimentation
5. **Continuez à maintenir** le bouton pendant environ **5-10 secondes**
6. **Observez le LED ACT** (indicateur d'activité) :
   - Le LED commence à clignoter lentement
   - Puis clignote rapidement
   - **Relâchez le bouton** quand le LED commence à clignoter rapidement
7. **Attendez** que le routeur redémarre complètement (30-60 secondes)

### Timing Important :
- **5 secondes** : Reset configuration (soft reset via bouton)
- **10+ secondes** : Pas d'effet supplémentaire, relâchez après le clignotement rapide

---

## 2. Via le Mode Netinstall (Reset Complet + Réinstallation)

### Quand l'utiliser :
- RouterOS corrompu
- Impossible d'accéder au routeur
- Besoin de réinstaller RouterOS complètement

### Matériel nécessaire :
- Cable Ethernet
- PC Windows
- Logiciel Netinstall (téléchargeable sur mikrotik.com)
- Fichier RouterOS (.npk)

### Procédure :

1. **Téléchargez Netinstall** depuis mikrotik.com/download
2. **Configurez votre PC** :
   - IP statique : `192.168.88.2`
   - Masque : `255.255.255.0`
   - Connectez le câble Ethernet au port 2, 3, 4 ou 5 du RB951

3. **Démarrez en mode Netinstall** :
   - Éteignez le routeur
   - Maintenez le bouton Reset enfoncé
   - Allumez le routeur
   - **Maintenez pendant 15-20 secondes** jusqu'à ce que le LED ACT reste allumé fixe
   - Relâchez le bouton

4. **Lancez Netinstall sur votre PC** :
   - Le routeur devrait apparaître dans la liste
   - Sélectionnez le fichier RouterOS (.npk)
   - Cliquez sur **Install**
   - Attendez la fin de l'installation (3-5 minutes)

5. **Redémarrage automatique** après installation

---

## 3. Via le Port Console (Serial)

### Matériel nécessaire :
- Câble console RJ45 vers DB9 ou USB
- Logiciel terminal (PuTTY, Tera Term)

### Configuration terminal :
```
Baud rate: 115200
Data bits: 8
Parity: None
Stop bits: 1
Flow control: None
```

### Procédure :

1. **Connectez** le câble console au port Console du routeur
2. **Ouvrez** votre logiciel terminal avec les paramètres ci-dessus
3. **Allumez** le routeur
4. **Appuyez rapidement sur une touche** pendant le démarrage
5. Vous verrez le menu du bootloader :
```
   RouterBOOT-3.xx
   
   What do you want to configure?
   d - boot delay
   k - boot key
   s - serial console
   o - boot device
   u - upgrade RouterBOOT
   f - format nand
   i - board info
   p - boot protocol
   t - do memory testing
   x - exit setup and continue boot
```

6. **Tapez 'o'** pour formater et réinitialiser
7. Suivez les instructions à l'écran

---

## 4. Hard Reset via RouterBOOT Menu (Étherboot)

### Accès au menu RouterBOOT :

1. **Connectez-vous via console** (voir méthode 3)
2. **Redémarrez** le routeur
3. **Appuyez sur n'importe quelle touche** rapidement au démarrage
4. Dans le menu, sélectionnez les options de reset

### Options disponibles :
- **Format NAND** : Efface complètement le stockage
- **Reset Configuration** : Supprime la config uniquement

---

## Comparaison des Méthodes

| Méthode | Difficulté | Temps | Quand l'utiliser |
|---------|-----------|-------|------------------|
| **Bouton Reset** | ⭐ Facile | 2 min | Accès physique disponible |
| **Netinstall** | ⭐⭐⭐ Avancé | 10 min | RouterOS corrompu |
| **Console** | ⭐⭐ Moyen | 5 min | Diagnostic approfondi |
| **RouterBOOT** | ⭐⭐⭐ Avancé | 5 min | Problèmes de boot |

---

## Après le Hard Reset

### État du routeur :
- **Configuration** : Par défaut ou vierge
- **RouterOS** : Intact (sauf Netinstall)
- **License** : Conservée
- **IP par défaut** : `192.168.88.1`
- **Username** : `admin`
- **Password** : *(vide)*

### Première connexion :
```bash
# Via navigateur
http://192.168.88.1

# Via WinBox
MAC address ou 192.168.88.1

# Via SSH
ssh admin@192.168.88.1
```

---

## ⚠️ Différences Hard Reset vs Soft Reset

| Aspect | Soft Reset | Hard Reset |
|--------|-----------|------------|
| **Accès nécessaire** | Interface (Web/CLI) | Accès physique |
| **Méthode** | Commande logicielle | Bouton physique |
| **Config** | Effacée | Effacée |
| **RouterOS** | Intact | Intact (sauf Netinstall) |
| **Quand inaccessible** | ❌ Ne fonctionne pas | ✅ Fonctionne toujours |

---

## 🔧 Dépannage

### Le bouton Reset ne fonctionne pas :
- Vérifiez que vous maintenez assez longtemps (5-10 sec)
- Essayez avec un trombone plus fin
- Utilisez Netinstall en dernier recours

### Netinstall ne détecte pas le routeur :
- Vérifiez votre IP statique sur le PC
- Désactivez le pare-feu Windows temporairement
- Utilisez un câble Ethernet testé
- Connectez au bon port (2-5, pas le port 1 WAN)

### Le routeur ne démarre pas après reset :
- Attendez 2-3 minutes complètes
- Vérifiez l'alimentation
- Essayez Netinstall pour réinstaller RouterOS

---

## 📝 Notes Importantes

- Le hard reset est une méthode physique qui fonctionne même si le routeur est inaccessible via l'interface
- Toujours faire un backup de la configuration avant un reset si possible
- La license RouterOS est conservée après un hard reset
- Le hard reset n'endommage pas le matériel

---

**Besoin d'aide pour une méthode spécifique ou rencontrez-vous un problème particulier ?**
