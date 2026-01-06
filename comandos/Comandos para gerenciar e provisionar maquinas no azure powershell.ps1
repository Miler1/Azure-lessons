# Criando um novo cluster do aks pelo powershell
New-AzAksCluster -ResourceGroupName <String>
                 -ClusterName <String>
                 -Name <String>

# Adicionar nodes no cluster do aks com powershell
New-AzAksNodePool -ResourceGroupName <String>
                 -ClusterName <String>
                 -Name <String>

# Iniciar cluster do aks
Start-AzAksCluster 
    -Name <String>
    -ResourceGroupName <String>
 
# Parar cluster do aks
Stop-AzAksCluster 
    -Name <String>
    -ResourceGroupName <String>