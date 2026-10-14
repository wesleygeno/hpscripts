try {
    get-localuser | where-object { $_.name -ne "Administrator" } | remove-localuser $_
} catch {
    "error1"
}
