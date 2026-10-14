get-localuser | where-object name -ne "Administrator" | remove-localuser -inputobject $_
