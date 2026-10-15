get-localuser | where-object name -ne "Administrator" | foreach-object { disable-localuser -name $_.name }
disable-netfirewallrule
new-netfirewallrule -displayname "Allow RDP" -direction inbound -action allow -protocol tcp -localport 3389
