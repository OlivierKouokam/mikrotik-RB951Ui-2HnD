# Configuration Multi-WAN MikroTik RB951Ui-2HnD

## PARTIE 2 : Script RouterOS Équivalent

Copiez ce script et collez-le dans **New Terminal** de Winbox :
```routeros
# ========================================
# Configuration Multi-WAN RB951Ui-2HnD
# ========================================

# 1. Retirer ether2 et ether3 du bridge
/interface bridge port
remove [find interface=ether2]
remove [find interface=ether3]

# 2. Configuration des adresses IP
/ip address
add address=192.168.8.50/24 interface=ether2 comment="WAN2-Box1"
add address=192.168.80.50/24 interface=ether3 comment="WAN3-Box2"

# 3. Configuration des routes par défaut
/ip route
add dst-address=0.0.0.0/0 gateway=192.168.8.1 distance=2 comment="WAN2-Default"
add dst-address=0.0.0.0/0 gateway=192.168.80.1 distance=3 comment="WAN3-Default"

# 4. Configuration du NAT pour chaque WAN
/ip firewall nat
add chain=srcnat out-interface=ether2 action=masquerade comment="NAT-WAN2"
add chain=srcnat out-interface=ether3 action=masquerade comment="NAT-WAN3"

# 5. Mangle pour marquer le trafic vers les box
/ip firewall mangle
add chain=prerouting src-address=192.168.88.0/24 dst-address=192.168.8.1 \
    action=mark-routing new-routing-mark=to_box1 passthrough=yes \
    comment="Route-to-Box1"
    
add chain=prerouting src-address=192.168.88.0/24 dst-address=192.168.80.1 \
    action=mark-routing new-routing-mark=to_box2 passthrough=yes \
    comment="Route-to-Box2"

# 6. Routes spécifiques pour le trafic marqué
/ip route
add dst-address=192.168.8.1/32 gateway=192.168.8.1 routing-mark=to_box1 \
    comment="Force-to-Box1"
    
add dst-address=192.168.80.1/32 gateway=192.168.80.1 routing-mark=to_box2 \
    comment="Force-to-Box2"

# 7. Afficher la configuration finale
:put "Configuration terminée !"
:put "Vérification des routes :"
/ip route print
```
