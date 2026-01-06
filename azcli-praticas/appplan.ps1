# Login na conta do Azure com Azure Powershell
Connect-AzAccount -UseDeviceAuthentication

# Parametros Gerais
$rg = 'gruporecurso-pwsh'
$local = 'brazilsouth'

# Criar Grupo de Recursos 
New-AzResourceGroup -Name $rg -Location $local

# Criar App Service Plan da maneira mais simplificada 
New-AzAppServicePlan -ResourceGroupName $rg -Name "plan-pwsh" -Location $local

# Mostrar Detalhes do App Plan
Get-AzAppServicePlan -ResourceGroupName $rg -Name "plan-pwsh"

# Listando todos os App Service Plans
Get-AzAppServicePlan

# Excluindo App Service Plan
Remove-AzAppServicePlan -ResourceGroupName $rg -Name "plan-pwsh"

# Criar App Service Plan com Plano Basic
New-AzAppServicePlan -ResourceGroupName $rg -Name "plan-pwsh" -Location $local -Tier Basic

# Atualizar App Service Plan com Plano Free
Set-AzAppServicePlan -ResourceGroupName $rg -Name "plan-pwsh" -Location $local -Tier Free

# Excluindo App Service Plan
Remove-AzAppServicePlan -ResourceGroupName $rg -Name "plan-pwsh"

# Excluir Grupo Recursos
Remove-AzResourceGroup -Name $rg