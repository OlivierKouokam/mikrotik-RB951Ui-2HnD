
# Configuration Multi-WAN MikroTik RB951Ui-2HnD

## 🎯 Besoin Initial

Configurer un routeur MikroTik RB951Ui-2HnD avec :
- **3 connexions Internet** (box sur ether1, ether2, ether3)
- **Accès garanti** aux interfaces de gestion des box (192.168.8.1 et 192.168.80.1)
- **Failover automatique** : basculement si un WAN tombe
- **Pas de conflit** entre le routage forcé et le load balancing
  
ether1 (distance=1) → PRIORITAIRE ✓ Utilisé à 100%
ether2 (distance=2) → Backup (utilisé seulement si ether1 tombe)
ether3 (distance=3) → Backup du backup (utilisé si ether1 ET ether2 tombent)

```

### Répartition du trafic Internet :

- ✅ **100% via ether1** tant qu'il fonctionne
- ✅ **0% via ether2 et ether3** (en standby)
- ✅ Basculement automatique uniquement en cas de panne

### Schéma :

┌─────────────┐
│ Trafic LAN  │
└──────┬──────┘

       │
       ├──> ether1 (WAN1) ████████████ 100% ✓
       │
       ├──> ether2 (WAN2) ............ 0% (en attente)
       │
       └──> ether3 (WAN3) ............ 0% (en attente)

```
