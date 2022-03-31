$All_Clients = Get-MsolPartnerContract
foreach ($Client in $All_Clients)
{
    $Client_Name = $Client.Name
    Write-Host "--------------------------------------------------------------`n"
    Write-Host "$Client_Name | List of Global Administrators`n`n"
    Get-MsolRoleMember -RoleObjectId "62e90394-69f5-4237-9190-012177145e10" -TenantId $($Client.TenantId)
    Write-Host "_________________________________________________________________________________________`n`n`n"
}
