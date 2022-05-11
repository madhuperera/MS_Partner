param
(
    [Parameter(Mandatory=$True)]
    [ValidateSet("Global Administrators","AD Device Administrators","Intune Administrators","Global Readers")]
    $RoleName
)

function Find-RoleMembers
{
    param
    (
        [String] $RoleID,
        [String] $RoleName
    )
    $All_Clients = Get-MsolPartnerContract
    foreach ($Client in $All_Clients)
    {
        $Client_Name = $Client.Name
        Write-Host "$Client_Name | List of $RoleName" -ForegroundColor Green -BackgroundColor DarkGray

        $RoleMembers = Get-MsolRoleMember -RoleObjectId $RoleID -TenantId $($Client.TenantId)
        if ($RoleMembers)
        {
            $RoleMembers | Select-Object DisplayName, EmailAddress, RoleMemberType, isLicensed | `
            Sort-Object DisplayName | Format-Table -Wrap -AutoSize
        }
        else
        {
            Write-Host "No Members Found" -ForegroundColor Blue
        }
    }
}

switch ($RoleName)
{
    "Global Administrators"
    {
        Find-RoleMembers -RoleID "62e90394-69f5-4237-9190-012177145e10" -RoleName "Global Administrators"
    }
    "AD Device Administrators"
    {
        Find-RoleMembers -RoleID "9f06204d-73c1-4d4c-880a-6edb90606fd8" -RoleName "AD Device Administrators"
    }
    "Intune Administrators"
    {
        Find-RoleMembers -RoleID "3a2c62db-5318-420d-8d74-23affee5d9d5" -RoleName "Intune Administrators"
    }
    "Global Readers"
    {
        Find-RoleMembers -RoleID "f2ef992c-3afb-46b9-b7cf-a126ee74c451" -RoleName "Global Readers"
    }
    Default
    {
        Write-Output "Please enter a valid Role Name"
    }
}
