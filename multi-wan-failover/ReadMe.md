
# Configuration Multi-WAN MikroTik RB951Ui-2HnD

## 🎯 Besoin Initial

Configurer un routeur MikroTik RB951Ui-2HnD avec :
- **3 connexions Internet** (box sur ether1, ether2, ether3)
- **Accès garanti** aux interfaces de gestion des box (192.168.8.1 et 192.168.80.1)
- **Failover automatique** : basculement si un WAN tombe
  
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

### 📡 SCHÉMA 1 : ARCHITECTURE PHYSIQUE

```

┌──────────────────────────────────────────────────────────────┐
│                      MIKROTIK RB951Ui                        │
│                                                              │
│  ┌─────────┐  ┌─────────┐  ┌──────────┐  ┌─────────────────┐ │
│  │ ether1  │  │ ether2  │  │ ether3   │  │    bridge       │ │
│  │  WAN1   │  │  WAN2   │  │  WAN3    │  │   (LAN)         │ │
│  │  DHCP   │  │192.168.8│  │192.168.80│  ├─────┬─────┬─────┤ │
│  └────┬────┘  └────┬────┘  └───┬──────┘  │eth4 │eth5 │wlan1│ │
│       │            │           │         └─────┴─────┴─────┘ │
└───────┼────────────┼───────────┼─────────────────────────────┘
        │            │           │
        ▼            ▼           ▼
   ┌─────────┐  ┌─────────┐  ┌──────────┐
   │ BOX 1   │  │ BOX 2   │  │ BOX 3    │
   │  FAI    │  │192.168.8│  │192.168.80│
   │         │  │   .1    │  │   .1     │
   └─────────┘  └─────────┘  └──────────┘

```

### SCHÉMA 2 : STRATÉGIE DE ROUTAGE

```

┌─────────────────────────────────────────────────┐
│            DÉCISION DE ROUTAGE                  │
│                                                 │
│  Client LAN (192.168.88.x) veut accéder à:      │
│                                                 │
│  ┌─────────────────┬─────────────┬────────────┐ │
│  │  DESTINATION    │   ACTION    │  INTERFACE │ │
│  ├─────────────────┼─────────────┼────────────┤ │
│  │ 192.168.8.1     │ROUTAGE FORCÉ│   ether2   │ │
│  │ 192.168.80.1    │ROUTAGE FORCÉ│   ether3   │ │
│  │ Internet normal │  PRIORITÉ   │   ether1   │ │
│  │ (si ether1 down)│   BACKUP    │   ether2   │ │
│  │ (si ether2 down)│BACKUP BACKUP│   ether3   │ │
│  └─────────────────┴─────────────┴────────────┘ │
└─────────────────────────────────────────────────┘

```
