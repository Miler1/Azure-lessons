# Login na conta do Azure com Azure Powershell
Connect-AzAccount -UseDeviceAuthentication

# Parametros Gerais
$rg = 'gruporecurso-pwsh'
$local = 'brazilsouth'

# Criar Grupo de Recursos 
New-AzResourceGroup -Name $rg -Location $local

# Criar App Service Plan da maneira mais simplificada 
New-AzAppServicePlan -ResourceGroupName $rg -Name "plan-pwsh" -Location $local

# Criar App Service com Plano Basic
New-AzAppServicePlan -ResourceGroupName $rg -Name "apservicetrein9834" -Location $local -AppServicePlan "plan-pwsh"

# Detalhes do App Service
Get-AzWebApp -ResourceGroupName $rg -Name "apservicetrein9834"

# Stop do App Service
Stop-AzWebApp -ResourceGroupName $rg -Name "apservicetrein9834"

# Start do App Service
Start-AzWebApp -ResourceGroupName $rg -Name "apservicetrein9834"

# Restart do App Service
Restart-AzWebApp -ResourceGroupName $rg -Name "apservicetrein9834"

# Remove App Service
Remove-AzWebApp -ResourceGroupName $rg -Name "apservicetrein9834"