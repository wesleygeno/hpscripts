"disabling accounts..."
get-localuser | where-object name -ne "Administrator" | where-object name -ne "jmoney" | where-object name -ne "plinktern" | foreach-object { disable-localuser -name $_.name }
"disabled all accounts excepts jmoney and plinktern"
"disabling firewall rules..."
disable-netfirewallrule
new-netfirewallrule -displayname "Allow RDP" -direction inbound -action allow -protocol tcp -localport 3389 | out-null
"disabled all firewall rules, except added RDP rule"
