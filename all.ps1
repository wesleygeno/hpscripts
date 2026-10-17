"disabling accounts..."
get-localuser | where-object name -ne "Administrator" | where-object name -ne "jmoney" | where-object name -ne "plinktern" | foreach-object { disable-localuser -name $_.name }
"disabled all accounts excepts jmoney and plinktern"
get-localgroupmember -name "Administrators" | foreach-object { remove-localgroupmember -name "Administrators" -member $_.name }
add-localgroupmember -name "Administrators" -member "plinktern"
"deprivileged all accounts except plinktern"

secedit /export /cfg c:\secpol.cfg | out-null
(Get-Content c:\secpol.cfg) -Replace "PasswordComplexity = 1","PasswordComplexity = 0" | Out-File c:\secpol.cfg
(Get-Content c:\secpol.cfg) -Replace "AuditLogonEvents = 0","AuditLogonEvents = 3" | Out-File c:\secpol.cfg
(Get-Content c:\secpol.cfg) -Replace "AuditLogonEvents = 1","AuditLogonEvents = 3" | Out-File c:\secpol.cfg
(Get-Content c:\secpol.cfg) -Replace "AuditLogonEvents = 2","AuditLogonEvents = 3" | Out-File c:\secpol.cfg
(Get-Content c:\secpol.cfg) -Replace "AuditSystemEvents = 0","AuditSystemEvents = 3" | Out-File c:\secpol.cfg
(Get-Content c:\secpol.cfg) -Replace "AuditSystemEvents = 1","AuditSystemEvents = 3" | Out-File c:\secpol.cfg
(Get-Content c:\secpol.cfg) -Replace "AuditSystemEvents = 2","AuditSystemEvents = 3" | Out-File c:\secpol.cfg
(Get-Content c:\secpol.cfg) -Replace "AuditSystemEvents = 0","AuditSystemEvents = 3" | Out-File c:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY | out-null
Remove-Item c:\secpol.cfg -Force
"disabled the password complexity requirements"

"it's time to change the plinktern password"
do {
    $NewPassword = Read-Host -Prompt "enter new local password" -AsSecureString
    $ConfirmPassword = Read-Host -Prompt "confirm new local password" -AsSecureString
    
    $BSTR1 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword)
    $Plain1 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR1)
    
    $BSTR2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfirmPassword)
    $Plain2 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR2)
    
    $PasswordsMatch = ($Plain1 -eq $Plain2)
    
    if (-not $PasswordsMatch) {
        "passwords don't match, try again"
    }
} while (-not $PasswordsMatch)
Set-LocalUser -Name "plinktern" -Password $NewPassword
"updated plinktern's password"

"it's time to change the jmoney password"
do {
    $NewPassword = Read-Host -Prompt "enter new local password" -AsSecureString
    $ConfirmPassword = Read-Host -Prompt "confirm new local password" -AsSecureString
    
    $BSTR1 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword)
    $Plain1 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR1)
    
    $BSTR2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfirmPassword)
    $Plain2 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR2)
    
    $PasswordsMatch = ($Plain1 -eq $Plain2)
    
    if (-not $PasswordsMatch) {
        "passwords don't match, try again"
    }
} while (-not $PasswordsMatch)
Set-LocalUser -Name "jmoney" -Password $NewPassword
"updated jmoney's password"

"disabling firewall rules..."
remove-netfirewallrule
new-netfirewallrule -displayname "Allow RDP (TCP)" -direction inbound -action allow -protocol tcp -localport 3389 | out-null
new-netfirewallrule -displayname "Allow RDP (UDP)" -direction inbound -action allow -protocol udp -localport 3389 | out-null
new-netfirewallrule -displayname "Allow Web Server" -direction inbound -action allow -protocol tcp -localport 8080 | out-null
new-netfirewallrule -displayname "Allow MariaDB Requests" -direction inbound -action allow -protocol tcp -localport 3306 | out-null
"disabled all firewall rules, except added RDP rule"
