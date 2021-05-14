##$Mailboxes = (get-mailbox -resultsize unlimited| select PrimarySMTPAddress)
$OutArray = @()
$Mailboxes = Get-ADUser -filter {Enabled -eq $True}| Select-Object UserPrincipalName
## (old) $Results = foreach ($Mailbox in $Mailboxes) {
foreach ($Mailbox in $Mailboxes) {
    $MailboxSize = get-mailboxstatistics -identity $Mailbox.UserPrincipalName| select DisplayName,TotalItemSize
    
    $ArchiveEnabled = get-mailbox -identity $Mailbox.UserPrincipalName| select RetentionPolicy
    
    $OutArray += New-Object PsObject -Property @{
        'Name' = $MailboxSize.DisplayName
        'Mailbox Size' = $MailboxSize.TotalItemSize
        'Retention Policy' = $ArchiveEnabled.RetentionPolicy
    }
   ## write-host ($MailboxSize.Displayname)","($MailboxSize.TotalItemSize)","($ArchiveEnabled.RetentionPolicy)
}
## $Results | export-csv C:\temp\mailboxsizereport04-30.csv
$OutArray| Export-Csv C:\temp\MailboxSizeWRetention2.csv
