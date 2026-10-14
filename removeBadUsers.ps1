try {
    get-localuser | where-object { $_.name -ne "Administrator" } | remove-localuser
} catch {
    "error1"
}
