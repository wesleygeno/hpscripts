get-localuser | where-object name -ne "Administrator" | foreach-object { disable-localuser -name $_.name }
