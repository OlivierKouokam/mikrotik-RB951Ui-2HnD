# Méthodes de Soft Reset du RB951Ui-2HnD

## 1. Via l'Interface Web (Webfig/QuickSet)

### Étapes :
1. Ouvrez votre navigateur et accédez à `http://192.168.88.1`
2. Connectez-vous (par défaut : admin / pas de mot de passe)
3. Allez dans **System → Reset Configuration**
4. Options disponibles :
   - ☐ **No Default Configuration** : Configuration vierge (aucune config par défaut)
   - ☐ **Keep User Configuration** : Conserve les comptes utilisateurs
   - ☐ **Do Not Backup** : N'effectue pas de backup avant reset
5. Cliquez sur **Reset Configuration**
6. Confirmez et attendez le redémarrage (30-60 secondes)

---

## 2. Via WinBox

### Étapes :
1. Lancez WinBox et connectez-vous au routeur
2. Allez dans **System → Reset Configuration**
3. Cochez les options souhaitées :
   - **No Default Configuration**
   - **Keep User Configuration**
   - **Do Not Backup**
4. Cliquez sur **Reset Configuration**
5. Confirmez avec **Yes**

---

## 3. Via Terminal/SSH/Console

### Commande de base :
```bash
/system reset-configuration
```

### Commandes avancées :
```bash
# Reset avec config par défaut
/system reset-configuration

# Reset sans config par défaut (vierge)
/system reset-configuration no-defaults=yes

# Reset en gardant les utilisateurs
/system reset-configuration keep-users=yes

# Reset sans backup automatique
/system reset-configuration skip-backup=yes

# Combinaison d'options
/system reset-configuration no-defaults=yes keep-users=yes skip-backup=yes
```

---

## 4. Via Application Mobile

### Si vous utilisez l'app MikroTik :
1. Connectez-vous au routeur via l'application
2. Accédez au menu **System**
3. Sélectionnez **Reset Configuration**
4. Choisissez vos options et confirmez

---

## Options Expliquées

| Option | Description |
|--------|-------------|
| **Normal Reset** | Restaure la configuration par défaut de MikroTik |
| **No Default Configuration** | Configuration complètement vierge, aucune règle |
| **Keep Users** | Conserve les comptes utilisateurs créés |
| **Do Not Backup** | N'effectue pas de sauvegarde avant le reset |

---

## Après le Soft Reset

### Configuration par défaut (si non désactivée) :
- IP LAN : `192.168.88.1/24`
- DHCP Server actif sur le LAN
- Username : `admin`
- Password : *(vide)*
- WiFi : Activé (nom par défaut visible)
- NAT : Configuré automatiquement

### Accès après reset :
- Web : `http://192.168.88.1`
- WinBox : Connectez-vous via MAC address ou IP
- SSH : `ssh admin@192.168.88.1`

---

## ⚠️ Avertissements

- **Perte de configuration** : Toute la config actuelle sera effacée
- **Connexion perdue** : Vous serez déconnecté pendant le processus
- **Backup recommandé** : Faites un backup avant (`/system backup save name=backup`)
- **Durée** : Le processus prend 30-60 secondes

---

## Dépannage

### Si vous ne pouvez pas accéder au routeur :
- Utilisez le **hard reset** (bouton physique)
- Connectez-vous via MAC address avec WinBox
- Utilisez un câble série (port console)

---

## 📋 Comparaison des Méthodes

| Méthode | Difficulté | Avantages | Inconvénients |
|---------|-----------|-----------|---------------|
| **Interface Web** | ⭐ Facile | Interface graphique intuitive | Nécessite un navigateur |
| **WinBox** | ⭐ Facile | Rapide et visuel | Nécessite WinBox installé |
| **Terminal/SSH** | ⭐⭐ Moyen | Flexible, scriptable | Ligne de commande |
| **App Mobile** | ⭐ Facile | Pratique depuis mobile | Fonctionnalités limitées |

---

## 🔄 Différence Soft Reset vs Hard Reset

| Aspect | Soft Reset | Hard Reset |
|--------|-----------|------------|
| **Méthode** | Via interface logicielle | Via bouton physique |
| **Accès requis** | Interface web/CLI/WinBox | Accès physique au routeur |
| **Quand utiliser** | Routeur accessible | Routeur inaccessible/bloqué |
| **Configuration** | Effacée | Effacée |
| **RouterOS** | Intact | Intact |

---

## 💡 Conseils Pratiques

### Avant le soft reset :
1. **Sauvegardez votre configuration** :
```bash
   /system backup save name=backup-$(date)
```

2. **Exportez la configuration** :
```bash
   /export file=config-export
```

3. **Notez vos paramètres importants** :
   - Adresses IP
   - Règles firewall personnalisées
   - Configuration WiFi
   - Paramètres VPN

### Après le soft reset :
1. Changez immédiatement le mot de passe admin
2. Configurez une IP statique si nécessaire
3. Sécurisez le WiFi avec un mot de passe fort
4. Mettez à jour RouterOS si besoin

---

## 📝 Scripts Utiles

### Script de backup automatique avant reset :
```bash
/system backup save name=pre-reset-backup
:delay 2s
/system reset-configuration no-defaults=yes
```

### Vérifier la version RouterOS avant reset :
```bash
/system resource print
```

### Créer un export de configuration :
```bash
/export file=full-config
```

---

## 🆘 Cas d'Usage Courants

### Revendre le routeur :
```bash
/system reset-configuration no-defaults=yes skip-backup=yes
```

### Configuration corrompue :
```bash
/system reset-configuration
```

### Test de nouvelle configuration :
```bash
# Faire un backup d'abord
/system backup save name=current-config
# Puis reset
/system reset-configuration
```

### Oubli du mot de passe :
- Le soft reset ne fonctionnera pas (vous ne pouvez pas vous connecter)
- Utilisez le **hard reset** avec le bouton physique

---

## 🔐 Sécurité Post-Reset

### Checklist de sécurité :
1. ✅ Changer le mot de passe par défaut
2. ✅ Désactiver les services non utilisés
3. ✅ Configurer le firewall
4. ✅ Activer le chiffrement WiFi (WPA2/WPA3)
5. ✅ Mettre à jour RouterOS
6. ✅ Configurer l'accès à distance sécurisé (si nécessaire)

### Commandes de sécurisation rapide :
```bash
# Changer le mot de passe admin
/user set admin password=VotreMotDePasseSecurise

# Désactiver les services non nécessaires
/ip service disable telnet,ftp,www

# Activer uniquement HTTPS
/ip service enable www-ssl
```

---

**Besoin d'aide pour une étape particulière ou pour la configuration après le reset ?**
