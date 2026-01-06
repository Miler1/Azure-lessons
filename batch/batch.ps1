Connect-AzureRmAccount

$gruporecurso = "AZURE-TREINAMENTO-BATCH"
$localizacao = "centralus"
$storageNome = "storagetreinamentops"

$storage = New-AzureRmStorageAccount -Name $storageNome -ResourceGroupName $gruporecurso -Location $localizacao -SkuName "Standard_LRS" -Kind "StorageV2"

New-AzureRmBatchAccount -ResourceGroupName $gruporecurso -AccountName "batchtreinamentops" -Location $localizacao -AutoStorageAccountId $storage.Id