Alter table PayrollInvoice Add DeliveryClaimedBy varchar(max) null, DeliveryClaimedOn Datetime null;
Alter table Common.Memento Alter Column [Version] decimal(18,2) not null;