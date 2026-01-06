# Criação de Rede Virtual do Azure
New-AzVirtualNetwork
    -Name MyVnet
    -ResourceGroupName RG
    -AddressPrefix 10.0.0.0/16

# Adicionar subnet na Rede Virtual do Azure
Add-AzVirtualNetworkSubnetConfig
    -Name SUBNET 
    -AddressPrefix 10.0.1.0/24
    -VirtualNetwork
        (Get-AzVirtualNetwork
            -Name VNET 
            -ResourceGroupName RG)
| Set-AzVirtualNetwork

# Listar subnets na Rede Virtual do Azure
(Get-AzVirtualNetwork
    -Name MyVnet
    -ResourceGroupName RG).Subnets

# Atualizar Subnets na Rede Virtual do Azure
$subnet = Get-AzVirtualNetworkSubnetConfig
    -Name MySubnet 
    -VirtualNetwork
        (Get-AzVirtualNetwork
            -Name VNET 
            -ResourceGroupName RG)
$subnet.AddressPrefix = "10.0.2.0/24"
Set-AzVirtualNetwork -VirtualNetwork
    (Get-AzVirtualNetwork
        -Name VNET
        -ResourceGroupName RG)
        -AddressPrefix = "10.0.0.0/16"
        -Subnet $subnet

# Excluir subnets na Rede Virtual do Azure
Remove-AzVirtualNetworkSubnetConfig
    -Name SUBNET
    -VirtualNetwork
        (Get-AzVirtualNetwork
            -Name VNET
            -ResourceGroupName RG)
| Set-AzVirtualNetwork

# Incluir N Subnets na Rede Virtual do Azure
$vnet = New-AzVirtualNetwork
    -Name VNET 
    -ResourceGroupName RG
    -AddressPrefix 10.0.0.0/16
Add-AzVirtualNetworkSubnetConfig
    -Name FrontEnd
    -AddressPrefix 10.0.1.0/24
    -VirtualNetwork $vnet
Add-AzVirtualNetworkSubnetConfig
    -Name BackEnd
    -AddressPrefix 10.0.2.0/24
    -VirtualNetwork $vnet
Set-AzVirtualNetwork -VirtualNetwork $vnet

# Criar Virtual Network Gateway
New-AzVirtualNetworkGateway
    -Name VNETGateway 
    -ResourceGroupName RG
    -Location "East US"
    -IpConfigurations $gwipconfig
    -GatewayType Vpn
    -VpnType RouteBased
    -GatewaySku VpnGw1