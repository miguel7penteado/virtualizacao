# VirtualBox



Este artigo é relativo à configuração do Virtualbox no Debian Stretch. Para informações relativas à configuração no Debian Jessie, acesse este [artigo]([.:virtualbox_jessie|outro)].

## Instalação 



O repositório do Debian Stretch não disponibiliza um pacote para o Virtualbox. Entretanto, é possível instalá-lo adicionando o repositório do Virtualbox conforme descrito em [e repetido abaixo:

* Para adicionar o repositório do Virtualbox cria-se um arquivo ''/etc/apt/sources.list.d/virtualbox.list'' com o conteúdo:
```bash
  deb http://download.virtualbox.org/virtualbox/debian stretch contrib
```

* Para adicionar a chave do repositório:
```bash
  wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
  apt-key add oracle_vbox_2016.asc
```

* Após adicionada a chave, basta atualizar os repositórios e instalar o pacote:
```bash
  apt-get update
  apt-get install virtualbox-5.1
```

Após a instalação do VirtualBox, basta abrir o gerenciador de máquinas virtuais através do menu de aplicações ou do comando *virtualbox*. No gerenciador de aplicações pode-se criar as máquinas virtuais, reservando um espaço em disco, que pode ser alocado dinamicamente. Por padrão, os dados das máquinas virtuais são armazenados no diretório ''~/Virtualbox VMs''.

## Detalhes da configuração da rede 



A configuração básica de rede do VirtualBox faz com que a máquina virtual acesse a rede através de um roteador virtual criado pelo sistema, que disponibiliza endereços na rede 10.0.2.0/24. É possível acessar a rede através do sistema da máquina virtual mas a máquina virtual fica isolada da rede local. Para possibilitar a execução de serviços de rede na máquina virtual, é importante que seja possível acessá-la a partir da rede local.

Nas versões acima de 2.0 do Virtualbox, é possível configurá-lo diretamente para usar a placa de rede em modo //bridge//, bastando selecionar a interface desejada, para que a máquina virtual possa ter um endereço na faixa da rede local e tornar-se acessível a partir da rede externa.

Com VMs Windows, também é possível utilizar o //Guest Additions// para configurar uma pasta compartilhada com o host. Após instalar o //Guest Additions//, basta acessar o menu Dispositivos->Pastas Compartilhadas->Configuração de Pastas Compartilhadas. O compartilhamento aparece no Windows com o nome de ''VBOXSVR''.

## Adicionando usuário ao grupo da gerenciamento da Máquinas Virtuais

```bash
sudo usermod -a -G vboxusers meu_usuario
```

## Ativando virtualização dentro das máquinas virtuais

```bash
# Lista máquinas virtuais
VBoxManage list vms
```

```bash
vboxmanage modifyvm "vm1" --nested-hw-virt on
```

## Mapeando dispositivos USB do hardware real para máquina virtual

```bash
# Lista máquinas virtuais
VBoxManage list vms
```

```bash
# Lista conexões USB no hardware real
VBoxManage list usbhost
```
```bash
# Mapeia uma conexão USB na máquina virtual
VBoxManage controlvm nome_maquina_virtual usbattach identificador_dispositivo_usb
```



## Comandos para gerenciamento de máquinas virtuais a partir da linha de comando 

O VirtualBox disponibiliza alguns comandos para o gerenciamento das máquinas virtuais. Seguem alguns:

* Para ligar uma máquina virtual, pode-se utilizar o comando ''VBoxHeadless'':
```bash
  VBoxHeadless --startvm <nome da máquina virtual>
```

* Para desligar uma máquina virtual simulando o acionamento do botão power, pode-se utilizar o comando:
```bash
  VBoxManage controlvm <nome da máquina virtual> acpipowerbutton
```

* Para desligar uma máquina virtual de maneira forçada, pode-se utilizar o comando:
```bash
  VBoxManage controlvm <nome da máquina virtual> poweroff
```

* Para listar as máquinas virtuais disponíveis:
```bash
  VBoxManage list vms
```

* Para listar as máquinas virtuais em execução:
```bash
  VBoxManage list runningvms
```

## Comandos para gerenciamento de discos 

* Para redimensionar uma imagem de disco:
```bash
  VBoxManage modifyhd <arquivo de imagem> --resize <tamanho em MB>
```

## Mapear Discos físicos como imagens VMDK

* No Linux
```
# Supondo que você queira criar um disco chamado disco3.vmdk que mapeie todo o dispositivo de disco /dev/sdc
vboxmanage createmedium disk --filename=disco3.vmdk  --format=VMDK --variant RawDisk --property RawDrive=/dev/sdc
```


## Execução automática da máquina virtual 

### Usando um serviço do system.d 

É possível criar um serviço do //system.d// para iniciar automaticamente uma máquina virtual. Serviços personalizados do //system.d// costumam ficar no diretório ''/etc/systemd/system''. Segue um exemplo de um arquivo de configuração de um serviço para iniciar uma máquina virtual chamada ''debian-vm'' do usuário ''administrador'':

Arquivo ''/etc/systemd/system/debian-vm.service''
```bash
<file>
[Unit]([https://wiki.debian.org/VirtualBox#Debian_9_.22Stretch.22]])
Description=Virtualbox Headless VM

[Type=idle
ExecStart=/usr/bin/VBoxHeadless --startvm debian_vm
ExecStop=/usr/bin/VBoxManage controlvm debian_vm acpipowerbutton
User=administrador

[Install](Service])
WantedBy=multi-user.target
</file>
```

## Usando um script 

Se desejado, uma máquina virtual pode ser iniciada diretamente com o comando:
```bash
  vboxsdl -vm nome-da-máquina
```

Incluindo esse comando num //script// de execução automática do gerenciador de janelas utilizado, é possível iniciar automaticamente uma máquina virtual quando o sistema é iniciado. No //WindowMaker//, basta editar o arquivo ''~/GNUstep/Library/WindowMaker/autostart'' e adicionar a linha de comando acima seguida de '&', para execução em segundo plano (se não for executado em segundo plano, a máquina virtual não é iniciada no //WindowMaker//). Caso o arquivo ''autostart'' não exista, basta criá-lo com permissões de leitura, escrita e execução para o usuário em questão.

## Referências 
[liria](https://www.liria.com.br/wiki/doku.php?id=wiki:linux:config:virtualbox:virtualbox)

# Rede Virtualizada - Linux
Estudos de virtualização de ambientes computacionais
## Definindo uma rede por software - Linux
### Modo antigo - o Bridge não emula uma switch e não filtra Vlan
![](https://github.com/miguel7penteado/virtualizacao/blob/master/under-the-hood-scenario-1-linuxbridge-compute.png)
![](https://github.com/miguel7penteado/virtualizacao/blob/master/bridge_original.png)

### Modo novo - o Bridge emula um switch e filtra Vlans
![](https://github.com/miguel7penteado/virtualizacao/blob/master/bridge_current.png)

#Referência:
[RedHad](https://developers.redhat.com/blog/2017/09/14/vlan-filter-support-on-bridge/)

[OpenVSwitch-VirtualBox](https://ariscahyadi.wordpress.com/2013/07/16/virtual-networking-for-virtualbox-using-open-vswitch/)
[Hyper-V_Switch](https://www.altaro.com/hyper-v/virtual-networking-configuration-best-practices/)

