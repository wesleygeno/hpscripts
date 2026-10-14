get-localuser | where-object { $_.name -ne "Administrator" } | remove-localuser $_
