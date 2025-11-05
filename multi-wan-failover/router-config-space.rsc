# nov/05/2025 11:25:33 by RouterOS 6.49.14

# software id = N1KN-1HZ2

#

# model = 951Ui-2HnD

# serial number = HDD084QQZTR

/interface bridge

add admin-mac=18:FD:74:F1:8C:B6 auto-mac=no comment=defconf name=bridge

/interface wireless

set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-XX disabled=\

    no distance=indoors frequency=auto installation=indoor mode=ap-bridge ssid=\

    MikroTik-F18CBA wireless-protocol=802.11

/interface list

add comment=defconf name=WAN

add comment=defconf name=LAN

/interface wireless security-profiles

set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys \

    supplicant-identity=MikroTik wpa-pre-shared-key=P@ssw0rd wpa2-pre-shared-key=\

    P@ssw0rd

/ip pool

add name=default-dhcp ranges=192.168.88.10-192.168.88.254

/ip dhcp-server

add address-pool=default-dhcp disabled=no interface=bridge name=defconf

/interface bridge port

add bridge=bridge comment=defconf interface=ether4

add bridge=bridge comment=defconf interface=ether5

add bridge=bridge comment=defconf interface=wlan1

/ip neighbor discovery-settings

set discover-interface-list=LAN

/interface list member

add comment=defconf interface=bridge list=LAN

add comment=defconf interface=ether1 list=WAN

/ip address

add address=192.168.88.1/24 comment=defconf interface=bridge network=192.168.88.0

add address=192.168.8.50/24 comment=WAN2-Box1 interface=ether2 network=192.168.8.0

add address=192.168.80.50/24 comment=WAN3-Box2 interface=ether3 network=\

    192.168.80.0

/ip dhcp-client

add comment=defconf disabled=no interface=ether1

/ip dhcp-server network

add address=192.168.88.0/24 comment=defconf dns-server=192.168.88.1 gateway=\

    192.168.88.1

/ip dns

set allow-remote-requests=yes

/ip dns static

add address=192.168.8.50 comment=defconf name=router.lan

/ip firewall filter

add action=accept chain=input comment=\

    "defconf: accept established,related,untracked" connection-state=\

    established,related,untracked

add action=drop chain=input comment="defconf: drop invalid" connection-state=\

    invalid

add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp

add action=accept chain=input comment=\

    "defconf: accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1

add action=drop chain=input comment="defconf: drop all not coming from LAN" \

    in-interface-list=!LAN

add action=accept chain=forward comment="defconf: accept in ipsec policy" \

    ipsec-policy=in,ipsec

add action=accept chain=forward comment="defconf: accept out ipsec policy" \

    ipsec-policy=out,ipsec

add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \

    connection-state=established,related

add action=accept chain=forward comment=\

    "defconf: accept established,related, untracked" connection-state=\

    established,related,untracked

add action=drop chain=forward comment="defconf: drop invalid" connection-state=\

    invalid

add action=drop chain=forward comment="defconf: drop all from WAN not DSTNATed" \

    connection-nat-state=!dstnat connection-state=new in-interface-list=WAN

/ip firewall mangle

add action=mark-routing chain=prerouting comment=Route-to-Box1 dst-address=\

    192.168.8.1 new-routing-mark=to_box1 passthrough=yes src-address=\

    192.168.88.0/24

add action=mark-routing chain=prerouting comment=Route-to-Box2 dst-address=\

    192.168.80.1 new-routing-mark=to_box2 passthrough=yes src-address=\

    192.168.88.0/24

/ip firewall nat

add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=\

    out,none out-interface-list=WAN

add action=masquerade chain=srcnat comment=NAT-WAN2 out-interface=ether2

add action=masquerade chain=srcnat comment=NAT-WAN3 out-interface=ether3

/ip route

add comment=Force-to-Box1 distance=1 dst-address=192.168.8.1/32 gateway=192.168.8.1 \

    routing-mark=to_box1

add comment=Force-to-Box2 distance=1 dst-address=192.168.80.1/32 gateway=\

    192.168.80.1 routing-mark=to_box2

add check-gateway=ping comment=LB-Route-WAN2 distance=1 gateway=192.168.8.1 \

    routing-mark=to_wan2

add check-gateway=ping comment=LB-Route-WAN3 distance=1 gateway=192.168.80.1 \

    routing-mark=to_wan3

add comment=WAN3-Default distance=3 gateway=192.168.80.1

add comment=WAN2-Default disabled=yes distance=2 gateway=192.168.8.1

/system clock

set time-zone-name=Africa/Douala

/system identity

set name=MikroTik-MultiWAN

/tool mac-server

set allowed-interface-list=LAN

/tool mac-server mac-winbox
