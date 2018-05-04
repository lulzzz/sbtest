#
# InvociePaymentJob.ps1
#
Invoke-RestMethod http://hrmaxxapi.azurewebsites.net/Scheduled/UpdateInvoicePayments;
Invoke-RestMethod http://hrmaxxapi.azurewebsites.net/DeleteOldNotifications;
Invoke-RestMethod http://hrmaxxapi.azurewebsites.net/Scheduled/UpdateDBStats;