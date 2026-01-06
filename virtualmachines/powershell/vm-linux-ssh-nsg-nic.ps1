# Logar no Azure
Connect-AzAccount

# Parametros
$rg = 'rg-vmlinux'
$local = 'brazilsouth'
$vm = 'vm-ubuntu'
$sku = 'Standard_E2s_v3' # brazilsouth
$img = 'Ubuntu'
$imgversion = '2204'

# Criar Grupo de Recursos
New-AzResourceGroup -Name $rg -Location $local

# Criar VNET e Subnet da VM
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name "snet-vm" -AddressPrefix 192.168.1.0/24
$vnet = New-AzVirtualNetwork - ResourceGroupName $rg -Location $local -Name "vnet-vm" -AddressPrefix 192.168.1.0/16 -Subnet $subnetConfig

# Criar IP Publico da VM
$pip = New-AzPublicIpAddress - ResourceGroupName $rg -Location $local -AllocationMethod Static -Name "ip-publico"

# Criar Network Security Group - Regras SSH e HTTP
$nsgSSH = New-AzNetworkSecurityRuleConfig -Name "nsgSSH" -Protocol "Tcp" -Direction "Inbound" -Priority 1000 -SourceAddressPrefix * `
    -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 -Access "Allow"

$nsgHTTP = New-AzNetworkSecurityRuleConfig -Name "nsgHTTP" -Protocol "Tcp" -Direction "Inbound" -Priority 1100 -SourceAddressPrefix * `
    -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 -Access "Allow"

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $local -Name "nsg-vm" -SecurityRules $nsgSSH, $nsgHTTP

# Criar NIC
$nic = New-AzNetworkInterface -Name "nic-vm" -ResourceGroupName $rg -Location $local -SubnetId $vnet.Subnets[0].Id -PublicIpAddressName $pip.Id -NetworkSecurityGroupId $nsg.Id

# Criar Maquina Virtual do Azure 
$user = 'azureuser'
$pass = ConvertTo-SecureString 'tr@ining2023' - AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)

$vmconfig = New-AzVMConfig -VMName $vm -VMSize $sku | Set-AzVmOperatingSystem -Linux -ComputerName $vm `
    -Credential $cred -DisablePasswordAuthentication | Set-azVMSourceImage -PublisherName "Canonical" `
    -Offer $img -Skus $imgversion -Version "latest" | Add-AzVMNetworkInterface -Id $nic.Id

# Configurar chave SSH
$sshKey = cat ~/.ssh/id_rsa.pub
Add-AzVMSshPublicKey -VM $vmconfig -KeyData $sshKey -Path "/home/azureuser/.ssh/authorized_keys"

# Criar VM 
New-AzVM -ResourceGroupName $rg -Location $local -VM $vmconfig

# Obter IP Publico 
Get-AzPublicIpAddress -Name "ip-publico" -ResourceGroupName $rg | Select-Object IpAddress

# Acessar via SSH - Porta 22 liberada no NSG
ssh -i $sshKey azureuser@20.226.253.50

# Instalar NGINX Web Server
sudo apt-get update && sudo apt-get install -y nginx 

curl 20.226.253.50

# Excluir Grupo de Recursos
Remove-AzResourceGroup -Name $rg

