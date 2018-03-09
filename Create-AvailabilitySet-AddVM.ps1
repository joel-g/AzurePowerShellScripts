$testName = "arjunrg"
$resourceGroupName = $testName
$location = "westus"
$domainName = "arjunrg1"
$subnetName = "Subnet-2"
$publisher = "MicrosoftWindowsServer"
$offer = "WindowsServer"
$sku = "2016-Datacenter"
$version = "latest"
$cred = Get-Credential
Get-AzureRmResourceGroup -Name $resourceGroupName -Location $location
$vip = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName -Name "VIP2" `
 -Location $location -AllocationMethod Dynamic -DomainNameLabel $domainName

$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName `
-AddressPrefix "10.12.0.0/24"

$vnet = Get-AzureRmVirtualNetwork -Name "VNET" `
 -Subnet $subnet

$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

$nic2 = New-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName `
-Name "nic2" -Subnet $subnet -Location $location

#New-AzureRmAvailabilitySet -ResourceGroupName $resourceGroupName `
#-Name "AVSet" -Location $location

$avset = Get-AzureRmAvailabilitySet -ResourceGroupName $resourceGroupName -Name "AVSet"

New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
-Name $testName -Location $location -Type Standard_LRS

Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName 

$vmName = "arjunrg-vmas2"

$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_A1" `
 -AvailabilitySetId $avSet.Id |
Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName `
-Credential $cred -ProvisionVMAgent -EnableAutoUpdate  |
Set-AzureRmVMSourceImage -PublisherName $publisher -Offer $offer -Skus $sku `
-Version $version |
Set-AzureRmVMOSDisk -Name $vmName -VhdUri "https://$testName.blob.core.windows.net/vhds/$vmName-os.vhd" `
-Caching ReadWrite -CreateOption fromImage  |
Add-AzureRmVMNetworkInterface -Id $nic2.Id

 New-AzureRmVM -ResourceGroupName $resourceGroupName -Location $location `
-VM $vmConfig


