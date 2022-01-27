# Configurando roteadomento ospf com quagga em openwrt virtualizado em hyper-v

Atualize a lista de pacotes do openwrt
```bash
opkg update
```

Instale todos os pacotes necessários do software roteador quagga disponíveis na plataforma openwrt
```bash
opkg install quagga quagga-libospf quagga-libzebra quagga-ospfd quagga-vtysh quagga-zebra
```

Entre na interface de comando vtysh
```bash
vtysh
```

Chame o modo de configuração
```bash
conf t
```

Dentro do terminal de configuração entre no menu de roteamento ospf
```bash
router ospf
```

Configure uma area OSPF
```bash
network xxx.xxx.xxx.xxx/yyy area 0.0.0.1
```

Escreva a configuração na memória do quagga
```bash
do wr
```

saia dos modos de configuração do roteador ospf, do terminal de configuração do quagga e do vtysh respectivamente 
```bash
exit
exit
exit
```

Finalmente reinicie o serviço quagga no openwrt
```bash
/etc/init.d/quagga restart
```


