get-localuser | where-object name -ne "Administrator" | remove-localuser -name $_.Name
