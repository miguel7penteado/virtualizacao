
+--+--------+--------------------------------+
| host                                       |
|                                            |
++------------+                              +
| vm0         |                              |
|   veth0     |                              |
|192.168.3.x  |                              |
++-----------++                              +
|            |                               |
+            |     +---+----+-------+        |
|            +-----+switch1         |        |
|                  |192.168.77.1/24 |        |
+                  ++--+----+-------+        |
|                      |                     |
+                  +---+-----+               |
|                  |vlan1    |               |
+                  +---+-----+               |
|                      |                     |
|                 +----+-------+             |
|                 +  eth0      |             |
|                 |            |
|                 +------------+             |
+-----------------+------------+-------------+

# 1. gerando a  vlan1 usando a ferramenta ifconfig e vconfig
ifconfig eth0 up
vconfig add eth0 1
#ifconfig eth0.1 192.168.77.1 netmask 255.255.255.0
ifconfig eth0.1 up
ifconfig eth0.1 down
vconfig rem eth0.1

# Gerando a vlan1 usando a ferramenta ip
ip link set eth0 up
ip link add link eth0 name vlan1 type vlan id 1
#ip addr add 192.168.1.1/24 dev vlan1
#ip link set vlan1 down
#ip link delete vlan1

# cria a rede da maquina virtual vm0
ip netns add vm0
# cria conector interno externo
# nome externo vm0c0 nome interno vm0eth0
ip link add name vm0c0 type veth peer name vm0eth0
# vm0eth0 fica dentro de vm0
ip link set vm1eth0 netns vm0

# Configura maquina placa de rede de maquina virtual
ip netns exec vm0  ifconfig -a
#ip netns exec vm0  dhclient -v vm0eth0
ip netns exec vm0 ifconfig vm0eth0 up
ip netns exec vm0 ip link add link vm0eth0 name vm0vlan1 type vlan id 1
ip netns exec vm0 ip addr add 192.168.1.1/24 dev vm0vlan1
ip netns exec vm0 ip set vm0vlan1 up

# adiciona o switch1 
brctl addbr switch1
brctl addif switch1 vlan1
ip link set vlan1 up
# adiciona vm0c0 no switch1
brctl addif switch1 vm0c0
# ativa o link vm0c0
ip link set vm0c0 up
ip addr add 192.168.1.1/24 dev switch1
ip set switch1 up


