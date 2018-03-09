$rgname = "arjunrg" 
$loc = "west us " 
$vmsize = "Standard_B1_V2" 
$vmname = "arjunvm1" 
$ASname = "Availabilty Set Name" 

$AvailabiltySet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgname -Name $ASname 
$vm = New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize -AvailabilitySetId $AvailabiltySet.Id 




New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $vm 


