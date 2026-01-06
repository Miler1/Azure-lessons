# Logar no Azure
Connect-AzAccount

# Parametros Gerais
$rg = 'rg-vmwin'
$local = 'brazilsouth'

# Parametros VMs
$vm = 'vm-win'
$sku = 'Standard_E2s_v3' # brazilsouth
$ip = 'ip-vm'
$azurevmpublisher = 'MicrosoftWindowsServer'
$azurevmoffer = 'WindowsServer'
$imgversion = '2019-Datacenter'

# Parametros - Credenciais
$user = 'azureuser'
$pass = ConvertTo-SecureString 'tr@ining2023' - AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)

# Criar Grupo de Recursos
New-AzResourceGroup -Name $rg -Location $local

# Criar VNET e Subnet da VM
$snetvm = New-AzVirtualNetworkSubnetConfig -Name "default" -AddressPrefix 192.168.1.0/24
$vnet = New-AzVirtualNetwork - ResourceGroupName $rg -Location $local -Name "vnet-vm" -AddressPrefix 192.168.1.0/16 -Subnet $snetvm

# Criar IP Publico da VM
$pip = New-AzPublicIpAddress - ResourceGroupName $rg -Location $local -Name $ip -AllocationMethod Static -IdleTimeoutInMinutes 4

# regra para Liberar Acesso RDP na VM
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name "allowRDP" -Protocol "Tcp" `
    -Direction "Inbound" -Priority 100 -SourceAddressPrefix "Internet" -SourcePortRange * -DestinationAddressPrefix * `
    -DestinationPortRange 3389 -Access Allow

# criar NSG com a Regra
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $local -Name "nsg-vm" -SecurityRules $nsgRuleRDP

# Criar Network Interface (NIC)
$nic = New-AzNetworkInterface -Name "nic-vm" -ResourceGroupName $rg -Location $local -SubnetId $vnet.Subnets[0].Id -PublicIpAddressName $pip.Id -NetworkSecurityGroupId $nsg.Id

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $local -Name "nsg-vm" -SecurityRules $nsgSSH, $nsgHTTP

$vmconfig = New-AzVMConfig -VMName $vm -VMSize $sku 
$vmconfig = Set-AzVmOperatingSystem $vmconfig -Windows -ComputerName $vm -Credential $cred
$vmconfig = Add-AzVMNetworkInterface -VM $vmconfig -Id $nic.Id
$vmconfig = Set-AzVMBootDiagnostic -VM $vmconfig -Disable
$vmconfig = Set-azVMSourceImage -VM $vmconfig -PublisherName $azurevmpublisher -Offer $azurevmoffer -Skus $img -Version "latest" 

# Criar VM com configurações declaradas
New-AzVM -ResourceGroupName $rg -Location $local -VM $vmconfig

# Excluir Politica de Liberacao RDP na porta 3389
Remove-AzNetworkSecurityRuleConfig -Name $nsgRuleRDP.Name -NetworkSecurityGroup $nsg
$nsg | Set-AzNetworkSecurityGroup

# bastion host
# Adicionar Subnet
$snetbastion = New-AzVirtualNetworkSubnetConfig -Name "AzureBastionSubnet" -AddressPrefix 10.0.1.0/26
$vnet.Subnets.Add($snetbastion)
$vnet = Set-AzVirtualNetwork -VirtualNetwork $vnet

# Criar Bastion
New-AzBastion -ResourceGroupName $rg -Name "ip-bastion" -Location $local -AllocationMethod Static -Sku Standard

# Excluir Grupo de Recursos
Remove-AzResourceGroup -Name $rg

