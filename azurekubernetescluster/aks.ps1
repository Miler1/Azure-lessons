# Logar no Azure
Connect-AzAccount

# Parametros Gerais
$rg = 'rg-aks-pwsh'
$local = 'East US'
$aks = 'aks-powershell'

# Criar Grupo de Recursos
New-AzResourceGroup -Name $rg -Location $local

# Criar o AKS 
New-AzAksCluster -ResourceGroup $rg -Name $aks -NodeCount 1

# Listar Clusters do AKS
Get-AzAksCluster

# Instalar Kubectl
Install-AzAksKubectl

# Importar Credenciais
Get-AzAksCredential -ResourceGroup $rg -Name $aks

# Listar nodes com kubectl
kubectl get nodes

# Excluir AKS
Remove-AzAksCluster ResourceGroup $rg -Name $aks