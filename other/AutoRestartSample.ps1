# Program of restarting VM
# update 2016/12/31

###########################################################################################
# please set your Id from AAD app(See azure portal)
# see. https://blogs.technet.microsoft.com/jpaztech/2016/02/23/azure-powershell-autologin/

# keyid like XBQzKZGcMz7dpmi0W7KNhuncaopiUeakgpa381od2Is4=
$keyId_from_aadapp = ""
# weburi like https://microsoft.onmicrosoft.com/2170b886-b1ae-4bf43a108-d8eec87905e1
$web_uri_from_aadapp = ""
# tenantid like 34f988bf-21f1-41af-91ab-5d7cd911jb43
$tenant_id_from_aadapp = ""
# please set your ResourceGroup Name and target VM name
$rg_name = ""
$target_vm_name = ""

###########################################################################################

# auto login for ARM
$secpasswd = ConvertTo-SecureString $keyId_from_aadapp -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($web_uri_from_aadapp, $secpasswd)
Login-AzureRmAccount -ServicePrincipal -Tenant $tenant_id_from_aadapp -Credential $mycreds

# vm status
$powerStatus = (Get-AzureRmVM -ResourceGroupName $rg_name -Name $target_vm_name -Status).Statuses.Item(1).Code

# execute restart or not
# 'PowerState/deallocated'
# 'PowerState/running'

if($powerStatus -like "*running" ) {
    Restart-AzureRmVM -ResourceGroupName $rg_name -Name $target_vm_name
}



<# if vm status is PowerState/deallocated , execute start vm
if($powerStatus -like "*running" ) {
    Restart-AzureRmVM -ResourceGroupName $rg_name -Name $target_vm_name
} else {
    Start-AzureRmVM -ResourceGroupName $rg_name -Name $target_vm_name
}
#>


