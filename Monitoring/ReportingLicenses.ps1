$All_Clients = Get-MsolPartnerContract
$OutputFile = "C:\Temp\AllTenants.txt"

foreach ($Client in $All_Clients)
{
    $Client_Name = $Client.Name
    Write-Host "$Client_Name" -ForegroundColor Green -BackgroundColor DarkGray
    "$Client_Name" | Out-File -FilePath $OutputFile -Append

    $AllLicensedUsers = Get-MsolUser -TenantId $Client.TenantId -All | `
        Where-Object {($_.BlockCredential -eq $false) -and ($_.isLicensed) -and ($_.UserType -eq "Member")}
    Write-Host "$Client_Name | Total Number of Accounts: $($AllLicensedUsers.count)" -ForegroundColor Green -BackgroundColor DarkGray
    "$Client_Name | Total Number of Accounts: $($AllLicensedUsers.count)" | Out-File -FilePath $OutputFile -Append
    Get-MsolAccountSku -TenantId $Client.TenantId | Out-File -FilePath $OutputFile -Append
}
