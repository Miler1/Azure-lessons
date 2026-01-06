# Login no Azure
Connect-AzAccount

# Parametros
$rg = 'rg-vmlinux'
$local = 'brazilsouth'
$vm = 'vm-ubuntu'
$sku = 'Standard_E2s_v3' # brazilsouth
$img = 'Ubuntu2204'
$nsg = 'nsg-vm'
$user = 'azureuser'
$pass = ConvertTo-SecureString 'tr@ining2023' - AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
$ip = 'ip-vm'

# Criar Grupo de Recursos
New-AzResourceGroup -Name $rg -Location $local

# Criar Maquina Virtual com Windows Server 
New-AzVM -Name $vm -ResourceGroupName $rg -Credential $cred -Image $img -PublicIpAddressName $ip -Size $sku -Location $local

# Excluir Grupo de Recursos
Remove-AzResourceGroup -Name $rg