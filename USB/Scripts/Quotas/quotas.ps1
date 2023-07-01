$UserName = $env:USERNAME
$FolderPath = "\\SV-001-AD\UserData\$UserName"

# Create the user folder
New-Item -ItemType Directory -Path $FolderPath -Force

# Set permissions on the user folder
$Acl = Get-Acl $FolderPath
$UserSid = (New-Object System.Security.Principal.NTAccount($env:USERDOMAIN, $UserName)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Remove default permissions for "Authenticated Users" group
$Acl | ForEach-Object {
    $_.Access | ForEach-Object {
        if ($_.IdentityReference.Value -eq "Authenticated Users") {
            $Acl.RemoveAccessRule($_)
        }
    }
}

# Grant access to the user
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($UserSid, 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$Acl.SetAccessRule($AccessRule)

# Grant access to the domain administrator
$DomainAdminSid = (New-Object System.Security.Principal.NTAccount($env:USERDOMAIN, "Domain Admins")).Translate([System.Security.Principal.SecurityIdentifier]).Value
$AccessRuleAdmin = New-Object System.Security.AccessControl.FileSystemAccessRule($DomainAdminSid, 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$Acl.SetAccessRule($AccessRuleAdmin)

Set-Acl -Path $FolderPath -AclObject $Acl