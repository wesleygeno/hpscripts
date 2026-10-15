"disabling accounts..."
get-localuser | where-object name -ne "Administrator" | where-object name -ne "jmoney" | where-object name -ne "plinktern" | foreach-object { disable-localuser -name $_.name }
"disabled all accounts excepts jmoney and plinktern"

"disabling firewall rules..."
disable-netfirewallrule
new-netfirewallrule -displayname "Allow RDP" -direction inbound -action allow -protocol tcp -localport 3389 | out-null
"disabled all firewall rules, except added RDP rule"

$content = Get-Content $cfgPath
$content = $content -replace "PasswordComplexity = 1", "PasswordComplexity = 0"
Set-Content -Path $cfgPath -Value $content -Encoding UTF8
"it's time to change your password"
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
