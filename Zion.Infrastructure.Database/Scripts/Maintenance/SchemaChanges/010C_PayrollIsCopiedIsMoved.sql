IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'CopiedFrom')
Alter table Payroll Add CopiedFrom uniqueidentifier, MovedFrom uniqueidentifier;


ALTER TABLE [dbo].[PayCheckCompensation]  Drop  CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck]
ALTER TABLE [dbo].[PayCheckCompensation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE CASCADE
GO


ALTER TABLE [dbo].[PayCheckTax]  Drop  CONSTRAINT [FK_PayCheckTax_PayrollPayCheck]
ALTER TABLE [dbo].[PayCheckTax]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckTax_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE CASCADE
GO


ALTER TABLE [dbo].PayCheckPayCode  Drop  CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck]
ALTER TABLE [dbo].PayCheckPayCode  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].PayCheckDeduction  Drop  CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck]
ALTER TABLE [dbo].PayCheckDeduction  WITH CHECK ADD  CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].PayCheckWorkerCompensation  Drop  CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck]
ALTER TABLE [dbo].PayCheckWorkerCompensation  WITH CHECK ADD  CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].PayCheckPayTypeAccumulation  Drop  CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck]
ALTER TABLE [dbo].PayCheckPayTypeAccumulation  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE CASCADE
GO

