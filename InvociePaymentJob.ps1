#
# InvociePaymentJob.ps1
#
Invoke-RestMethod http://hrmaxxapi.azurewebsites.net/Scheduled/UpdateInvoicePayments;
Invoke-RestMethod http://hrmaxxapi.azurewebsites.net/Scheduled/ACH/FillACHData;