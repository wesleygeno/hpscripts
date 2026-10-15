get-localuser | where-object name -ne "Administrator" | foreach-object { remove-localuser -name $_.name }
