#https://docs.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-powershell
# This link gives examples of the following script before the changes we made. See notes.
# update obvious names to something that makes sense for the user

$rgName = 'my_rg'
$vmName = 'myVM'
$location = 'East US'

Login-AzureRmAccount

New-AzureRmResourceGroup -Name $rgName -Location $location

New-AzureRmVm `
    -ResourceGroupName $rgName `
    -Name $vmName   `
    # Make sure to set this size rather than leaving to default
    -Size "Standard_B1S"   `
    -Location $location `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -OpenPorts 80,3389  

#https://docs.microsoft.com/en-us/azure/virtual-machines/windows/attach-disk-ps
# This link gives examples of the following script before the changes we made. See notes.
 
#Make sure to change from PremiumLRS to StandardLRS
$storageType = 'StandardLRS'
$dataDiskName = $vmName + '_datadisk1'

#Make sure to set -DiskSizeGB to 32
$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $location -CreateOption Empty -DiskSizeGB 32
$dataDisk1 = New-AzureRmDisk -DiskName $dataDiskName -Disk $diskConfig -ResourceGroupName $rgName

$vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName 
$vm = Add-AzureRmVMDataDisk -VM $vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun 1

Update-AzureRmVM -VM $vm -ResourceGroupName $rgName