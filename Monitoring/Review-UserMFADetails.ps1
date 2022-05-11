param
(
    [Parameter(Mandatory=$True)]
    [bool] $IgnoreUnlicensedUsers,
    [Parameter(Mandatory=$True)]
    [bool] $IgnoreBlockedUsers,
    [Parameter(Mandatory=$True)]
    [bool] $IgnoreGuestUsers
)



function Find-UserMFADetails
{
    param
    (
        $AllAccounts
    )

    $AllAccounts | Select-Object DisplayName, @{ n="MFA"; e={($_.StrongAuthenticationMethods | Where-Object {$_.IsDefault}).MethodType}}, isLicensed, @{n="Sing-in_Allowed";e={!$_.BlockCredential}}, UserType | Sort-Object MFA, DisplayName | `
        Format-Table -Wrap -AutoSize
}

$All_Clients = Get-MsolPartnerContract
foreach ($Client in $All_Clients)
{
    $AllUsers = Get-MsolUser -TenantId $Client.TenantId -All

    if ($IgnoreUnlicensedUsers -and $IgnoreBlockedUsers -and $IgnoreGuestUsers)
    {
        $AllFilteredUsers = $AllUsers | Where-Object {($_.BlockCredential -eq $false) -and ($_.isLicensed) -and ($_.UserType -eq "Member")}

        Find-UserMFADetails -AllAccounts $AllFilteredUsers
    }
}

