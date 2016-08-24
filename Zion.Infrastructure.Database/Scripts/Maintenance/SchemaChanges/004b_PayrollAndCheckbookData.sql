SET IDENTITY_INSERT [dbo].[Tax] ON 

GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (1, N'FIT', N'Federal Income Tax', 1, NULL, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (2, N'MD_Employee', N'Medicare Employee', 1, NULL, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (3, N'MD_Employer', N'Medicare Employer', 1, NULL, 0, NULL, N'Employer')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (4, N'SS_Employee', N'Social Security Employee', 1, NULL, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (5, N'SS_Employer', N'Social Security Employer', 1, NULL, 0, NULL, N'Employer')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (6, N'FUTA', N'Federal Unemployment Tax', 1, NULL, 0, NULL, N'Employer')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (7, N'SIT', N'State Income Tax', 1, 1, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (8, N'SDI', N'State Disability Insurance', 1, 1, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (9, N'ETT', N'Employee Training Tax', 1, 1, 1, CAST(0.10 AS Decimal(18, 2)), N'Employer')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (10, N'SUI', N'State Unemployment Insurance', 1, 1, 1, CAST(3.40 AS Decimal(18, 2)), N'Employer')
GO
SET IDENTITY_INSERT [dbo].[Tax] OFF
GO
SET IDENTITY_INSERT [dbo].[TaxYearRate] ON 

GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (1, 1, 2016, NULL, NULL, NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (2, 2, 2016, CAST(1.45 AS Decimal(18, 2)), NULL, NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (3, 3, 2016, CAST(1.45 AS Decimal(18, 2)), NULL, NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (4, 4, 2016, CAST(6.20 AS Decimal(18, 2)), CAST(118500.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (5, 5, 2016, CAST(6.20 AS Decimal(18, 2)), CAST(118500.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (6, 6, 2016, CAST(2.40 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (7, 7, 2016, NULL, NULL, NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (8, 8, 2016, CAST(0.90 AS Decimal(18, 2)), CAST(106742.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (9, 9, 2016, CAST(0.10 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (10, 10, 2016, CAST(3.40 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), CAST(6.20 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[TaxYearRate] OFF
GO
SET IDENTITY_INSERT [dbo].[EstimatedDeductionsTable] ON 

GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (1, 1, 1, 19.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (2, 1, 2, 38.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (3, 1, 3, 58.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (4, 1, 4, 77.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (5, 1, 5, 96.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (6, 1, 6, 115.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (7, 1, 7, 135.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (8, 1, 8, 154.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (9, 1, 9, 173.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (10, 1, 10, 192.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (11, 2, 1, 38.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (12, 2, 2, 77.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (13, 2, 3, 115.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (14, 2, 4, 154.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (15, 2, 5, 192.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (16, 2, 6, 231.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (17, 2, 7, 269.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (18, 2, 8, 308.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (19, 2, 9, 346.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (20, 2, 10, 385.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (21, 3, 1, 42.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (22, 3, 2, 83.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (23, 3, 3, 125.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (24, 3, 4, 167.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (25, 3, 5, 208.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (26, 3, 6, 250.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (27, 3, 7, 292.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (28, 3, 8, 333.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (29, 3, 9, 375.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (30, 3, 10, 417.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (31, 4, 1, 83.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (32, 4, 2, 167.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (33, 4, 3, 250.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (34, 4, 4, 333.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (35, 4, 5, 417.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (36, 4, 6, 500.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (37, 4, 7, 583.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (38, 4, 8, 667.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (39, 4, 9, 750.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (40, 4, 10, 833.0000, 2008)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (41, 1, 1, 19.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (42, 1, 2, 38.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (43, 1, 3, 58.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (44, 1, 4, 77.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (45, 1, 5, 96.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (46, 1, 6, 115.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (47, 1, 7, 135.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (48, 1, 8, 154.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (49, 1, 9, 173.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (50, 1, 10, 192.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (51, 2, 1, 38.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (52, 2, 2, 77.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (53, 2, 3, 115.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (54, 2, 4, 154.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (55, 2, 5, 192.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (56, 2, 6, 231.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (57, 2, 7, 269.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (58, 2, 8, 308.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (59, 2, 9, 346.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (60, 2, 10, 385.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (61, 3, 1, 42.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (62, 3, 2, 83.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (63, 3, 3, 125.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (64, 3, 4, 167.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (65, 3, 5, 208.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (66, 3, 6, 250.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (67, 3, 7, 292.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (68, 3, 8, 333.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (69, 3, 9, 375.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (70, 3, 10, 417.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (71, 4, 1, 83.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (72, 4, 2, 167.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (73, 4, 3, 250.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (74, 4, 4, 333.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (75, 4, 5, 417.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (76, 4, 6, 500.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (77, 4, 7, 583.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (78, 4, 8, 667.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (79, 4, 9, 750.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (80, 4, 10, 833.0000, 2007)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (81, 1, 1, 19.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (82, 1, 2, 38.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (83, 1, 3, 58.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (84, 1, 4, 77.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (85, 1, 5, 96.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (86, 1, 6, 115.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (87, 1, 7, 135.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (88, 1, 8, 154.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (89, 1, 9, 173.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (90, 1, 10, 192.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (91, 2, 1, 38.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (92, 2, 2, 77.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (93, 2, 3, 115.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (94, 2, 4, 154.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (95, 2, 5, 192.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (96, 2, 6, 231.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (97, 2, 7, 269.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (98, 2, 8, 308.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (99, 2, 9, 346.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (100, 2, 10, 385.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (101, 3, 1, 42.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (102, 3, 2, 83.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (103, 3, 3, 125.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (104, 3, 4, 167.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (105, 3, 5, 208.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (106, 3, 6, 250.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (107, 3, 7, 292.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (108, 3, 8, 333.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (109, 3, 9, 375.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (110, 3, 10, 417.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (111, 4, 1, 83.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (112, 4, 2, 167.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (113, 4, 3, 250.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (114, 4, 4, 333.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (115, 4, 5, 417.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (116, 4, 6, 500.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (117, 4, 7, 583.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (118, 4, 8, 667.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (119, 4, 9, 750.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (120, 4, 10, 833.0000, 2009)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (121, 1, 1, 19.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (122, 1, 2, 38.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (123, 1, 3, 58.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (124, 1, 4, 77.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (125, 1, 5, 96.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (126, 1, 6, 115.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (127, 1, 7, 135.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (128, 1, 8, 154.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (129, 1, 9, 173.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (130, 1, 10, 192.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (131, 2, 1, 38.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (132, 2, 2, 77.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (133, 2, 3, 115.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (134, 2, 4, 154.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (135, 2, 5, 192.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (136, 2, 6, 231.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (137, 2, 7, 269.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (138, 2, 8, 308.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (139, 2, 9, 346.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (140, 2, 10, 385.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (141, 3, 1, 42.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (142, 3, 2, 83.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (143, 3, 3, 125.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (144, 3, 4, 167.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (145, 3, 5, 208.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (146, 3, 6, 250.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (147, 3, 7, 292.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (148, 3, 8, 333.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (149, 3, 9, 375.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (150, 3, 10, 417.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (151, 4, 1, 83.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (152, 4, 2, 167.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (153, 4, 3, 250.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (154, 4, 4, 333.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (155, 4, 5, 417.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (156, 4, 6, 500.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (157, 4, 7, 583.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (158, 4, 8, 667.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (159, 4, 9, 750.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (160, 4, 10, 833.0000, 2010)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (161, 1, 1, 19.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (162, 1, 2, 38.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (163, 1, 3, 58.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (164, 1, 4, 77.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (165, 1, 5, 96.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (166, 1, 6, 115.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (167, 1, 7, 135.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (168, 1, 8, 154.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (169, 1, 9, 173.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (170, 1, 10, 192.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (171, 2, 1, 38.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (172, 2, 2, 77.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (173, 2, 3, 115.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (174, 2, 4, 154.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (175, 2, 5, 192.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (176, 2, 6, 231.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (177, 2, 7, 269.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (178, 2, 8, 308.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (179, 2, 9, 346.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (180, 2, 10, 385.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (181, 3, 1, 42.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (182, 3, 2, 83.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (183, 3, 3, 125.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (184, 3, 4, 167.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (185, 3, 5, 208.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (186, 3, 6, 250.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (187, 3, 7, 292.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (188, 3, 8, 333.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (189, 3, 9, 375.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (190, 3, 10, 417.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (191, 4, 1, 83.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (192, 4, 2, 167.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (193, 4, 3, 250.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (194, 4, 4, 333.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (195, 4, 5, 417.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (196, 4, 6, 500.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (197, 4, 7, 583.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (198, 4, 8, 667.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (199, 4, 9, 750.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (200, 4, 10, 833.0000, 2011)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (201, 1, 1, 19.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (202, 1, 2, 38.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (203, 1, 3, 58.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (204, 1, 4, 77.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (205, 1, 5, 96.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (206, 1, 6, 115.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (207, 1, 7, 135.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (208, 1, 8, 154.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (209, 1, 9, 173.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (210, 1, 10, 192.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (211, 2, 1, 38.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (212, 2, 2, 77.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (213, 2, 3, 115.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (214, 2, 4, 154.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (215, 2, 5, 192.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (216, 2, 6, 231.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (217, 2, 7, 269.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (218, 2, 8, 308.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (219, 2, 9, 346.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (220, 2, 10, 385.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (221, 3, 1, 42.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (222, 3, 2, 83.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (223, 3, 3, 125.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (224, 3, 4, 167.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (225, 3, 5, 208.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (226, 3, 6, 250.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (227, 3, 7, 292.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (228, 3, 8, 333.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (229, 3, 9, 375.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (230, 3, 10, 417.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (231, 4, 1, 83.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (232, 4, 2, 167.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (233, 4, 3, 250.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (234, 4, 4, 333.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (235, 4, 5, 417.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (236, 4, 6, 500.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (237, 4, 7, 583.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (238, 4, 8, 667.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (239, 4, 9, 750.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (240, 4, 10, 833.0000, 2012)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (241, 1, 1, 19.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (242, 1, 2, 38.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (243, 1, 3, 58.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (244, 1, 4, 77.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (245, 1, 5, 96.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (246, 1, 6, 115.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (247, 1, 7, 135.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (248, 1, 8, 154.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (249, 1, 9, 173.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (250, 1, 10, 192.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (251, 2, 1, 38.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (252, 2, 2, 77.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (253, 2, 3, 115.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (254, 2, 4, 154.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (255, 2, 5, 192.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (256, 2, 6, 231.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (257, 2, 7, 269.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (258, 2, 8, 308.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (259, 2, 9, 346.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (260, 2, 10, 385.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (261, 3, 1, 42.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (262, 3, 2, 83.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (263, 3, 3, 125.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (264, 3, 4, 167.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (265, 3, 5, 208.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (266, 3, 6, 250.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (267, 3, 7, 292.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (268, 3, 8, 333.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (269, 3, 9, 375.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (270, 3, 10, 417.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (271, 4, 1, 83.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (272, 4, 2, 167.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (273, 4, 3, 250.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (274, 4, 4, 333.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (275, 4, 5, 417.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (276, 4, 6, 500.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (277, 4, 7, 583.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (278, 4, 8, 667.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (279, 4, 9, 750.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (280, 4, 10, 833.0000, 2013)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (281, 1, 1, 19.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (282, 1, 2, 38.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (283, 1, 3, 58.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (284, 1, 4, 77.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (285, 1, 5, 96.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (286, 1, 6, 115.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (287, 1, 7, 135.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (288, 1, 8, 154.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (289, 1, 9, 173.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (290, 1, 10, 192.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (291, 2, 1, 38.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (292, 2, 2, 77.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (293, 2, 3, 115.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (294, 2, 4, 154.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (295, 2, 5, 192.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (296, 2, 6, 231.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (297, 2, 7, 269.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (298, 2, 8, 308.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (299, 2, 9, 346.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (300, 2, 10, 385.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (301, 3, 1, 42.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (302, 3, 2, 83.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (303, 3, 3, 125.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (304, 3, 4, 167.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (305, 3, 5, 208.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (306, 3, 6, 250.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (307, 3, 7, 292.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (308, 3, 8, 333.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (309, 3, 9, 375.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (310, 3, 10, 417.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (311, 4, 1, 83.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (312, 4, 2, 167.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (313, 4, 3, 250.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (314, 4, 4, 333.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (315, 4, 5, 417.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (316, 4, 6, 500.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (317, 4, 7, 583.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (318, 4, 8, 667.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (319, 4, 9, 750.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (320, 4, 10, 833.0000, 2014)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (321, 1, 1, 19.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (322, 1, 2, 38.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (323, 1, 3, 58.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (324, 1, 4, 77.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (325, 1, 5, 96.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (326, 1, 6, 115.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (327, 1, 7, 135.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (328, 1, 8, 154.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (329, 1, 9, 173.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (330, 1, 10, 192.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (331, 2, 1, 38.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (332, 2, 2, 77.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (333, 2, 3, 115.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (334, 2, 4, 154.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (335, 2, 5, 192.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (336, 2, 6, 231.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (337, 2, 7, 269.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (338, 2, 8, 308.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (339, 2, 9, 346.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (340, 2, 10, 385.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (341, 3, 1, 42.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (342, 3, 2, 83.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (343, 3, 3, 125.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (344, 3, 4, 167.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (345, 3, 5, 208.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (346, 3, 6, 250.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (347, 3, 7, 292.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (348, 3, 8, 333.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (349, 3, 9, 375.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (350, 3, 10, 417.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (351, 4, 1, 83.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (352, 4, 2, 167.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (353, 4, 3, 250.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (354, 4, 4, 333.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (355, 4, 5, 417.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (356, 4, 6, 500.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (357, 4, 7, 583.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (358, 4, 8, 667.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (359, 4, 9, 750.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (360, 4, 10, 833.0000, 2015)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (361, 1, 1, 19.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (362, 1, 2, 38.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (363, 1, 3, 58.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (364, 1, 4, 77.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (365, 1, 5, 96.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (366, 1, 6, 115.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (367, 1, 7, 135.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (368, 1, 8, 154.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (369, 1, 9, 173.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (370, 1, 10, 192.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (371, 2, 1, 38.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (372, 2, 2, 77.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (373, 2, 3, 115.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (374, 2, 4, 154.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (375, 2, 5, 192.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (376, 2, 6, 231.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (377, 2, 7, 269.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (378, 2, 8, 308.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (379, 2, 9, 346.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (380, 2, 10, 385.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (381, 3, 1, 42.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (382, 3, 2, 83.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (383, 3, 3, 125.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (384, 3, 4, 167.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (385, 3, 5, 208.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (386, 3, 6, 250.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (387, 3, 7, 292.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (388, 3, 8, 333.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (389, 3, 9, 375.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (390, 3, 10, 417.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (391, 4, 1, 83.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (392, 4, 2, 167.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (393, 4, 3, 250.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (394, 4, 4, 333.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (395, 4, 5, 417.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (396, 4, 6, 500.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (397, 4, 7, 583.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (398, 4, 8, 667.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (399, 4, 9, 750.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (400, 4, 10, 833.0000, 2016)
GO
SET IDENTITY_INSERT [dbo].[EstimatedDeductionsTable] OFF
GO
SET IDENTITY_INSERT [dbo].[ExemptionAllowanceTable] ON 

GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (1, 1, 0, 0.0000, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (2, 1, 1, 1.8100, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (3, 1, 2, 3.6200, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (4, 1, 3, 5.4200, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (5, 1, 4, 7.2300, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (6, 1, 5, 9.0400, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (7, 1, 6, 10.8500, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (8, 1, 7, 12.6500, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (9, 1, 8, 14.4600, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (10, 1, 9, 16.2700, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (11, 1, 10, 18.0800, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (12, 2, 0, 0.0000, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (13, 2, 1, 3.6200, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (14, 2, 2, 7.2300, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (15, 2, 3, 10.8500, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (16, 2, 4, 14.4600, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (17, 2, 5, 18.0800, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (18, 2, 6, 21.6900, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (19, 2, 7, 25.3100, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (20, 2, 8, 28.9200, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (21, 2, 9, 32.5400, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (22, 2, 10, 36.1500, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (23, 3, 0, 0.0000, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (24, 3, 1, 3.9200, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (25, 3, 2, 7.8300, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (26, 3, 3, 11.7500, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (27, 3, 4, 15.6700, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (28, 3, 5, 19.5800, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (29, 3, 6, 23.5000, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (30, 3, 7, 27.4200, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (31, 3, 8, 31.3300, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (32, 3, 9, 35.2500, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (33, 3, 10, 39.1700, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (34, 4, 0, 0.0000, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (35, 4, 1, 7.8300, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (36, 4, 2, 15.6700, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (37, 4, 3, 23.5000, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (38, 4, 4, 31.3300, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (39, 4, 5, 39.1700, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (40, 4, 6, 47.0000, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (41, 4, 7, 54.8300, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (42, 4, 8, 62.6700, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (43, 4, 9, 70.5000, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (44, 4, 10, 78.3300, 2008)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (45, 1, 0, 0.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (46, 1, 1, 1.7500, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (47, 1, 2, 3.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (48, 1, 3, 5.2500, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (49, 1, 4, 7.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (50, 1, 5, 8.7500, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (51, 1, 6, 10.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (52, 1, 7, 12.2500, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (53, 1, 8, 14.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (54, 1, 9, 15.7500, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (55, 1, 10, 17.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (56, 2, 0, 0.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (57, 2, 1, 3.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (58, 2, 2, 7.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (59, 2, 3, 10.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (60, 2, 4, 14.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (61, 2, 5, 17.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (62, 2, 6, 21.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (63, 2, 7, 24.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (64, 2, 8, 28.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (65, 2, 9, 31.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (66, 2, 10, 35.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (67, 3, 0, 0.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (68, 3, 1, 3.7900, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (69, 3, 2, 7.5800, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (70, 3, 3, 11.3800, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (71, 3, 4, 15.1700, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (72, 3, 5, 18.9600, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (73, 3, 6, 22.7500, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (74, 3, 7, 26.5400, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (75, 3, 8, 30.3300, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (76, 3, 9, 34.1300, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (77, 3, 10, 37.9200, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (78, 4, 0, 0.0000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (79, 4, 1, 7.5800, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (80, 4, 2, 15.1700, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (81, 4, 3, 22.7500, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (82, 4, 4, 30.3300, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (83, 4, 5, 37.9200, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (84, 4, 6, 45.5000, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (85, 4, 7, 53.0800, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (86, 4, 8, 60.6700, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (87, 4, 9, 68.2500, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (88, 4, 10, 75.8300, 2007)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (89, 1, 0, 0.0000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (90, 1, 1, 1.9000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (91, 1, 2, 3.8100, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (92, 1, 3, 5.7100, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (93, 1, 4, 7.6200, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (94, 1, 5, 9.5200, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (95, 1, 6, 11.4200, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (96, 1, 7, 13.3300, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (97, 1, 8, 15.2300, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (98, 1, 9, 17.1300, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (99, 1, 10, 19.0400, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (100, 2, 0, 0.0000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (101, 2, 1, 3.8100, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (102, 2, 2, 7.6200, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (103, 2, 3, 11.4200, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (104, 2, 4, 15.2300, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (105, 2, 5, 19.0400, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (106, 2, 6, 22.8500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (107, 2, 7, 26.6500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (108, 2, 8, 30.4600, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (109, 2, 9, 34.2700, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (110, 2, 10, 38.0800, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (111, 3, 0, 0.0000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (112, 3, 1, 4.1300, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (113, 3, 2, 8.2500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (114, 3, 3, 12.3800, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (115, 3, 4, 16.5000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (116, 3, 5, 20.6300, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (117, 3, 6, 24.7500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (118, 3, 7, 28.8800, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (119, 3, 8, 33.0000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (120, 3, 9, 37.1300, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (121, 3, 10, 41.2500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (122, 4, 0, 0.0000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (123, 4, 1, 8.2500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (124, 4, 2, 16.5000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (125, 4, 3, 24.7500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (126, 4, 4, 33.0000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (127, 4, 5, 41.2500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (128, 4, 6, 49.5000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (129, 4, 7, 57.7500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (130, 4, 8, 66.0000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (131, 4, 9, 74.2500, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (132, 4, 10, 82.5000, 2009)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (133, 1, 0, 0.0000, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (134, 1, 1, 2.0700, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (135, 1, 2, 4.1500, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (136, 1, 3, 6.2200, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (137, 1, 4, 8.2900, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (138, 1, 5, 10.3700, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (139, 1, 6, 12.4400, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (140, 1, 7, 14.5100, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (141, 1, 8, 16.5800, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (142, 1, 9, 18.6600, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (143, 1, 10, 20.7300, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (144, 2, 0, 0.0000, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (145, 2, 1, 4.1500, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (146, 2, 2, 8.2900, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (147, 2, 3, 12.4400, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (148, 2, 4, 16.5800, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (149, 2, 5, 20.7300, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (150, 2, 6, 24.8800, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (151, 2, 7, 29.0200, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (152, 2, 8, 33.1700, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (153, 2, 9, 37.3200, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (154, 2, 10, 41.4600, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (155, 3, 0, 0.0000, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (156, 3, 1, 4.4900, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (157, 3, 2, 8.9800, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (158, 3, 3, 13.4800, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (159, 3, 4, 17.9700, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (160, 3, 5, 22.4600, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (161, 3, 6, 26.9500, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (162, 3, 7, 31.4400, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (163, 3, 8, 35.9300, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (164, 3, 9, 40.4300, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (165, 3, 10, 44.9200, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (166, 4, 0, 0.0000, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (167, 4, 1, 8.9800, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (168, 4, 2, 17.9700, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (169, 4, 3, 26.9500, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (170, 4, 4, 35.9300, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (171, 4, 5, 44.9200, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (172, 4, 6, 53.9000, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (173, 4, 7, 62.8800, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (174, 4, 8, 71.8700, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (175, 4, 9, 80.8500, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (176, 4, 10, 89.8300, 2010)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (177, 1, 0, 0.0000, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (178, 1, 1, 2.0900, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (179, 1, 2, 4.1900, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (180, 1, 3, 6.2800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (181, 1, 4, 8.3800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (182, 1, 5, 10.4700, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (183, 1, 6, 12.5700, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (184, 1, 7, 14.6600, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (185, 1, 8, 16.7500, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (186, 1, 9, 18.8500, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (187, 1, 10, 20.9400, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (188, 2, 0, 0.0000, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (189, 2, 1, 4.1900, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (190, 2, 2, 8.3800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (191, 2, 3, 12.5700, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (192, 2, 4, 16.7500, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (193, 2, 5, 20.9400, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (194, 2, 6, 25.1300, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (195, 2, 7, 29.3200, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (196, 2, 8, 33.5100, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (197, 2, 9, 37.7000, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (198, 2, 10, 41.8800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (199, 3, 0, 0.0000, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (200, 3, 1, 4.5400, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (201, 3, 2, 9.0800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (202, 3, 3, 13.6100, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (203, 3, 4, 18.1500, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (204, 3, 5, 22.6900, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (205, 3, 6, 27.2300, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (206, 3, 7, 31.7600, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (207, 3, 8, 36.3000, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (208, 3, 9, 40.8400, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (209, 3, 10, 45.3800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (210, 4, 0, 0.0000, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (211, 4, 1, 9.0800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (212, 4, 2, 18.1500, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (213, 4, 3, 27.2300, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (214, 4, 4, 36.3000, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (215, 4, 5, 45.3800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (216, 4, 6, 54.4500, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (217, 4, 7, 63.5300, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (218, 4, 8, 72.6000, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (219, 4, 9, 81.6800, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (220, 4, 10, 90.7500, 2011)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (221, 1, 0, 0.0000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (222, 1, 1, 2.1600, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (223, 1, 2, 4.3200, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (224, 1, 3, 6.4700, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (225, 1, 4, 8.6300, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (226, 1, 5, 10.7900, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (227, 1, 6, 12.9500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (228, 1, 7, 15.1000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (229, 1, 8, 17.2600, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (230, 1, 9, 19.4200, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (231, 1, 10, 21.5800, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (232, 2, 0, 0.0000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (233, 2, 1, 4.3200, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (234, 2, 2, 8.6300, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (235, 2, 3, 12.9500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (236, 2, 4, 17.2600, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (237, 2, 5, 21.5800, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (238, 2, 6, 25.8900, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (239, 2, 7, 30.2100, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (240, 2, 8, 34.5200, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (241, 2, 9, 38.8400, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (242, 2, 10, 43.1500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (243, 3, 0, 0.0000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (244, 3, 1, 4.6800, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (245, 3, 2, 9.3500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (246, 3, 3, 14.0300, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (247, 3, 4, 18.7000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (248, 3, 5, 23.3800, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (249, 3, 6, 28.0500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (250, 3, 7, 32.7300, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (251, 3, 8, 37.4000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (252, 3, 9, 42.0800, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (253, 3, 10, 46.7500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (254, 4, 0, 0.0000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (255, 4, 1, 9.3500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (256, 4, 2, 18.7000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (257, 4, 3, 28.0500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (258, 4, 4, 37.4000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (259, 4, 5, 46.7500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (260, 4, 6, 56.1000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (261, 4, 7, 65.4500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (262, 4, 8, 74.8000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (263, 4, 9, 84.1500, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (264, 4, 10, 93.5000, 2012)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (265, 1, 0, 0.0000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (266, 1, 1, 2.2000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (267, 1, 2, 4.4000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (268, 1, 3, 6.6000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (269, 1, 4, 8.8000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (270, 1, 5, 11.0000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (271, 1, 6, 13.2000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (272, 1, 7, 15.4000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (273, 1, 8, 17.6000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (274, 1, 9, 19.8000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (275, 1, 10, 22.0000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (276, 2, 0, 0.0000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (277, 2, 1, 4.4000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (278, 2, 2, 8.8000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (279, 2, 3, 13.2000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (280, 2, 4, 17.6000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (281, 2, 5, 22.0000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (282, 2, 6, 26.4000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (283, 2, 7, 30.8000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (284, 2, 8, 35.2000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (285, 2, 9, 39.6000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (286, 2, 10, 44.0000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (287, 3, 0, 0.0000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (288, 3, 1, 4.7700, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (289, 3, 2, 9.5300, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (290, 3, 3, 14.3000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (291, 3, 4, 19.0700, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (292, 3, 5, 23.8300, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (293, 3, 6, 28.6000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (294, 3, 7, 33.3700, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (295, 3, 8, 38.1300, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (296, 3, 9, 42.9000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (297, 3, 10, 47.6700, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (298, 4, 0, 0.0000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (299, 4, 1, 9.5300, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (300, 4, 2, 19.0700, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (301, 4, 3, 28.6000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (302, 4, 4, 38.1300, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (303, 4, 5, 47.6700, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (304, 4, 6, 57.2000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (305, 4, 7, 66.7300, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (306, 4, 8, 76.2700, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (307, 4, 9, 85.8000, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (308, 4, 10, 95.3300, 2013)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (309, 1, 0, 0.0000, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (310, 1, 1, 2.2400, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (311, 1, 2, 4.4800, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (312, 1, 3, 6.7300, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (313, 1, 4, 8.9700, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (314, 1, 5, 11.2100, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (315, 1, 6, 13.4500, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (316, 1, 7, 15.7000, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (317, 1, 8, 17.9400, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (318, 1, 9, 20.1800, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (319, 1, 10, 22.4200, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (320, 2, 0, 0.0000, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (321, 2, 1, 4.4800, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (322, 2, 2, 8.9700, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (323, 2, 3, 13.4500, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (324, 2, 4, 17.9400, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (325, 2, 5, 22.4200, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (326, 2, 6, 26.9100, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (327, 2, 7, 31.3900, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (328, 2, 8, 35.8800, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (329, 2, 9, 40.3600, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (330, 2, 10, 44.8500, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (331, 3, 0, 0.0000, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (332, 3, 1, 4.8600, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (333, 3, 2, 9.7200, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (334, 3, 3, 14.5800, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (335, 3, 4, 19.4300, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (336, 3, 5, 24.2900, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (337, 3, 6, 29.1500, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (338, 3, 7, 34.0100, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (339, 3, 8, 38.8700, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (340, 3, 9, 43.7300, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (341, 3, 10, 48.5800, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (342, 4, 0, 0.0000, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (343, 4, 1, 9.7200, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (344, 4, 2, 19.4300, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (345, 4, 3, 29.1500, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (346, 4, 4, 38.8700, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (347, 4, 5, 48.5800, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (348, 4, 6, 58.3000, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (349, 4, 7, 68.0200, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (350, 4, 8, 77.7300, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (351, 4, 9, 87.4500, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (352, 4, 10, 97.1700, 2014)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (353, 1, 0, 0.0000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (354, 1, 1, 2.2800, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (355, 1, 2, 4.5700, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (356, 1, 3, 6.8500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (357, 1, 4, 9.1400, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (358, 1, 5, 11.4200, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (359, 1, 6, 13.7100, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (360, 1, 7, 15.9900, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (361, 1, 8, 18.2800, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (362, 1, 9, 20.5600, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (363, 1, 10, 22.8500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (364, 2, 0, 0.0000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (365, 2, 1, 4.5700, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (366, 2, 2, 9.1400, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (367, 2, 3, 13.7100, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (368, 2, 4, 18.2800, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (369, 2, 5, 22.8500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (370, 2, 6, 27.4200, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (371, 2, 7, 31.9800, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (372, 2, 8, 36.5500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (373, 2, 9, 41.1200, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (374, 2, 10, 45.6900, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (375, 3, 0, 0.0000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (376, 3, 1, 4.9500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (377, 3, 2, 9.9000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (378, 3, 3, 14.8500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (379, 3, 4, 19.8000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (380, 3, 5, 24.7500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (381, 3, 6, 29.7000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (382, 3, 7, 34.6500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (383, 3, 8, 39.6000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (384, 3, 9, 44.5500, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (385, 3, 10, 49.5000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (386, 4, 0, 0.0000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (387, 4, 1, 9.9000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (388, 4, 2, 19.8000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (389, 4, 3, 29.7000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (390, 4, 4, 39.6000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (391, 4, 5, 49.5000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (392, 4, 6, 59.4000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (393, 4, 7, 69.3000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (394, 4, 8, 79.2000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (395, 4, 9, 89.1000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (396, 4, 10, 99.0000, 2015)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (397, 1, 0, 0.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (398, 1, 1, 2.3100, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (399, 1, 2, 4.6100, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (400, 1, 3, 6.9200, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (401, 1, 4, 9.2200, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (402, 1, 5, 11.5300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (403, 1, 6, 13.8300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (404, 1, 7, 16.1400, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (405, 1, 8, 18.4500, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (406, 1, 9, 20.7500, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (407, 1, 10, 23.0600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (408, 2, 0, 0.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (409, 2, 1, 4.6100, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (410, 2, 2, 9.2200, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (411, 2, 3, 13.8300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (412, 2, 4, 18.4500, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (413, 2, 5, 23.0600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (414, 2, 6, 27.6700, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (415, 2, 7, 32.2800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (416, 2, 8, 36.8900, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (417, 2, 9, 41.5000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (418, 2, 10, 46.1200, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (419, 3, 0, 0.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (420, 3, 1, 5.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (421, 3, 2, 9.9900, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (422, 3, 3, 14.9900, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (423, 3, 4, 19.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (424, 3, 5, 24.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (425, 3, 6, 29.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (426, 3, 7, 34.9700, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (427, 3, 8, 39.9700, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (428, 3, 9, 44.9600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (429, 3, 10, 49.9600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (430, 4, 0, 0.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (431, 4, 1, 9.9900, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (432, 4, 2, 19.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (433, 4, 3, 29.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (434, 4, 4, 39.9700, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (435, 4, 5, 49.9600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (436, 4, 6, 59.9500, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (437, 4, 7, 69.9400, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (438, 4, 8, 79.9300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (439, 4, 9, 89.9300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (440, 4, 10, 99.9200, 2016)
GO
SET IDENTITY_INSERT [dbo].[ExemptionAllowanceTable] OFF
GO
SET IDENTITY_INSERT [dbo].[FITTaxTable] ON 

GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (1, 1, N'HeadofHousehold', 0, 50.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (2, 1, N'HeadofHousehold', 51, 197.99, 0, 10, 51, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (3, 1, N'HeadofHousehold', 198, 652.99, 14.7, 15, 198, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (4, 1, N'HeadofHousehold', 653, 1532.99, 82.95, 25, 653, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (5, 1, N'HeadofHousehold', 1533, 3201.99, 302.95, 28, 1533, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (6, 1, N'HeadofHousehold', 3202, 6915.99, 770.27, 33, 3202, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (7, 1, N'HeadofHousehold', 6916, NULL, 1995.89, 35, 6916, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (8, 1, N'Married', 0, 153.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (9, 1, N'Married', 154, 452.99, 0, 10, 154, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (10, 1, N'Married', 453, 1387.99, 29.9, 15, 453, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (11, 1, N'Married', 1388, 2650.99, 170.15, 25, 1388, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (12, 1, N'Married', 2651, 3993.99, 485.9, 28, 2651, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (13, 1, N'Married', 3994, 7020.99, 861.94, 33, 3994, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (14, 1, N'Married', 7021, NULL, 1860.85, 35, 7021, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (15, 1, N'Single', 0, 50.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (16, 1, N'Single', 51, 197.99, 0, 10, 51, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (17, 1, N'Single', 198, 652.99, 14.7, 15, 198, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (18, 1, N'Single', 653, 1532.99, 82.95, 25, 653, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (19, 1, N'Single', 1533, 3201.99, 302.95, 28, 1533, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (20, 1, N'Single', 3202, 6915.99, 770.27, 33, 3202, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (21, 1, N'Single', 6916, NULL, 1995.89, 35, 6916, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (22, 2, N'HeadofHousehold', 0, 101.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (23, 2, N'HeadofHousehold', 102, 395.99, 0, 10, 102, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (24, 2, N'HeadofHousehold', 396, 1305.99, 29.4, 15, 396, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (25, 2, N'HeadofHousehold', 1306, 3065.99, 165.9, 25, 1306, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (26, 2, N'HeadofHousehold', 3066, 6403.99, 605.9, 28, 3066, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (27, 2, N'HeadofHousehold', 6404, 13832.99, 1540.54, 33, 6404, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (28, 2, N'HeadofHousehold', 13833, NULL, 3992.11, 35, 13833, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (29, 2, N'Married', 0, 307.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (30, 2, N'Married', 308, 905.99, 0, 10, 308, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (31, 2, N'Married', 906, 2774.99, 59.8, 15, 906, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (32, 2, N'Married', 2775, 5301.99, 340.15000000000003, 25, 2775, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (33, 2, N'Married', 5302, 7987.99, 971.9, 28, 5302, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (34, 2, N'Married', 7988, 14041.99, 1723.98, 33, 7988, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (35, 2, N'Married', 14042, NULL, 3721.8, 35, 14042, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (36, 2, N'Single', 0, 101.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (37, 2, N'Single', 102, 395.99, 0, 10, 102, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (38, 2, N'Single', 396, 1305.99, 29.4, 15, 396, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (39, 2, N'Single', 1306, 3065.99, 165.9, 25, 1306, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (40, 2, N'Single', 3066, 6403.99, 605.9, 28, 3066, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (41, 2, N'Single', 6404, 13832.99, 1540.54, 33, 6404, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (42, 2, N'Single', 13833, NULL, 3992.11, 35, 13833, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (43, 3, N'HeadofHousehold', 0, 109.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (44, 3, N'HeadofHousehold', 110, 428.99, 0, 10, 110, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (45, 3, N'HeadofHousehold', 429, 1414.99, 31.9, 15, 429, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (46, 3, N'HeadofHousehold', 1415, 3321.99, 179.8, 25, 1415, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (47, 3, N'HeadofHousehold', 3322, 6937.99, 656.55000000000007, 28, 3322, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (48, 3, N'HeadofHousehold', 6938, 14984.99, 1669.03, 33, 6938, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (49, 3, N'HeadofHousehold', 14985, NULL, 4324.54, 35, 14985, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (50, 3, N'Married', 0, 332.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (51, 3, N'Married', 333, 980.99, 0, 10, 333, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (52, 3, N'Married', 981, 3005.99, 64.8, 15, 981, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (53, 3, N'Married', 3006, 5743.99, 368.55, 25, 3006, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (54, 3, N'Married', 5744, 8653.99, 1053.05, 28, 5744, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (55, 3, N'Married', 8654, 15212.99, 1867.85, 33, 8654, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (56, 3, N'Married', 15213, NULL, 4032.32, 35, 15213, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (57, 3, N'Single', 0, 109.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (58, 3, N'Single', 110, 428.99, 0, 10, 110, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (59, 3, N'Single', 429, 1414.99, 31.9, 15, 429, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (60, 3, N'Single', 1415, 3321.99, 179.8, 25, 1415, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (61, 3, N'Single', 3322, 6937.99, 656.55000000000007, 28, 3322, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (62, 3, N'Single', 6938, 14984.99, 1669.03, 33, 6938, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (63, 3, N'Single', 14985, NULL, 4324.54, 35, 14985, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (64, 4, N'HeadofHousehold', 0, 220.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (65, 4, N'HeadofHousehold', 221, 857.99, 0, 10, 221, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (66, 4, N'HeadofHousehold', 858, 2829.99, 63.7, 15, 858, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (67, 4, N'HeadofHousehold', 2830, 6643.99, 359.5, 25, 2830, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (68, 4, N'HeadofHousehold', 6644, 13874.99, 1313, 28, 6644, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (69, 4, N'HeadofHousehold', 13875, 29970.99, 3337.6800000000003, 33, 13875, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (70, 4, N'HeadofHousehold', 29971, NULL, 8649.36, 35, 29971, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (71, 4, N'Married', 0, 666.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (72, 4, N'Married', 667, 1962.99, 0, 10, 667, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (73, 4, N'Married', 1963, 6012.99, 129.6, 15, 1963, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (74, 4, N'Married', 6013, 11487.99, 737.1, 25, 6013, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (75, 4, N'Married', 11488, 17307.99, 2105.85, 28, 11488, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (76, 4, N'Married', 17308, 30424.99, 3735.45, 33, 17308, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (77, 4, N'Married', 30425, NULL, 8064.06, 35, 30425, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (78, 4, N'Single', 0, 220.99, 0, 0, 0, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (79, 4, N'Single', 221, 857.99, 0, 10, 221, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (80, 4, N'Single', 858, 2829.99, 63.7, 15, 858, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (81, 4, N'Single', 2830, 6643.99, 359.5, 25, 2830, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (82, 4, N'Single', 6644, 13874.99, 1313, 28, 6644, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (83, 4, N'Single', 13875, 29970.99, 3337.6800000000003, 33, 13875, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (84, 4, N'Single', 29971, NULL, 8649.36, 35, 29971, 2008)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (85, 1, N'HeadofHousehold', 0, 50.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (86, 1, N'HeadofHousehold', 51, 194.99, 0, 10, 51, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (87, 1, N'HeadofHousehold', 195, 644.99, 14.4, 15, 195, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (88, 1, N'HeadofHousehold', 645, 1481.99, 81.9, 25, 645, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (89, 1, N'HeadofHousehold', 1482, 3130.99, 291.15, 28, 1482, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (90, 1, N'HeadofHousehold', 3131, 6762.99, 752.87, 33, 3131, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (91, 1, N'HeadofHousehold', 6763, NULL, 1951.43, 35, 6763, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (92, 1, N'Married', 0, 153.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (93, 1, N'Married', 154, 448.99, 0, 10, 154, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (94, 1, N'Married', 449, 1359.99, 29.5, 15, 449, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (95, 1, N'Married', 1360, 2572.99, 166.15, 25, 1360, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (96, 1, N'Married', 2573, 3906.99, 469.4, 28, 2573, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (97, 1, N'Married', 3907, 6864.99, 842.92, 33, 3907, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (98, 1, N'Married', 6865, NULL, 1819.06, 35, 6865, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (99, 1, N'Single', 0, 50.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (100, 1, N'Single', 51, 194.99, 0, 10, 51, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (101, 1, N'Single', 195, 644.99, 14.4, 15, 195, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (102, 1, N'Single', 645, 1481.99, 81.9, 25, 645, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (103, 1, N'Single', 1482, 3130.99, 291.15, 28, 1482, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (104, 1, N'Single', 3131, 6762.99, 752.87, 33, 3131, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (105, 1, N'Single', 6763, NULL, 1951.43, 35, 6763, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (106, 2, N'HeadofHousehold', 0, 101.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (107, 2, N'HeadofHousehold', 102, 388.99, 0, 10, 102, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (108, 2, N'HeadofHousehold', 389, 1288.99, 28.7, 15, 389, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (109, 2, N'HeadofHousehold', 1289, 2963.99, 163.7, 25, 1289, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (110, 2, N'HeadofHousehold', 2964, 6261.99, 582.45, 28, 2964, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (111, 2, N'HeadofHousehold', 6262, 13524.99, 1505.89, 33, 6262, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (112, 2, N'HeadofHousehold', 13525, NULL, 3902.68, 35, 13525, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (113, 2, N'Married', 0, 307.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (114, 2, N'Married', 308, 897.99, 0, 10, 308, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (115, 2, N'Married', 898, 2718.99, 59, 15, 898, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (116, 2, N'Married', 2719, 5145.99, 332.15, 25, 2719, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (117, 2, N'Married', 5146, 7812.99, 938.9, 28, 5146, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (118, 2, N'Married', 7813, 13730.99, 1685.66, 33, 7813, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (119, 2, N'Married', 13731, NULL, 3638.6, 35, 13731, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (120, 2, N'Single', 0, 101.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (121, 2, N'Single', 102, 388.99, 0, 10, 102, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (122, 2, N'Single', 389, 1288.99, 28.7, 15, 389, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (123, 2, N'Single', 1289, 2963.99, 163.7, 25, 1289, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (124, 2, N'Single', 2964, 6261.99, 582.45, 28, 2964, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (125, 2, N'Single', 6262, 13524.99, 1505.89, 33, 6262, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (126, 2, N'Single', 13525, NULL, 3902.68, 35, 13525, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (127, 3, N'HeadofHousehold', 0, 109.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (128, 3, N'HeadofHousehold', 110, 421.99, 0, 10, 110, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (129, 3, N'HeadofHousehold', 422, 1396.99, 31.2, 15, 422, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (130, 3, N'HeadofHousehold', 1397, 3210.99, 177.45, 25, 1397, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (131, 3, N'HeadofHousehold', 3211, 6782.99, 630.95, 28, 3211, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (132, 3, N'HeadofHousehold', 6783, 14651.99, 1631.11, 33, 6783, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (133, 3, N'HeadofHousehold', 14652, NULL, 4227.88, 35, 14652, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (134, 3, N'Married', 0, 332.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (135, 3, N'Married', 333, 972.99, 0, 10, 333, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (136, 3, N'Married', 973, 2945.99, 64, 15, 973, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (137, 3, N'Married', 2946, 5574.99, 359.95, 25, 2946, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (138, 3, N'Married', 5575, 8464.99, 1017.2, 28, 5575, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (139, 3, N'Married', 8465, 14874.99, 1826.4, 33, 8465, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (140, 3, N'Married', 14875, NULL, 3941.7, 35, 14875, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (141, 3, N'Single', 0, 109.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (142, 3, N'Single', 110, 421.99, 0, 10, 110, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (143, 3, N'Single', 422, 1396.99, 31.2, 15, 422, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (144, 3, N'Single', 1397, 3210.99, 177.45, 25, 1397, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (145, 3, N'Single', 3211, 6782.99, 630.95, 28, 3211, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (146, 3, N'Single', 6783, 14651.99, 1631.11, 33, 6783, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (147, 3, N'Single', 14652, NULL, 4227.88, 35, 14652, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (148, 4, N'HeadofHousehold', 0, 220.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (149, 4, N'HeadofHousehold', 221, 842.99, 0, 10, 221, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (150, 4, N'HeadofHousehold', 843, 2792.99, 62.2, 15, 843, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (151, 4, N'HeadofHousehold', 2793, 6422.99, 354.7, 25, 2793, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (152, 4, N'HeadofHousehold', 6423, 13566.99, 1262.2, 28, 6423, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (153, 4, N'HeadofHousehold', 13567, 29303.99, 3262.52, 33, 13567, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (154, 4, N'HeadofHousehold', 29304, NULL, 8455.73, 35, 29304, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (155, 4, N'Married', 0, 666.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (156, 4, N'Married', 667, 1945.99, 0, 10, 667, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (157, 4, N'Married', 1946, 5891.99, 127.9, 15, 1946, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (158, 4, N'Married', 5892, 11149.99, 719.8, 25, 5892, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (159, 4, N'Married', 11150, 16928.99, 2034.3, 28, 11150, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (160, 4, N'Married', 16929, 29749.99, 3652.42, 33, 16929, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (161, 4, N'Married', 29750, NULL, 7883.35, 35, 29750, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (162, 4, N'Single', 0, 220.99, 0, 0, 0, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (163, 4, N'Single', 221, 842.99, 0, 10, 221, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (164, 4, N'Single', 843, 2792.99, 62.2, 15, 843, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (165, 4, N'Single', 2793, 6422.99, 354.7, 25, 2793, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (166, 4, N'Single', 6423, 13566.99, 1262.2, 28, 6423, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (167, 4, N'Single', 13567, 29303.99, 3262.52, 33, 13567, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (168, 4, N'Single', 29304, NULL, 8455.73, 35, 29304, 2007)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (169, 1, N'HeadofHousehold', 0, 137.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (170, 1, N'HeadofHousehold', 138, 199.99, 0, 10, 138, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (171, 1, N'HeadofHousehold', 200, 695.99, 6.2, 15, 200, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (172, 1, N'HeadofHousehold', 696, 1278.99, 80.6, 25, 696, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (173, 1, N'HeadofHousehold', 1279, 3337.99, 226.35, 28, 1279, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (174, 1, N'HeadofHousehold', 3338, 7211.99, 802.87, 33, 3338, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (175, 1, N'HeadofHousehold', 7212, NULL, 2081.29, 35, 7212, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (176, 1, N'Married', 0, 302.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (177, 1, N'Married', 303, 469.99, 0, 10, 303, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (178, 1, N'Married', 470, 1454.99, 16.7, 15, 470, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (179, 1, N'Married', 1455, 2271.99, 164.45, 25, 1455, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (180, 1, N'Married', 2272, 4164.99, 368.7, 28, 2272, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (181, 1, N'Married', 4165, 7320.99, 898.74, 33, 4165, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (182, 1, N'Married', 7321, NULL, 1940.22, 35, 7321, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (183, 1, N'Single', 0, 137.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (184, 1, N'Single', 138, 199.99, 0, 10, 138, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (185, 1, N'Single', 200, 695.99, 6.2, 15, 200, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (186, 1, N'Single', 696, 1278.99, 80.6, 25, 696, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (187, 1, N'Single', 1279, 3337.99, 226.35, 28, 1279, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (188, 1, N'Single', 3338, 7211.99, 802.87, 33, 3338, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (189, 1, N'Single', 7212, NULL, 2081.29, 35, 7212, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (190, 2, N'HeadofHousehold', 0, 275.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (191, 2, N'HeadofHousehold', 276, 399.99, 0, 10, 276, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (192, 2, N'HeadofHousehold', 400, 1391.99, 12.4, 15, 400, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (193, 2, N'HeadofHousehold', 1392, 2558.99, 161.2, 25, 1392, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (194, 2, N'HeadofHousehold', 2559, 6676.99, 452.95, 28, 2559, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (195, 2, N'HeadofHousehold', 6677, 14422.99, 1605.99, 33, 6677, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (196, 2, N'HeadofHousehold', 14423, NULL, 4162.17, 35, 14423, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (197, 2, N'Married', 0, 605.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (198, 2, N'Married', 606, 939.99, 0, 10, 606, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (199, 2, N'Married', 940, 2909.99, 33.4, 15, 940, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (200, 2, N'Married', 2910, 4542.99, 328.9, 25, 2910, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (201, 2, N'Married', 4543, 8330.99, 737.15, 28, 4543, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (202, 2, N'Married', 8331, 14641.99, 1797.79, 33, 8331, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (203, 2, N'Married', 14642, NULL, 3880.42, 35, 14642, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (204, 2, N'Single', 0, 275.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (205, 2, N'Single', 276, 399.99, 0, 10, 276, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (206, 2, N'Single', 400, 1391.99, 12.4, 15, 400, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (207, 2, N'Single', 1392, 2558.99, 161.2, 25, 1392, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (208, 2, N'Single', 2559, 6676.99, 452.95, 28, 2559, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (209, 2, N'Single', 6677, 14422.99, 1605.99, 33, 6677, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (210, 2, N'Single', 14423, NULL, 4162.17, 35, 14423, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (211, 3, N'HeadofHousehold', 0, 298.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (212, 3, N'HeadofHousehold', 299, 432.99, 0, 10, 299, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (213, 3, N'HeadofHousehold', 433, 1507.99, 13.4, 15, 433, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (214, 3, N'HeadofHousehold', 1508, 2771.99, 174.65, 25, 1508, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (215, 3, N'HeadofHousehold', 2772, 7232.99, 490.65, 28, 2772, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (216, 3, N'HeadofHousehold', 7233, 15624.99, 1739.73, 33, 7233, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (217, 3, N'HeadofHousehold', 15625, NULL, 4509.09, 35, 15625, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (218, 3, N'Married', 0, 655.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (219, 3, N'Married', 656, 1018.99, 0, 10, 656, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (220, 3, N'Married', 1019, 3151.99, 36.3, 15, 1019, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (221, 3, N'Married', 3152, 4921.99, 356.25, 25, 3152, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (222, 3, N'Married', 4922, 9024.99, 798.75, 28, 4922, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (223, 3, N'Married', 9025, 15862.99, 1947.59, 33, 9025, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (224, 3, N'Married', 15863, NULL, 4204.13, 35, 15863, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (225, 3, N'Single', 0, 298.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (226, 3, N'Single', 299, 432.99, 0, 10, 299, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (227, 3, N'Single', 433, 1507.99, 13.4, 15, 433, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (228, 3, N'Single', 1508, 2771.99, 174.65, 25, 1508, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (229, 3, N'Single', 2772, 7232.99, 490.65, 28, 2772, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (230, 3, N'Single', 7233, 15624.99, 1739.73, 33, 7233, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (231, 3, N'Single', 15625, NULL, 4509.09, 35, 15625, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (232, 4, N'HeadofHousehold', 0, 597.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (233, 4, N'HeadofHousehold', 598, 866.99, 0, 10, 598, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (234, 4, N'HeadofHousehold', 867, 3016.99, 26.9, 15, 867, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (235, 4, N'HeadofHousehold', 3017, 5543.99, 349.4, 25, 3017, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (236, 4, N'HeadofHousehold', 5544, 14466.99, 981.15, 28, 5544, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (237, 4, N'HeadofHousehold', 14467, 31249.99, 3479.59, 33, 14467, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (238, 4, N'HeadofHousehold', 31250, NULL, 9017.98, 35, 31250, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (239, 4, N'Married', 0, 1312.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (240, 4, N'Married', 1313, 2037.99, 0, 10, 1313, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (241, 4, N'Married', 2038, 6303.99, 72.5, 15, 2038, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (242, 4, N'Married', 6304, 9843.99, 712.4, 25, 6304, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (243, 4, N'Married', 9844, 18049.99, 1597.4, 28, 9844, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (244, 4, N'Married', 18050, 31724.99, 3895.08, 33, 18050, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (245, 4, N'Married', 31725, NULL, 8407.83, 35, 31725, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (246, 4, N'Single', 0, 597.99, 0, 0, 0, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (247, 4, N'Single', 598, 866.99, 0, 10, 598, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (248, 4, N'Single', 867, 3016.99, 26.9, 15, 867, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (249, 4, N'Single', 3017, 5543.99, 349.4, 25, 3017, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (250, 4, N'Single', 5544, 14466.99, 981.15, 28, 5544, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (251, 4, N'Single', 14467, 31249.99, 3479.59, 33, 14467, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (252, 4, N'Single', 31250, NULL, 9017.98, 35, 31250, 2009)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (253, 1, N'HeadofHousehold', 0, 115.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (254, 1, N'HeadofHousehold', 116, 199.99, 0, 10, 116, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (255, 1, N'HeadofHousehold', 200, 692.99, 8.4, 15, 200, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (256, 1, N'HeadofHousehold', 693, 1301.99, 82.35, 25, 693, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (257, 1, N'HeadofHousehold', 1302, 1623.99, 234.6, 27, 1302, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (258, 1, N'HeadofHousehold', 1624, 1686.99, 321.54, 30, 1624, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (259, 1, N'HeadofHousehold', 1687, 3343.99, 340.44, 28, 1687, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (260, 1, N'Married', 0, 263.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (261, 1, N'Married', 264, 470.99, 0, 10, 264, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (262, 1, N'Married', 471, 1456.99, 20.7, 15, 471, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (263, 1, N'Married', 1457, 1808.99, 168.6, 25, 1457, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (264, 1, N'Married', 1809, 2385.99, 256.6, 27, 1809, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (265, 1, N'Married', 2386, 2788.99, 412.39, 25, 2386, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (266, 1, N'Married', 2789, 4172.99, 513.14, 28, 2789, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (267, 1, N'Single', 0, 115.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (268, 1, N'Single', 116, 199.99, 0, 10, 116, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (269, 1, N'Single', 200, 692.99, 8.4, 15, 200, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (270, 1, N'Single', 693, 1301.99, 82.35, 25, 693, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (271, 1, N'Single', 1302, 1623.99, 234.6, 27, 1302, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (272, 1, N'Single', 1624, 1686.99, 321.54, 30, 1624, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (273, 1, N'Single', 1687, 3343.99, 340.44, 28, 1687, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (274, 2, N'HeadofHousehold', 0, 232.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (275, 2, N'HeadofHousehold', 233, 400.99, 0, 10, 233, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (276, 2, N'HeadofHousehold', 401, 1386.99, 16.8, 15, 401, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (277, 2, N'HeadofHousehold', 1387, 2603.99, 164.7, 25, 1387, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (278, 2, N'HeadofHousehold', 2604, 3247.99, 468.95, 27, 2604, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (279, 2, N'HeadofHousehold', 3248, 3372.99, 642.83, 30, 3248, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (280, 2, N'HeadofHousehold', 3373, 6687.99, 680.33, 28, 3373, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (281, 2, N'Married', 0, 528.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (282, 2, N'Married', 529, 941.99, 0, 10, 529, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (283, 2, N'Married', 942, 2912.99, 41.3, 15, 942, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (284, 2, N'Married', 2913, 3616.99, 336.95, 25, 2913, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (285, 2, N'Married', 3617, 4770.99, 512.95, 27, 3617, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (286, 2, N'Married', 4771, 5578.99, 824.53, 25, 4771, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (287, 2, N'Married', 5579, 8345.99, 1026.53, 28, 5579, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (288, 2, N'Single', 0, 232.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (289, 2, N'Single', 233, 400.99, 0, 10, 233, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (290, 2, N'Single', 401, 1386.99, 16.8, 15, 401, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (291, 2, N'Single', 1387, 2603.99, 164.7, 25, 1387, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (292, 2, N'Single', 2604, 3247.99, 468.95, 27, 2604, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (293, 2, N'Single', 3248, 3372.99, 642.83, 30, 3248, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (294, 2, N'Single', 3373, 6687.99, 680.33, 28, 3373, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (295, 3, N'HeadofHousehold', 0, 251.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (296, 3, N'HeadofHousehold', 252, 433.99, 0, 10, 252, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (297, 3, N'HeadofHousehold', 434, 1501.99, 18.2, 15, 434, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (298, 3, N'HeadofHousehold', 1502, 2820.99, 178.4, 25, 1502, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (299, 3, N'HeadofHousehold', 2821, 3518.99, 508.15, 27, 2821, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (300, 3, N'HeadofHousehold', 3519, 3653.99, 696.61, 30, 3519, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (301, 3, N'HeadofHousehold', 3654, 7245.99, 737.11, 28, 3654, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (302, 3, N'Married', 0, 572.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (303, 3, N'Married', 573, 1020.99, 0, 10, 573, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (304, 3, N'Married', 1021, 3155.99, 44.8, 15, 1021, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (305, 3, N'Married', 3156, 3918.99, 365.05, 25, 3156, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (306, 3, N'Married', 3919, 5168.99, 555.8, 27, 3919, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (307, 3, N'Married', 5169, 6043.99, 893.3, 25, 5169, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (308, 3, N'Married', 6044, 9041.99, 1112.05, 28, 6044, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (309, 3, N'Single', 0, 251.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (310, 3, N'Single', 252, 433.99, 0, 10, 252, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (311, 3, N'Single', 434, 1501.99, 18.2, 15, 434, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (312, 3, N'Single', 1502, 2820.99, 178.4, 25, 1502, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (313, 3, N'Single', 2821, 3518.99, 508.15, 27, 2821, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (314, 3, N'Single', 3519, 3653.99, 696.61, 30, 3519, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (315, 3, N'Single', 3654, 7245.99, 737.11, 28, 3654, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (316, 4, N'HeadofHousehold', 0, 503.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (317, 4, N'HeadofHousehold', 504, 868.99, 0, 10, 504, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (318, 4, N'HeadofHousehold', 869, 3003.99, 36.5, 15, 869, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (319, 4, N'HeadofHousehold', 3004, 5641.99, 356.75, 25, 3004, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (320, 4, N'HeadofHousehold', 5642, 7037.99, 1016.25, 27, 5642, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (321, 4, N'HeadofHousehold', 7038, 7307.99, 1393.17, 30, 7038, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (322, 4, N'HeadofHousehold', 7308, 14491.99, 1474.17, 28, 7308, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (323, 4, N'Married', 0, 1145.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (324, 4, N'Married', 1146, 2041.99, 0, 10, 1146, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (325, 4, N'Married', 2042, 6312.99, 89.6, 15, 2042, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (326, 4, N'Married', 6313, 7837.99, 730.25, 25, 6313, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (327, 4, N'Married', 7838, 10337.99, 1111.5, 27, 7838, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (328, 4, N'Married', 10338, 12087.99, 1786.5, 25, 10338, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (329, 4, N'Married', 12088, 18082.99, 2224, 28, 12088, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (330, 4, N'Single', 0, 503.99, 0, 0, 0, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (331, 4, N'Single', 504, 868.99, 0, 10, 504, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (332, 4, N'Single', 869, 3003.99, 36.5, 15, 869, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (333, 4, N'Single', 3004, 5641.99, 356.75, 25, 3004, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (334, 4, N'Single', 5642, 7037.99, 1016.25, 27, 5642, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (335, 4, N'Single', 7038, 7307.99, 1393.17, 30, 7038, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (336, 4, N'Single', 7308, 14491.99, 1474.17, 28, 7308, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (337, 1, N'Single', 3344, 7224.99, 804.4, 33, 3344, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (338, 1, N'Single', 7225, NULL, 2085.13, 35, 7225, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (339, 1, N'HeadOfHousehold', 3344, 7224.99, 804.4, 33, 3344, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (340, 1, N'HeadOfHousehold', 7225, NULL, 2085.13, 35, 7225, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (341, 1, N'Married', 4173, 7334.99, 900.66, 33, 4173, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (342, 1, N'Married', 7335, NULL, 1944.12, 35, 7335, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (343, 2, N'Married', 8346, 14668.99, 1801.29, 33, 8346, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (344, 2, N'Married', 14669, NULL, 3887.88, 35, 14669, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (345, 2, N'Single', 6688, 14449.99, 1608.53, 33, 6688, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (346, 2, N'Single', 14450, NULL, 4169.99, 35, 14450, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (347, 2, N'HeadOfHousehold', 6688, 14449.99, 1608.53, 33, 6688, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (348, 2, N'HeadOfHousehold', 14450, NULL, 4169.99, 35, 14450, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (349, 3, N'Single', 7246, 15653.99, 1742.87, 33, 7246, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (350, 3, N'Single', 15654, NULL, 4517.51, 35, 15654, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (351, 3, N'HeadOfHousehold', 7246, 15653.99, 1742.87, 33, 7246, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (352, 3, N'HeadOfHousehold', 15654, NULL, 4517.51, 35, 15654, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (353, 3, N'Married', 9042, 15891.99, 1951.49, 33, 9042, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (354, 3, N'Married', 15892, NULL, 4211.99, 35, 15892, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (355, 4, N'Single', 14492, 31307.99, 3485.69, 33, 14492, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (356, 4, N'Single', 31308, NULL, 9034.97, 35, 31308, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (357, 4, N'HeadOfHousehold', 14492, 31307.99, 3485.69, 33, 14492, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (358, 4, N'HeadOfHousehold', 31308, NULL, 9034.97, 35, 31308, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (359, 4, N'Married', 18083, 31782.99, 3902.6, 33, 18083, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (360, 4, N'Married', 31783, NULL, 8423.6, 35, 31783, 2010)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (361, 1, N'HeadofHousehold', 0, 39.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (362, 1, N'HeadofHousehold', 40, 203.99, 0, 10, 40, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (363, 1, N'HeadofHousehold', 204, 703.99, 16.4, 15, 204, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (364, 1, N'HeadofHousehold', 704, 1647.99, 91.4, 25, 704, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (365, 1, N'HeadofHousehold', 1648, 3393.99, 327.4, 28, 1648, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (366, 1, N'HeadofHousehold', 3394, 7331.99, 816.28, 33, 3394, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (367, 1, N'HeadofHousehold', 7332, NULL, 2115.82, 35, 7332, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (368, 1, N'Married', 0, 151.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (369, 1, N'Married', 152, 478.99, 0, 10, 152, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (370, 1, N'Married', 479, 1478.99, 32.7, 15, 479, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (371, 1, N'Married', 1479, 2831.99, 182.7, 25, 1479, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (372, 1, N'Married', 2832, 4234.99, 520.95, 28, 2832, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (373, 1, N'Married', 4235, 7442.99, 913.79, 33, 4235, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (374, 1, N'Married', 7443, NULL, 1972.43, 35, 7443, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (375, 1, N'Single', 0, 39.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (376, 1, N'Single', 40, 203.99, 0, 10, 40, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (377, 1, N'Single', 204, 703.99, 16.4, 15, 204, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (378, 1, N'Single', 704, 1647.99, 91.4, 25, 704, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (379, 1, N'Single', 1648, 3393.99, 327.4, 28, 1648, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (380, 1, N'Single', 3394, 7331.99, 816.28, 33, 3394, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (381, 1, N'Single', 7332, NULL, 2115.82, 35, 7332, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (382, 2, N'HeadofHousehold', 0, 80.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (383, 2, N'HeadofHousehold', 81, 407.99, 0, 10, 81, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (384, 2, N'HeadofHousehold', 408, 1407.99, 32.7, 15, 408, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (385, 2, N'HeadofHousehold', 1408, 3295.99, 182.7, 25, 1408, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (386, 2, N'HeadofHousehold', 3296, 6787.99, 654.7, 28, 3296, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (387, 2, N'HeadofHousehold', 6788, 14662.99, 1632.46, 33, 6788, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (388, 2, N'HeadofHousehold', 14663, NULL, 4231.21, 35, 14663, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (389, 2, N'Married', 0, 303.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (390, 2, N'Married', 304, 957.99, 0, 10, 304, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (391, 2, N'Married', 958, 2957.99, 65.4, 15, 958, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (392, 2, N'Married', 2958, 5662.99, 365.4, 25, 2958, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (393, 2, N'Married', 5663, 8468.99, 1041.65, 28, 5663, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (394, 2, N'Married', 8469, 14886.99, 1827.33, 33, 8469, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (395, 2, N'Married', 14887, NULL, 3945.27, 35, 14887, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (396, 2, N'Single', 0, 80.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (397, 2, N'Single', 81, 407.99, 0, 10, 81, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (398, 2, N'Single', 408, 1407.99, 32.7, 15, 408, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (399, 2, N'Single', 1408, 3295.99, 182.7, 25, 1408, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (400, 2, N'Single', 3296, 6787.99, 654.7, 28, 3296, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (401, 2, N'Single', 6788, 14662.99, 1632.46, 33, 6788, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (402, 2, N'Single', 14663, NULL, 4231.21, 35, 14663, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (403, 3, N'HeadofHousehold', 0, 87.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (404, 3, N'HeadofHousehold', 88, 441.99, 0, 10, 88, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (405, 3, N'HeadofHousehold', 442, 1524.99, 35.4, 15, 442, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (406, 3, N'HeadofHousehold', 1525, 3570.99, 197.85, 25, 1525, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (407, 3, N'HeadofHousehold', 3571, 7353.99, 709.35, 28, 3571, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (408, 3, N'HeadofHousehold', 7354, 15884.99, 1768.59, 33, 7354, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (409, 3, N'HeadofHousehold', 15885, NULL, 4583.82, 35, 15885, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (410, 3, N'Married', 0, 328.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (411, 3, N'Married', 329, 1037.99, 0, 10, 329, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (412, 3, N'Married', 1038, 3203.99, 70.9, 15, 1038, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (413, 3, N'Married', 3204, 6134.99, 395.8, 25, 3204, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (414, 3, N'Married', 6135, 9174.99, 1128.55, 28, 6135, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (415, 3, N'Married', 9175, 16126.99, 1979.75, 33, 9175, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (416, 3, N'Married', 16127, NULL, 4273.91, 35, 16127, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (417, 3, N'Single', 0, 87.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (418, 3, N'Single', 88, 441.99, 0, 10, 88, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (419, 3, N'Single', 442, 1524.99, 35.4, 15, 442, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (420, 3, N'Single', 1525, 3570.99, 197.85, 25, 1525, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (421, 3, N'Single', 3571, 7353.99, 709.35, 28, 3571, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (422, 3, N'Single', 7354, 15884.99, 1768.59, 33, 7354, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (423, 3, N'Single', 15885, NULL, 4583.82, 35, 15885, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (424, 4, N'HeadofHousehold', 0, 174.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (425, 4, N'HeadofHousehold', 175, 882.99, 0, 10, 175, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (426, 4, N'HeadofHousehold', 883, 3049.99, 70.8, 15, 883, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (427, 4, N'HeadofHousehold', 3050, 7141.99, 395.85, 25, 3050, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (428, 4, N'HeadofHousehold', 7142, 14707.99, 1418.85, 28, 7142, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (429, 4, N'HeadofHousehold', 14708, 31770.99, 3537.33, 33, 14708, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (430, 4, N'HeadofHousehold', 31771, NULL, 9168.12, 35, 31771, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (431, 4, N'Married', 0, 657.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (432, 4, N'Married', 658, 2074.99, 0, 10, 658, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (433, 4, N'Married', 2075, 6407.99, 141.7, 15, 2075, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (434, 4, N'Married', 6408, 12270.99, 791.65, 25, 6408, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (435, 4, N'Married', 12271, 18349.99, 2257.4, 28, 12271, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (436, 4, N'Married', 18350, 32253.99, 3959.52, 33, 18350, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (437, 4, N'Married', 32254, NULL, 8547.84, 35, 32254, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (438, 4, N'Single', 0, 174.99, 0, 0, 0, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (439, 4, N'Single', 175, 882.99, 0, 10, 175, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (440, 4, N'Single', 883, 3049.99, 70.8, 15, 883, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (441, 4, N'Single', 3050, 7141.99, 395.85, 25, 3050, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (442, 4, N'Single', 7142, 14707.99, 1418.85, 28, 7142, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (443, 4, N'Single', 14708, 31770.99, 3537.33, 33, 14708, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (444, 4, N'Single', 31771, NULL, 9168.12, 35, 31771, 2011)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (445, 1, N'HeadofHousehold', 0, 40.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (446, 1, N'HeadofHousehold', 41, 208.99, 0, 10, 41, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (447, 1, N'HeadofHousehold', 209, 720.99, 16.8, 15, 209, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (448, 1, N'HeadofHousehold', 721, 1687.99, 93.6, 25, 721, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (449, 1, N'HeadofHousehold', 1688, 3476.99, 335.35, 28, 1688, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (450, 1, N'HeadofHousehold', 3477, 7509.99, 836.27, 33, 3477, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (451, 1, N'HeadofHousehold', 7510, NULL, 2167.16, 35, 7510, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (452, 1, N'Married', 0, 155.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (453, 1, N'Married', 156, 489.99, 0, 10, 156, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (454, 1, N'Married', 490, 1514.99, 33.4, 15, 490, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (455, 1, N'Married', 1515, 2899.99, 187.15, 25, 1515, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (456, 1, N'Married', 2900, 4337.99, 533.4, 28, 2900, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (457, 1, N'Married', 4338, 7623.99, 936.04, 33, 4338, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (458, 1, N'Married', 7624, NULL, 2020.42, 35, 7624, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (459, 1, N'Single', 0, 40.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (460, 1, N'Single', 41, 208.99, 0, 10, 41, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (461, 1, N'Single', 209, 720.99, 16.8, 15, 209, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (462, 1, N'Single', 721, 1687.99, 93.6, 25, 721, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (463, 1, N'Single', 1688, 3476.99, 335.35, 28, 1688, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (464, 1, N'Single', 3477, 7509.99, 836.27, 33, 3477, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (465, 1, N'Single', 7510, NULL, 2167.16, 35, 7510, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (466, 2, N'HeadofHousehold', 0, 82.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (467, 2, N'HeadofHousehold', 83, 416.99, 0, 10, 83, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (468, 2, N'HeadofHousehold', 417, 1441.99, 33.4, 15, 417, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (469, 2, N'HeadofHousehold', 1442, 3376.99, 187.15, 25, 1442, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (470, 2, N'HeadofHousehold', 3377, 6953.99, 670.9, 28, 3377, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (471, 2, N'HeadofHousehold', 6954, 15018.99, 1672.46, 33, 6954, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (472, 2, N'HeadofHousehold', 15019, NULL, 4333.91, 35, 15019, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (473, 2, N'Married', 0, 311.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (474, 2, N'Married', 312, 980.99, 0, 10, 312, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (475, 2, N'Married', 981, 3030.99, 66.9, 15, 981, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (476, 2, N'Married', 3031, 5799.99, 374.4, 25, 3031, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (477, 2, N'Married', 5800, 8674.99, 1066.65, 28, 5800, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (478, 2, N'Married', 8675, 15247.99, 1871.65, 33, 8675, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (479, 2, N'Married', 15248, NULL, 4040.74, 35, 15248, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (480, 2, N'Single', 0, 82.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (481, 2, N'Single', 83, 416.99, 0, 10, 83, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (482, 2, N'Single', 417, 1441.99, 33.4, 15, 417, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (483, 2, N'Single', 1442, 3376.99, 187.15, 25, 1442, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (484, 2, N'Single', 3377, 6953.99, 670.9, 28, 3377, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (485, 2, N'Single', 6954, 15018.99, 1672.46, 33, 6954, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (486, 2, N'Single', 15019, NULL, 4333.91, 35, 15019, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (487, 3, N'HeadofHousehold', 0, 89.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (488, 3, N'HeadofHousehold', 90, 452.99, 0, 10, 90, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (489, 3, N'HeadofHousehold', 453, 1562.99, 36.2, 15, 453, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (490, 3, N'HeadofHousehold', 1563, 3657.99, 202.85, 25, 1563, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (491, 3, N'HeadofHousehold', 3658, 7532.99, 726.6, 28, 3658, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (492, 3, N'HeadofHousehold', 7533, 16270.99, 1811.6, 33, 7533, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (493, 3, N'HeadofHousehold', 16271, NULL, 4695.14, 35, 16271, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (494, 3, N'Married', 0, 337.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (495, 3, N'Married', 338, 1062.99, 0, 10, 338, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (496, 3, N'Married', 1063, 3282.99, 72.5, 15, 1063, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (497, 3, N'Married', 3283, 6282.99, 405.5, 25, 3283, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (498, 3, N'Married', 6283, 9397.99, 1155.5, 28, 6283, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (499, 3, N'Married', 9398, 16518.99, 2027.7, 33, 9398, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (500, 3, N'Married', 16519, NULL, 4377.63, 35, 16519, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (501, 3, N'Single', 0, 89.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (502, 3, N'Single', 90, 452.99, 0, 10, 90, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (503, 3, N'Single', 453, 1562.99, 36.2, 15, 453, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (504, 3, N'Single', 1563, 3657.99, 202.85, 25, 1563, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (505, 3, N'Single', 3658, 7532.99, 726.6, 28, 3658, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (506, 3, N'Single', 7533, 16270.99, 1811.6, 33, 7533, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (507, 3, N'Single', 16271, NULL, 4695.14, 35, 16271, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (508, 4, N'HeadofHousehold', 0, 178.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (509, 4, N'HeadofHousehold', 179, 903.99, 0, 10, 179, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (510, 4, N'HeadofHousehold', 904, 3124.99, 72.5, 15, 904, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (511, 4, N'HeadofHousehold', 3125, 7316.99, 405.65, 25, 3125, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (512, 4, N'HeadofHousehold', 7317, 15066.99, 1453.65, 28, 7317, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (513, 4, N'HeadofHousehold', 15067, 32541.99, 3623.65, 33, 15067, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (514, 4, N'HeadofHousehold', 32542, NULL, 9390.4, 35, 32542, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (515, 4, N'Married', 0, 674.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (516, 4, N'Married', 675, 2124.99, 0, 10, 675, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (517, 4, N'Married', 2125, 6566.99, 145, 15, 2125, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (518, 4, N'Married', 6567, 12566.99, 811.3, 25, 6567, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (519, 4, N'Married', 12567, 18795.99, 2311.3, 28, 12567, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (520, 4, N'Married', 18796, 33037.99, 4055.42, 33, 18796, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (521, 4, N'Married', 33038, NULL, 8755.28, 35, 33038, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (522, 4, N'Single', 0, 178.99, 0, 0, 0, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (523, 4, N'Single', 179, 903.99, 0, 10, 179, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (524, 4, N'Single', 904, 3124.99, 72.5, 15, 904, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (525, 4, N'Single', 3125, 7316.99, 405.65, 25, 3125, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (526, 4, N'Single', 7317, 15066.99, 1453.65, 28, 7317, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (527, 4, N'Single', 15067, 32541.99, 3623.65, 33, 15067, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (528, 4, N'Single', 32542, NULL, 9390.4, 35, 32542, 2012)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (529, 1, N'HeadofHousehold', 0, 41.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (530, 1, N'HeadofHousehold', 42, 738.99, 0, 15, 42, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (531, 1, N'HeadofHousehold', 739, 1731.99, 104.55, 28, 739, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (532, 1, N'HeadofHousehold', 1732, 3565.99, 382.59, 31, 1732, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (533, 1, N'HeadofHousehold', 3566, 7702.99, 951.13, 36, 3566, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (534, 1, N'HeadofHousehold', 7703, NULL, 2440.45, 39.6, 7703, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (535, 1, N'Married', 0, 119.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (536, 1, N'Married', 120, 1284.99, 0, 15, 120, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (537, 1, N'Married', 1285, 2935.99, 174.75, 28, 1285, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (538, 1, N'Married', 2936, 4409.99, 637.03, 31, 2936, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (539, 1, N'Married', 4410, 7780.99, 1093.97, 36, 4410, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (540, 1, N'Married', 7781, NULL, 2307.53, 39.6, 7781, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (541, 1, N'Single', 0, 41.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (542, 1, N'Single', 42, 738.99, 0, 15, 42, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (543, 1, N'Single', 739, 1731.99, 104.55, 28, 739, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (544, 1, N'Single', 1732, 3565.99, 382.59, 31, 1732, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (545, 1, N'Single', 3566, 7702.99, 951.13, 36, 3566, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (546, 1, N'Single', 7703, NULL, 2440.45, 39.6, 7703, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (547, 2, N'HeadofHousehold', 0, 84.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (548, 2, N'HeadofHousehold', 85, 1478.99, 0, 15, 85, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (549, 2, N'HeadofHousehold', 1479, 3462.99, 209.1, 28, 1479, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (550, 2, N'HeadofHousehold', 3463, 7132.99, 764.62, 31, 3463, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (551, 2, N'HeadofHousehold', 7133, 15405.99, 1902.32, 36, 7133, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (552, 2, N'HeadofHousehold', 15406, NULL, 4880.6, 39.6, 15406, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (553, 2, N'Married', 0, 239.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (554, 2, N'Married', 240, 2568.99, 0, 15, 240, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (555, 2, N'Married', 2569, 5870.99, 349.35, 28, 2569, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (556, 2, N'Married', 5871, 8818.99, 1273.91, 31, 5871, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (557, 2, N'Married', 8819, 15561.99, 2187.79, 36, 8819, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (558, 2, N'Married', 15562, NULL, 4615.27, 39.6, 15562, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (559, 2, N'Single', 0, 84.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (560, 2, N'Single', 85, 1478.99, 0, 15, 85, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (561, 2, N'Single', 1479, 3462.99, 209.1, 28, 1479, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (562, 2, N'Single', 3463, 7132.99, 764.62, 31, 3463, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (563, 2, N'Single', 7133, 15405.99, 1902.32, 36, 7133, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (564, 2, N'Single', 15406, NULL, 4880.6, 39.6, 15406, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (565, 3, N'HeadofHousehold', 0, 91.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (566, 3, N'HeadofHousehold', 92, 1601.99, 0, 15, 92, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (567, 3, N'HeadofHousehold', 1602, 3751.99, 226.5, 28, 1602, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (568, 3, N'HeadofHousehold', 3752, 7726.99, 828.5, 31, 3752, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (569, 3, N'HeadofHousehold', 7727, 16689.99, 2060.75, 36, 7727, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (570, 3, N'HeadofHousehold', 16690, NULL, 5287.43, 39.6, 16690, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (571, 3, N'Married', 0, 259.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (572, 3, N'Married', 260, 2782.99, 0, 15, 260, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (573, 3, N'Married', 2783, 6359.99, 378.45, 28, 2783, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (574, 3, N'Married', 6360, 9553.99, 1380.01, 31, 6360, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (575, 3, N'Married', 9554, 16857.99, 2370.15, 36, 9554, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (576, 3, N'Married', 16858, NULL, 4999.59, 39.6, 16858, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (577, 3, N'Single', 0, 91.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (578, 3, N'Single', 92, 1601.99, 0, 15, 92, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (579, 3, N'Single', 1602, 3751.99, 226.5, 28, 1602, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (580, 3, N'Single', 3752, 7726.99, 828.5, 31, 3752, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (581, 3, N'Single', 7727, 16689.99, 2060.75, 36, 7727, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (582, 3, N'Single', 16690, NULL, 5287.43, 39.6, 16690, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (583, 4, N'HeadofHousehold', 0, 182.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (584, 4, N'HeadofHousehold', 183, 3203.99, 0, 15, 183, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (585, 4, N'HeadofHousehold', 3204, 7503.99, 453.15, 28, 3204, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (586, 4, N'HeadofHousehold', 7504, 15453.99, 1657.15, 31, 7504, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (587, 4, N'HeadofHousehold', 15454, 33378.99, 4121.65, 36, 15454, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (588, 4, N'HeadofHousehold', 33379, NULL, 10574.65, 39.6, 33379, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (589, 4, N'Married', 0, 520.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (590, 4, N'Married', 521, 5566.99, 0, 15, 521, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (591, 4, N'Married', 5567, 12720.99, 756.9, 28, 5567, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (592, 4, N'Married', 12721, 19107.99, 2760.02, 31, 12721, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (593, 4, N'Married', 19108, 33716.99, 4739.99, 36, 19108, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (594, 4, N'Married', 33717, NULL, 9999.23, 39.6, 33717, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (595, 4, N'Single', 0, 182.99, 0, 0, 0, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (596, 4, N'Single', 183, 3203.99, 0, 15, 183, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (597, 4, N'Single', 3204, 7503.99, 453.15, 28, 3204, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (598, 4, N'Single', 7504, 15453.99, 1657.15, 31, 7504, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (599, 4, N'Single', 15454, 33378.99, 4121.65, 36, 15454, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (600, 4, N'Single', 33379, NULL, 10574.65, 39.6, 33379, 2013)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (601, 1, N'HeadofHousehold', 0, 42.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (602, 1, N'HeadofHousehold', 43, 217.99, 0, 10, 43, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (603, 1, N'HeadofHousehold', 218, 752.99, 17.5, 15, 218, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (604, 1, N'HeadofHousehold', 753, 1761.99, 97.75, 25, 753, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (605, 1, N'HeadofHousehold', 1762, 3626.99, 350, 28, 1762, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (606, 1, N'HeadofHousehold', 3627, 7833.99, 872.2, 33, 3627, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (607, 1, N'HeadofHousehold', 7834, 7864.99, 2260.51, 35, 7834, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (608, 1, N'Married', 0, 162.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (609, 1, N'Married', 163, 511.99, 0, 10, 163, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (610, 1, N'Married', 512, 1581.99, 34.9, 15, 512, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (611, 1, N'Married', 1582, 3024.99, 195.4, 25, 1582, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (612, 1, N'Married', 3025, 4524.99, 556.15, 28, 3025, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (613, 1, N'Married', 4525, 7952.99, 976.15, 33, 4525, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (614, 1, N'Married', 7953, 8962.99, 2107.39, 35, 7953, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (615, 1, N'Single', 0, 42.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (616, 1, N'Single', 43, 217.99, 0, 10, 43, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (617, 1, N'Single', 218, 752.99, 17.5, 15, 218, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (618, 1, N'Single', 753, 1761.99, 97.75, 25, 753, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (619, 1, N'Single', 1762, 3626.99, 350, 28, 1762, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (620, 1, N'Single', 3627, 7833.99, 872.2, 33, 3627, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (621, 1, N'Single', 7834, 7864.99, 2260.51, 35, 7834, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (622, 2, N'HeadofHousehold', 0, 86.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (623, 2, N'HeadofHousehold', 87, 435.99, 0, 10, 87, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (624, 2, N'HeadofHousehold', 436, 1505.99, 34.9, 15, 436, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (625, 2, N'HeadofHousehold', 1506, 3522.99, 195.4, 25, 1506, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (626, 2, N'HeadofHousehold', 3523, 7253.99, 699.65, 28, 3523, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (627, 2, N'HeadofHousehold', 7254, 15666.99, 1744.33, 33, 7254, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (628, 2, N'HeadofHousehold', 15667, 15730.99, 4520.62, 35, 15667, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (629, 2, N'Married', 0, 324.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (630, 2, N'Married', 325, 1022.99, 0, 10, 325, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (631, 2, N'Married', 1023, 3162.99, 69.8, 15, 1023, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (632, 2, N'Married', 3163, 6049.99, 390.8, 25, 3163, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (633, 2, N'Married', 6050, 9049.99, 1112.55, 28, 6050, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (634, 2, N'Married', 9050, 15905.99, 1952.55, 33, 9050, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (635, 2, N'Married', 15906, 17924.99, 4215.03, 35, 15906, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (636, 2, N'Single', 0, 86.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (637, 2, N'Single', 87, 435.99, 0, 10, 87, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (638, 2, N'Single', 436, 1505.99, 34.9, 15, 436, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (639, 2, N'Single', 1506, 3522.99, 195.4, 25, 1506, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (640, 2, N'Single', 3523, 7253.99, 699.65, 28, 3523, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (641, 2, N'Single', 7254, 15666.99, 1744.33, 33, 7254, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (642, 2, N'Single', 15667, 15730.99, 4520.62, 35, 15667, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (643, 3, N'HeadofHousehold', 0, 93.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (644, 3, N'HeadofHousehold', 94, 471.99, 0, 10, 94, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (645, 3, N'HeadofHousehold', 472, 1630.99, 37.8, 15, 472, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (646, 3, N'HeadofHousehold', 1631, 3816.99, 211.65, 25, 1631, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (647, 3, N'HeadofHousehold', 3817, 7857.99, 758.15, 28, 3817, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (648, 3, N'HeadofHousehold', 7858, 16972.99, 1889.63, 33, 7858, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (649, 3, N'HeadofHousehold', 16973, 17041.99, 4897.58, 35, 16973, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (650, 3, N'Married', 0, 351.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (651, 3, N'Married', 352, 1107.99, 0, 10, 352, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (652, 3, N'Married', 1108, 3426.99, 75.6, 15, 1108, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (653, 3, N'Married', 3427, 6553.99, 423.45, 25, 3427, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (654, 3, N'Married', 6554, 9803.99, 1205.2, 28, 6554, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (655, 3, N'Married', 9804, 17230.99, 2115.2, 33, 9804, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (656, 3, N'Married', 17231, 19418.99, 4566.11, 35, 17231, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (657, 3, N'Single', 0, 93.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (658, 3, N'Single', 94, 471.99, 0, 10, 94, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (659, 3, N'Single', 472, 1630.99, 37.8, 15, 472, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (660, 3, N'Single', 1631, 3816.99, 211.65, 25, 1631, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (661, 3, N'Single', 3817, 7857.99, 758.15, 28, 3817, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (662, 3, N'Single', 7858, 16972.99, 1889.63, 33, 7858, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (663, 3, N'Single', 16973, 17041.99, 4897.6, 35, 16973, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (664, 4, N'HeadofHousehold', 0, 187.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (665, 4, N'HeadofHousehold', 188, 943.99, 0, 10, 188, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (666, 4, N'HeadofHousehold', 944, 3262.99, 75.6, 15, 944, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (667, 4, N'HeadofHousehold', 3263, 7632.99, 423.45, 25, 3263, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (668, 4, N'HeadofHousehold', 7633, 15716.99, 1515.95, 28, 7633, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (669, 4, N'HeadofHousehold', 15717, 33945.99, 3779.47, 33, 15717, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (670, 4, N'HeadofHousehold', 33946, 34082.99, 9795.04, 35, 33946, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (671, 4, N'Married', 0, 703.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (672, 4, N'Married', 704, 2216.99, 0, 10, 704, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (673, 4, N'Married', 2217, 6853.99, 151.3, 15, 2217, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (674, 4, N'Married', 6854, 13107.99, 846.85, 25, 6854, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (675, 4, N'Married', 13108, 19607.99, 2410.35, 28, 13108, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (676, 4, N'Married', 19608, 34462.99, 4230.35, 33, 19608, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (677, 4, N'Married', 34463, 38837.99, 9132.5, 35, 34463, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (678, 4, N'Single', 0, 187.99, 0, 0, 0, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (679, 4, N'Single', 188, 943.99, 0, 10, 188, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (680, 4, N'Single', 944, 3262.99, 75.6, 15, 944, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (681, 4, N'Single', 3263, 7632.99, 423.45, 25, 3263, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (682, 4, N'Single', 7633, 15716.99, 1515.95, 28, 7633, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (683, 4, N'Single', 15717, 33945.99, 3779.47, 33, 15717, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (684, 4, N'Single', 33946, 34082.99, 9795.04, 35, 33946, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (685, 1, N'Single', 7865, NULL, 2271.36, 39.6, 7865, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (686, 1, N'HeadofHousehold', 7865, NULL, 2271.36, 39.6, 7865, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (687, 1, N'Married', 8963, NULL, 2460.89, 39.6, 8963, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (688, 2, N'Single', 15731, NULL, 4543.02, 39.6, 15731, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (689, 2, N'HeadofHousehold', 15731, NULL, 4543.02, 39.6, 15731, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (690, 2, N'Married', 17925, NULL, 4921.68, 39.6, 17925, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (691, 3, N'Single', 17042, NULL, 4921.73, 39.6, 17042, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (692, 3, N'HeadofHousehold', 17042, NULL, 4921.73, 39.6, 17042, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (693, 3, N'Married', 19419, NULL, 5331.91, 39.6, 19419, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (694, 4, N'Single', 34083, NULL, 9842.99, 39.6, 34083, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (695, 4, N'HeadofHousehold', 34083, NULL, 9842.99, 39.6, 34083, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (696, 4, N'Married', 38838, NULL, 10663.75, 39.6, 38838, 2014)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (697, 1, N'HeadofHousehold', 0, 43.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (698, 1, N'HeadofHousehold', 44, 221.99, 0, 10, 44, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (699, 1, N'HeadofHousehold', 222, 763.99, 17.8, 15, 222, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (700, 1, N'HeadofHousehold', 764, 1788.99, 99.1, 25, 764, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (701, 1, N'HeadofHousehold', 1789, 3684.99, 355.35, 28, 1789, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (702, 1, N'HeadofHousehold', 3685, 7957.99, 886.23, 33, 3685, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (703, 1, N'HeadofHousehold', 7958, 7989.99, 2296.32, 35, 7958, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (704, 1, N'Married', 0, 164.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (705, 1, N'Married', 165, 519.99, 0, 10, 165, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (706, 1, N'Married', 520, 1605.99, 35.5, 15, 520, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (707, 1, N'Married', 1606, 3072.99, 198.4, 25, 1606, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (708, 1, N'Married', 3073, 4596.99, 565.15, 28, 3073, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (709, 1, N'Married', 4597, 8078.99, 991.87, 33, 4597, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (710, 1, N'Married', 8079, 9104.99, 2140.93, 35, 8079, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (711, 1, N'Single', 0, 43.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (712, 1, N'Single', 44, 221.99, 0, 10, 44, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (713, 1, N'Single', 222, 763.99, 17.8, 15, 222, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (714, 1, N'Single', 764, 1788.99, 99.1, 25, 764, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (715, 1, N'Single', 1789, 3684.99, 355.35, 28, 1789, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (716, 1, N'Single', 3685, 7957.99, 886.23, 33, 3685, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (717, 1, N'Single', 7958, 7989.99, 2296.32, 35, 7958, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (718, 2, N'HeadofHousehold', 0, 87.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (719, 2, N'HeadofHousehold', 88, 442.99, 0, 10, 88, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (720, 2, N'HeadofHousehold', 443, 1528.99, 35.5, 15, 443, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (721, 2, N'HeadofHousehold', 1529, 3578.99, 198.4, 25, 1529, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (722, 2, N'HeadofHousehold', 3579, 7368.99, 710.9, 28, 3579, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (723, 2, N'HeadofHousehold', 7369, 15914.99, 1772.1, 33, 7369, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (724, 2, N'HeadofHousehold', 15915, 15980.99, 4592.28, 35, 15915, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (725, 2, N'Married', 0, 330.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (726, 2, N'Married', 331, 1039.99, 0, 10, 331, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (727, 2, N'Married', 1040, 3211.99, 70.9, 15, 1040, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (728, 2, N'Married', 3212, 6145.99, 396.7, 25, 3212, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (729, 2, N'Married', 6146, 9193.99, 1130.2, 28, 6146, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (730, 2, N'Married', 9194, 16157.99, 1983.64, 33, 9194, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (731, 2, N'Married', 16158, 18209.99, 4281.76, 35, 16158, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (732, 2, N'Single', 0, 87.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (733, 2, N'Single', 88, 442.99, 0, 10, 88, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (734, 2, N'Single', 443, 1528.99, 35.5, 15, 443, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (735, 2, N'Single', 1529, 3578.99, 198.4, 25, 1529, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (736, 2, N'Single', 3579, 7368.99, 710.9, 28, 3579, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (737, 2, N'Single', 7369, 15914.99, 1772.1, 33, 7369, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (738, 2, N'Single', 15915, 15980.99, 4592.28, 35, 15915, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (739, 3, N'HeadofHousehold', 0, 95.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (740, 3, N'HeadofHousehold', 96, 479.99, 0, 10, 96, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (741, 3, N'HeadofHousehold', 480, 1655.99, 38.4, 15, 480, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (742, 3, N'HeadofHousehold', 1656, 3876.99, 214.8, 25, 1656, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (743, 3, N'HeadofHousehold', 3877, 7982.99, 770.05, 28, 3877, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (744, 3, N'HeadofHousehold', 7983, 17241.99, 1919.73, 33, 7983, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (745, 3, N'HeadofHousehold', 17242, 17312.99, 4975.2, 35, 17242, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (746, 3, N'Married', 0, 357.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (747, 3, N'Married', 358, 1126.99, 0, 10, 358, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (748, 3, N'Married', 1127, 3478.99, 76.9, 15, 1127, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (749, 3, N'Married', 3479, 6657.99, 429.7, 25, 3479, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (750, 3, N'Married', 6658, 9959.99, 1224.45, 28, 6658, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (751, 3, N'Married', 9960, 17503.99, 2149.01, 33, 9960, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (752, 3, N'Married', 17504, 19726.99, 4638.53, 35, 17504, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (753, 3, N'Single', 0, 95.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (754, 3, N'Single', 96, 479.99, 0, 10, 96, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (755, 3, N'Single', 480, 1655.99, 38.4, 15, 480, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (756, 3, N'Single', 1656, 3876.99, 214.8, 25, 1656, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (757, 3, N'Single', 3877, 7982.99, 770.05, 28, 3877, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (758, 3, N'Single', 7983, 17241.99, 1919.73, 33, 7983, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (759, 3, N'Single', 17242, 17312.99, 4975.2, 35, 17242, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (760, 4, N'HeadofHousehold', 0, 191.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (761, 4, N'HeadofHousehold', 192, 959.99, 0, 10, 192, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (762, 4, N'HeadofHousehold', 960, 3312.99, 76.8, 15, 960, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (763, 4, N'HeadofHousehold', 3313, 7753.99, 429.75, 25, 3313, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (764, 4, N'HeadofHousehold', 7754, 15966.99, 1540, 28, 7754, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (765, 4, N'HeadofHousehold', 15967, 34482.99, 3839.64, 33, 15967, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (766, 4, N'HeadofHousehold', 34483, 34624.99, 9949.92, 35, 34483, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (767, 4, N'Married', 0, 716.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (768, 4, N'Married', 717, 2253.99, 0, 10, 717, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (769, 4, N'Married', 2254, 6957.99, 153.7, 15, 2254, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (770, 4, N'Married', 6958, 13316.99, 859.3, 25, 6958, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (771, 4, N'Married', 13317, 19920.99, 2449.05, 28, 13317, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (772, 4, N'Married', 19921, 35007.99, 4298.17, 33, 19921, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (773, 4, N'Married', 35008, 39453.99, 9276.88, 35, 35008, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (774, 4, N'Single', 0, 191.99, 0, 0, 0, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (775, 4, N'Single', 192, 959.99, 0, 10, 192, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (776, 4, N'Single', 960, 3312.99, 76.8, 15, 960, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (777, 4, N'Single', 3313, 7753.99, 429.75, 25, 3313, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (778, 4, N'Single', 7754, 15966.99, 1540, 28, 7754, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (779, 4, N'Single', 15967, 34482.99, 3839.64, 33, 15967, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (780, 4, N'Single', 34483, 34624.99, 9949.92, 35, 34483, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (781, 1, N'Single', 7990, NULL, 2307.52, 39.6, 7990, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (782, 1, N'HeadofHousehold', 7990, NULL, 2307.52, 39.6, 7990, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (783, 1, N'Married', 9105, NULL, 2500.03, 39.6, 9105, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (784, 2, N'Single', 15981, NULL, 4615.38, 39.6, 15981, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (785, 2, N'HeadofHousehold', 15981, NULL, 4615.38, 39.6, 15981, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (786, 2, N'Married', 18210, NULL, 4999.96, 39.6, 18210, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (787, 3, N'Single', 17313, NULL, 5000.05, 39.6, 17313, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (788, 3, N'HeadofHousehold', 17313, NULL, 5000.05, 39.6, 17313, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (789, 3, N'Married', 19727, NULL, 5416.58, 39.6, 19727, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (790, 4, N'Single', 34625, NULL, 9999.62, 39.6, 34625, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (791, 4, N'HeadofHousehold', 34625, NULL, 9999.62, 39.6, 34625, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (792, 4, N'Married', 39454, NULL, 10832.98, 39.6, 39454, 2015)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (793, 1, N'HeadofHousehold', 0, 42.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (794, 1, N'HeadofHousehold', 43, 221.99, 0, 10, 43, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (795, 1, N'HeadofHousehold', 222, 766.99, 17.9, 15, 222, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (796, 1, N'HeadofHousehold', 767, 1795.99, 99.65, 25, 767, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (797, 1, N'HeadofHousehold', 1796, 3699.99, 356.9, 28, 1796, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (798, 1, N'HeadofHousehold', 3700, 7991.99, 890.02, 33, 3700, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (799, 1, N'HeadofHousehold', 7992, 8024.99, 2306.38, 35, 7992, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (800, 1, N'Married', 0, 163.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (801, 1, N'Married', 164, 520.99, 0, 10, 164, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (802, 1, N'Married', 521, 1612.99, 35.7, 15, 521, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (803, 1, N'Married', 1613, 3085.99, 199.5, 25, 1613, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (804, 1, N'Married', 3086, 4614.99, 567.75, 28, 3086, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (805, 1, N'Married', 4615, 8112.99, 995.87, 33, 4615, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (806, 1, N'Married', 8113, 9143.99, 2150.21, 35, 8113, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (807, 1, N'Single', 0, 42.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (808, 1, N'Single', 43, 221.99, 0, 10, 43, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (809, 1, N'Single', 222, 766.99, 17.9, 15, 222, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (810, 1, N'Single', 767, 1795.99, 99.65, 25, 767, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (811, 1, N'Single', 1796, 3699.99, 356.9, 28, 1796, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (812, 1, N'Single', 3700, 7991.99, 890.02, 33, 3700, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (813, 1, N'Single', 7992, 8024.99, 2306.38, 35, 7992, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (814, 2, N'HeadofHousehold', 0, 86.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (815, 2, N'HeadofHousehold', 87, 442.99, 0, 10, 87, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (816, 2, N'HeadofHousehold', 443, 1534.99, 35.6, 15, 443, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (817, 2, N'HeadofHousehold', 1535, 3591.99, 199.4, 25, 1535, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (818, 2, N'HeadofHousehold', 3592, 7399.99, 713.65, 28, 3592, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (819, 2, N'HeadofHousehold', 7400, 15984.99, 1779.89, 33, 7400, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (820, 2, N'HeadofHousehold', 15985, 16049.99, 4612.94, 35, 15985, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (821, 2, N'Married', 0, 328.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (822, 2, N'Married', 329, 1041.99, 0, 10, 329, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (823, 2, N'Married', 1042, 3224.99, 71.3, 15, 1042, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (824, 2, N'Married', 3225, 6170.99, 398.75, 25, 3225, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (825, 2, N'Married', 6171, 9230.99, 1135.25, 28, 6171, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (826, 2, N'Married', 9231, 16226.99, 1992.05, 33, 9231, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (827, 2, N'Married', 16227, 18287.99, 4300.73, 35, 16227, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (828, 2, N'Single', 0, 86.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (829, 2, N'Single', 87, 442.99, 0, 10, 87, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (830, 2, N'Single', 443, 1534.99, 35.6, 15, 443, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (831, 2, N'Single', 1535, 3591.99, 199.4, 25, 1535, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (832, 2, N'Single', 3592, 7399.99, 713.65, 28, 3592, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (833, 2, N'Single', 7400, 15984.99, 1779.89, 33, 7400, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (834, 2, N'Single', 15985, 16049.99, 4612.94, 35, 15985, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (835, 3, N'HeadofHousehold', 0, 93.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (836, 3, N'HeadofHousehold', 94, 479.99, 0, 10, 94, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (837, 3, N'HeadofHousehold', 480, 1662.99, 38.6, 15, 480, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (838, 3, N'HeadofHousehold', 1663, 3891.99, 216.05, 25, 1663, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (839, 3, N'HeadofHousehold', 3892, 8016.99, 773.3, 28, 3892, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (840, 3, N'HeadofHousehold', 8017, 17316.99, 1928.3, 33, 8017, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (841, 3, N'HeadofHousehold', 17317, 17387.99, 4997.3, 35, 17317, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (842, 3, N'Married', 0, 355.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (843, 3, N'Married', 356, 1128.99, 0, 10, 356, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (844, 3, N'Married', 1129, 3493.99, 77.3, 15, 1129, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (845, 3, N'Married', 3494, 6684.99, 432.05, 25, 3494, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (846, 3, N'Married', 6685, 9999.99, 1229.8, 28, 6685, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (847, 3, N'Married', 10000, 17578.99, 2158, 33, 10000, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (848, 3, N'Married', 17579, 19812.99, 4659.07, 35, 17579, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (849, 3, N'Single', 0, 93.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (850, 3, N'Single', 94, 479.99, 0, 10, 94, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (851, 3, N'Single', 480, 1662.99, 38.6, 15, 480, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (852, 3, N'Single', 1663, 3891.99, 216.05, 25, 1663, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (853, 3, N'Single', 3892, 8016.99, 773.3, 28, 3892, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (854, 3, N'Single', 8017, 17316.99, 1928.3, 33, 8017, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (855, 3, N'Single', 17317, 17387.99, 4997.3, 35, 17317, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (856, 4, N'HeadofHousehold', 0, 187.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (857, 4, N'HeadofHousehold', 188, 959.99, 0, 10, 188, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (858, 4, N'HeadofHousehold', 960, 3324.99, 77.2, 15, 960, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (859, 4, N'HeadofHousehold', 3325, 7782.99, 431.95, 25, 3325, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (860, 4, N'HeadofHousehold', 7783, 16032.99, 1546.45, 28, 7783, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (861, 4, N'HeadofHousehold', 16033, 34632.99, 3856.45, 33, 16033, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (862, 4, N'HeadofHousehold', 34633, 34774.99, 9994.45, 35, 34633, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (863, 4, N'Married', 0, 712.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (864, 4, N'Married', 713, 2257.99, 0, 10, 713, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (865, 4, N'Married', 2258, 6987.99, 154.5, 15, 2258, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (866, 4, N'Married', 6988, 13370.99, 864, 25, 6988, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (867, 4, N'Married', 13371, 19999.99, 2459.75, 28, 13371, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (868, 4, N'Married', 20000, 35157.99, 4315.87, 33, 20000, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (869, 4, N'Married', 35158, 39624.99, 9318.01, 35, 35158, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (870, 4, N'Single', 0, 187.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (871, 4, N'Single', 188, 959.99, 0, 10, 188, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (872, 4, N'Single', 960, 3324.99, 77.2, 15, 960, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (873, 4, N'Single', 3325, 7782.99, 431.95, 25, 3325, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (874, 4, N'Single', 7783, 16032.99, 1546.45, 28, 7783, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (875, 4, N'Single', 16033, 34632.99, 3856.45, 33, 16033, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (876, 4, N'Single', 34633, 34774.99, 9994.45, 35, 34633, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (877, 1, N'Single', 8025, NULL, 2317.93, 39.6, 8025, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (878, 1, N'HeadofHousehold', 8025, NULL, 2317.93, 39.6, 8025, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (879, 1, N'Married', 9144, NULL, 2511.06, 39.6, 9144, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (880, 2, N'Single', 16050, NULL, 4635.69, 39.6, 16050, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (881, 2, N'HeadofHousehold', 16050, NULL, 4635.69, 39.6, 16050, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (882, 2, N'Married', 18288, NULL, 5022.08, 39.6, 18288, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (883, 3, N'Single', 17388, NULL, 5022.15, 39.6, 17388, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (884, 3, N'HeadofHousehold', 17388, NULL, 5022.15, 39.6, 17388, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (885, 3, N'Married', 19813, NULL, 5440.97, 39.6, 19813, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (886, 4, N'Single', 34775, NULL, 10044.15, 39.6, 34775, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (887, 4, N'HeadofHousehold', 34775, NULL, 10044.15, 39.6, 34775, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (888, 4, N'Married', 39625, NULL, 10881.46, 39.6, 39625, 2016)
GO
SET IDENTITY_INSERT [dbo].[FITTaxTable] OFF
GO
SET IDENTITY_INSERT [dbo].[FITWithholdingAllowanceTable] ON 

GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (1, 1, 67.31, 2008)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (2, 2, 134.62, 2008)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (3, 3, 145.83, 2008)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (4, 4, 291.67, 2008)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (5, 1, 65.38, 2007)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (6, 2, 130.77, 2007)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (7, 3, 141.67, 2007)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (8, 4, 283.33, 2007)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (9, 1, 70.19, 2009)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (10, 2, 140.38, 2009)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (11, 3, 152.08, 2009)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (12, 4, 304.17, 2009)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (13, 1, 70.19, 2010)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (14, 2, 140.38, 2010)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (15, 3, 152.08, 2010)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (16, 4, 304.17, 2010)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (17, 1, 71.15, 2011)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (18, 2, 142.31, 2011)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (19, 3, 154.17, 2011)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (20, 4, 308.33, 2011)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (21, 1, 73.08, 2012)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (22, 2, 146.15, 2012)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (23, 3, 158.33, 2012)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (24, 4, 316.67, 2012)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (25, 1, 75, 2013)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (26, 2, 150, 2013)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (27, 3, 162.5, 2013)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (28, 4, 325, 2013)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (29, 1, 76, 2014)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (30, 2, 151.9, 2014)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (31, 3, 164.6, 2014)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (32, 4, 329.2, 2014)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (33, 1, 76.9, 2015)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (34, 2, 153.8, 2015)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (35, 3, 166.7, 2015)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (36, 4, 333.3, 2015)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (37, 1, 77.9, 2016)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (38, 2, 155.8, 2016)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (39, 3, 168.8, 2016)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (40, 4, 337.5, 2016)
GO
SET IDENTITY_INSERT [dbo].[FITWithholdingAllowanceTable] OFF
GO
SET IDENTITY_INSERT [dbo].[SITLowIncomeTaxTable] ON 

GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (1, 1, N'Single', 224.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (2, 2, N'Single', 447.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (3, 3, N'Single', 485.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (4, 4, N'Single', 969.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (5, 1, N'DualIncomeMarried', 224.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (6, 2, N'DualIncomeMarried', 447.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (7, 3, N'DualIncomeMarried', 485.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (8, 4, N'DualIncomeMarried', 969.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (9, 1, N'MarriedWithMultipleEmployers', 224.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (10, 2, N'MarriedWithMultipleEmployers', 447.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (11, 3, N'MarriedWithMultipleEmployers', 485.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (12, 4, N'MarriedWithMultipleEmployers', 969.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (13, 1, N'Married ', 224.0000, 447.0000, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (14, 2, N'Married ', 447.0000, 895.0000, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (15, 3, N'Married ', 485.0000, 969.0000, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (16, 4, N'Married ', 969.0000, 1938.0000, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (17, 1, N'Headofhousehold', 447.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (18, 2, N'Headofhousehold', 895.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (19, 3, N'Headofhousehold', 969.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (20, 4, N'Headofhousehold', 1938.0000, NULL, 2008)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (21, 1, N'Single', 217.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (22, 2, N'Single', 434.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (23, 3, N'Single', 470.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (24, 4, N'Single', 939.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (25, 1, N'DualIncomeMarried', 217.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (26, 2, N'DualIncomeMarried', 434.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (27, 3, N'DualIncomeMarried', 470.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (28, 4, N'DualIncomeMarried', 939.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (29, 1, N'MarriedWithMultipleEmployers', 217.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (30, 2, N'MarriedWithMultipleEmployers', 434.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (31, 3, N'MarriedWithMultipleEmployers', 470.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (32, 4, N'MarriedWithMultipleEmployers', 939.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (33, 1, N'Married ', 217.0000, 434.0000, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (34, 2, N'Married ', 434.0000, 867.0000, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (35, 3, N'Married ', 470.0000, 939.0000, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (36, 4, N'Married ', 939.0000, 1879.0000, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (37, 1, N'Headofhousehold', 434.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (38, 2, N'Headofhousehold', 867.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (39, 3, N'Headofhousehold', 939.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (40, 4, N'Headofhousehold', 1879.0000, NULL, 2007)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (41, 1, N'Single', 235.0000, 235.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (42, 2, N'Single', 470.0000, 470.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (43, 3, N'Single', 509.0000, 509.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (44, 4, N'Single', 1019.0000, 1019.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (45, 1, N'DualIncomeMarried', 235.0000, 235.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (46, 2, N'DualIncomeMarried', 470.0000, 470.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (47, 3, N'DualIncomeMarried', 509.0000, 509.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (48, 4, N'DualIncomeMarried', 1019.0000, 1019.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (49, 1, N'MarriedWithMultipleEmployers', 235.0000, 235.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (50, 2, N'MarriedWithMultipleEmployers', 470.0000, 470.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (51, 3, N'MarriedWithMultipleEmployers', 509.0000, 509.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (52, 4, N'MarriedWithMultipleEmployers', 1019.0000, 1019.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (53, 1, N'Married ', 235.0000, 470.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (54, 2, N'Married ', 470.0000, 940.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (55, 3, N'Married ', 509.0000, 1019.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (56, 4, N'Married ', 1019.0000, 2038.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (57, 1, N'Headofhousehold', 470.0000, 470.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (58, 2, N'Headofhousehold', 940.0000, 940.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (59, 3, N'Headofhousehold', 1019.0000, 1019.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (60, 4, N'Headofhousehold', 2038.0000, 2038.0000, 2009)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (61, 1, N'Single', 214.0000, 214.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (62, 2, N'Single', 428.0000, 428.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (63, 3, N'Single', 464.0000, 464.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (64, 4, N'Single', 928.0000, 928.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (65, 1, N'DualIncomeMarried', 214.0000, 214.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (66, 2, N'DualIncomeMarried', 428.0000, 428.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (67, 3, N'DualIncomeMarried', 464.0000, 464.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (68, 4, N'DualIncomeMarried', 928.0000, 928.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (69, 1, N'MarriedWithMultipleEmployers', 214.0000, 214.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (70, 2, N'MarriedWithMultipleEmployers', 428.0000, 428.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (71, 3, N'MarriedWithMultipleEmployers', 464.0000, 464.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (72, 4, N'MarriedWithMultipleEmployers', 928.0000, 928.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (73, 1, N'Married ', 214.0000, 428.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (74, 2, N'Married ', 428.0000, 856.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (75, 3, N'Married ', 464.0000, 928.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (76, 4, N'Married ', 928.0000, 1855.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (77, 1, N'Headofhousehold', 428.0000, 428.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (78, 2, N'Headofhousehold', 856.0000, 856.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (79, 3, N'Headofhousehold', 928.0000, 928.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (80, 4, N'Headofhousehold', 1855.0000, 1855.0000, 2010)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (81, 1, N'Single', 234.0000, 234.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (82, 2, N'Single', 469.0000, 469.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (83, 3, N'Single', 508.0000, 508.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (84, 4, N'Single', 1015.0000, 1015.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (85, 1, N'DualIncomeMarried', 234.0000, 234.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (86, 2, N'DualIncomeMarried', 469.0000, 469.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (87, 3, N'DualIncomeMarried', 508.0000, 508.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (88, 4, N'DualIncomeMarried', 1015.0000, 1015.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (89, 1, N'MarriedWithMultipleEmployers', 234.0000, 234.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (90, 2, N'MarriedWithMultipleEmployers', 469.0000, 469.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (91, 3, N'MarriedWithMultipleEmployers', 508.0000, 508.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (92, 4, N'MarriedWithMultipleEmployers', 1015.0000, 1015.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (93, 1, N'Married ', 234.0000, 469.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (94, 2, N'Married ', 469.0000, 937.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (95, 3, N'Married ', 508.0000, 1015.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (96, 4, N'Married ', 1015.0000, 2030.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (97, 1, N'Headofhousehold', 469.0000, 469.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (98, 2, N'Headofhousehold', 937.0000, 937.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (99, 3, N'Headofhousehold', 1015.0000, 1015.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (100, 4, N'Headofhousehold', 2030.0000, 2030.0000, 2011)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (101, 1, N'Single', 241.0000, 241.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (102, 2, N'Single', 482.0000, 482.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (103, 3, N'Single', 522.0000, 522.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (104, 4, N'Single', 1044.0000, 1044.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (105, 1, N'DualIncomeMarried', 241.0000, 241.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (106, 2, N'DualIncomeMarried', 482.0000, 482.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (107, 3, N'DualIncomeMarried', 522.0000, 522.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (108, 4, N'DualIncomeMarried', 1044.0000, 1044.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (109, 1, N'MarriedWithMultipleEmployers', 241.0000, 241.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (110, 2, N'MarriedWithMultipleEmployers', 482.0000, 482.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (111, 3, N'MarriedWithMultipleEmployers', 522.0000, 522.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (112, 4, N'MarriedWithMultipleEmployers', 1044.0000, 1044.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (113, 1, N'Married ', 241.0000, 482.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (114, 2, N'Married ', 482.0000, 964.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (115, 3, N'Married ', 522.0000, 1044.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (116, 4, N'Married ', 1044.0000, 2088.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (117, 1, N'Headofhousehold', 482.0000, 482.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (118, 2, N'Headofhousehold', 964.0000, 964.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (119, 3, N'Headofhousehold', 1044.0000, 1044.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (120, 4, N'Headofhousehold', 2088.0000, 2088.0000, 2012)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (121, 1, N'Single', 246.0000, 246.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (122, 2, N'Single', 491.0000, 491.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (123, 3, N'Single', 532.0000, 532.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (124, 4, N'Single', 1064.0000, 1064.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (125, 1, N'DualIncomeMarried', 246.0000, 246.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (126, 2, N'DualIncomeMarried', 491.0000, 491.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (127, 3, N'DualIncomeMarried', 532.0000, 532.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (128, 4, N'DualIncomeMarried', 1064.0000, 1064.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (129, 1, N'MarriedWithMultipleEmployers', 246.0000, 246.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (130, 2, N'MarriedWithMultipleEmployers', 491.0000, 491.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (131, 3, N'MarriedWithMultipleEmployers', 532.0000, 532.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (132, 4, N'MarriedWithMultipleEmployers', 1064.0000, 1064.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (133, 1, N'Married ', 246.0000, 491.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (134, 2, N'Married ', 491.0000, 982.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (135, 3, N'Married ', 532.0000, 1064.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (136, 4, N'Married ', 1064.0000, 2128.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (137, 1, N'Headofhousehold', 491.0000, 491.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (138, 2, N'Headofhousehold', 982.0000, 982.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (139, 3, N'Headofhousehold', 1064.0000, 1064.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (140, 4, N'Headofhousehold', 2128.0000, 2128.0000, 2013)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (141, 1, N'Single', 250.0000, 250.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (142, 2, N'Single', 500.0000, 500.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (143, 3, N'Single', 542.0000, 542.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (144, 4, N'Single', 1083.0000, 1083.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (145, 1, N'DualIncomeMarried', 250.0000, 250.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (146, 2, N'DualIncomeMarried', 500.0000, 500.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (147, 3, N'DualIncomeMarried', 542.0000, 542.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (148, 4, N'DualIncomeMarried', 1083.0000, 1083.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (149, 1, N'MarriedWithMultipleEmployers', 250.0000, 250.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (150, 2, N'MarriedWithMultipleEmployers', 500.0000, 500.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (151, 3, N'MarriedWithMultipleEmployers', 542.0000, 542.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (152, 4, N'MarriedWithMultipleEmployers', 1083.0000, 1083.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (153, 1, N'Married ', 250.0000, 500.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (154, 2, N'Married ', 500.0000, 1000.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (155, 3, N'Married ', 542.0000, 1083.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (156, 4, N'Married ', 1083.0000, 2166.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (157, 1, N'Headofhousehold', 500.0000, 500.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (158, 2, N'Headofhousehold', 1000.0000, 100.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (159, 3, N'Headofhousehold', 1083.0000, 1083.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (160, 4, N'Headofhousehold', 2166.0000, 2166.0000, 2014)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (161, 1, N'Single', 255.0000, 255.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (162, 2, N'Single', 510.0000, 510.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (163, 3, N'Single', 553.0000, 553.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (164, 4, N'Single', 1106.0000, 1106.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (165, 1, N'DualIncomeMarried', 255.0000, 255.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (166, 2, N'DualIncomeMarried', 510.0000, 510.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (167, 3, N'DualIncomeMarried', 553.0000, 553.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (168, 4, N'DualIncomeMarried', 1106.0000, 1106.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (169, 1, N'MarriedWithMultipleEmployers', 255.0000, 255.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (170, 2, N'MarriedWithMultipleEmployers', 510.0000, 510.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (171, 3, N'MarriedWithMultipleEmployers', 553.0000, 553.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (172, 4, N'MarriedWithMultipleEmployers', 1106.0000, 1106.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (173, 1, N'Married ', 255.0000, 510.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (174, 2, N'Married ', 510.0000, 1021.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (175, 3, N'Married ', 553.0000, 1106.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (176, 4, N'Married ', 1106.0000, 2211.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (177, 1, N'Headofhousehold', 510.0000, 510.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (178, 2, N'Headofhousehold', 1021.0000, 1021.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (179, 3, N'Headofhousehold', 1106.0000, 1106.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (180, 4, N'Headofhousehold', 2211.0000, 2211.0000, 2015)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (181, 1, N'Single', 258.0000, 258.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (182, 2, N'Single', 516.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (183, 3, N'Single', 559.0000, 559.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (184, 4, N'Single', 1118.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (185, 1, N'DualIncomeMarried', 258.0000, 258.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (186, 2, N'DualIncomeMarried', 516.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (187, 3, N'DualIncomeMarried', 559.0000, 559.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (188, 4, N'DualIncomeMarried', 1118.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (189, 1, N'MarriedWithMultipleEmployers', 258.0000, 258.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (190, 2, N'MarriedWithMultipleEmployers', 516.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (191, 3, N'MarriedWithMultipleEmployers', 559.0000, 559.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (192, 4, N'MarriedWithMultipleEmployers', 1118.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (193, 1, N'Married ', 258.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (194, 2, N'Married ', 516.0000, 1032.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (195, 3, N'Married ', 559.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (196, 4, N'Married ', 1118.0000, 2237.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (197, 1, N'Headofhousehold', 516.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (198, 2, N'Headofhousehold', 1032.0000, 1032.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (199, 3, N'Headofhousehold', 1118.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (200, 4, N'Headofhousehold', 2237.0000, 2237.0000, 2016)
GO
SET IDENTITY_INSERT [dbo].[SITLowIncomeTaxTable] OFF
GO
SET IDENTITY_INSERT [dbo].[SITTaxTable] ON 

GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (1, 1, N'Headofhousehold', 0, 262.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (2, 1, N'Headofhousehold', 263, 622.99, 2.6300, 2, 263.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (3, 1, N'Headofhousehold', 623, 801.99, 9.8300, 4, 623.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (4, 1, N'Headofhousehold', 802, 992.99, 16.9900, 6, 802.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (5, 1, N'Headofhousehold', 993, 1172.99, 28.4500, 8, 993.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (6, 1, N'Headofhousehold', 1173, 19230.99, 42.8500, 9.3, 1173.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (7, 1, N'Headofhousehold', 19231, NULL, 1722.2400, 10.3, 19231.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (8, 1, N'Married', 0, 261.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (9, 1, N'Married', 262, 621.99, 2.6200, 2, 262.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (10, 1, N'Married', 622, 981.99, 9.8200, 4, 622.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (11, 1, N'Married', 982, 1363.99, 24.2200, 6, 982.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (12, 1, N'Married', 1364, 1723.99, 47.1400, 8, 1364.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (13, 1, N'Married', 1724, 19230.99, 75.9400, 9.3, 1724.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (14, 1, N'Married', 19231, NULL, 1704.0900, 10.3, 19231.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (15, 1, N'Single', 0, 130.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (16, 1, N'Single', 131, 310.99, 1.3100, 2, 131.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (17, 1, N'Single', 311, 490.99, 4.9100, 4, 311.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (18, 1, N'Single', 491, 681.99, 12.1100, 6, 491.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (19, 1, N'Single', 682, 861.99, 23.5700, 8, 682.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (20, 1, N'Single', 862, 19230.99, 37.9700, 9.3, 862.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (21, 1, N'Single', 19231, NULL, 1746.2900, 10.3, 19231.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (22, 2, N'Headofhousehold', 0, 525.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (23, 2, N'Headofhousehold', 526, 1245.99, 5.2600, 2, 526.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (24, 2, N'Headofhousehold', 1246, 1603.99, 19.6600, 4, 1246.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (25, 2, N'Headofhousehold', 1604, 1985.99, 33.9800, 6, 1604.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (26, 2, N'Headofhousehold', 1986, 2345.99, 56.9000, 8, 1986.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (27, 2, N'Headofhousehold', 2346, 38461.99, 85.7000, 9.3, 2346.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (28, 2, N'Headofhousehold', 38462, NULL, 3444.4900, 10.3, 38462.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (29, 2, N'Married', 0, 523.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (30, 2, N'Married', 524, 1243.99, 5.2400, 2, 524.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (31, 2, N'Married', 1244, 1963.99, 19.6400, 4, 1244.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (32, 2, N'Married', 1964, 2727.99, 48.4400, 6, 1964.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (33, 2, N'Married', 2728, 3447.99, 94.2800, 8, 2728.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (34, 2, N'Married', 3448, 38461.99, 151.8800, 9.3, 3448.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (35, 2, N'Married', 38462, NULL, 3408.1800, 10.3, 38462.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (36, 2, N'Single', 0, 261.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (37, 2, N'Single', 262, 621.99, 2.6200, 2, 262.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (38, 2, N'Single', 622, 981.99, 9.8200, 4, 622.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (39, 2, N'Single', 982, 1363.99, 24.2200, 6, 982.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (40, 2, N'Single', 1364, 1723.99, 47.1400, 8, 1364.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (41, 2, N'Single', 1724, 38461.99, 75.9400, 9.3, 1724.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (42, 2, N'Single', 38462, NULL, 3492.5700, 10.3, 38462.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (43, 3, N'Headofhousehold', 0, 568.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (44, 3, N'Headofhousehold', 569, 1348.99, 5.6900, 2, 569.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (45, 3, N'Headofhousehold', 1349, 1738.99, 21.2900, 4, 1349.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (46, 3, N'Headofhousehold', 1739, 2151.99, 36.8900, 6, 1739.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (47, 3, N'Headofhousehold', 2152, 2541.99, 61.6700, 8, 2152.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (48, 3, N'Headofhousehold', 2542, 41666.99, 92.8700, 9.3, 2542.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (49, 3, N'Headofhousehold', 41667, NULL, 3731.5000, 10.3, 41667.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (50, 3, N'Married', 0, 567.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (51, 3, N'Married', 568, 1347.99, 5.6800, 2, 568.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (52, 3, N'Married', 1348, 2127.99, 21.2800, 4, 1348.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (53, 3, N'Married', 2128, 2955.99, 52.4800, 6, 2128.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (54, 3, N'Married', 2956, 3733.99, 102.1600, 8, 2956.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (55, 3, N'Married', 3734, 41666.99, 164.4000, 9.3, 3734.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (56, 3, N'Married', 41667, NULL, 3692.1700, 10.3, 41667.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (57, 3, N'Single', 0, 283.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (58, 3, N'Single', 284, 673.99, 2.8400, 2, 284.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (59, 3, N'Single', 674, 1063.99, 10.6400, 4, 674.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (60, 3, N'Single', 1064, 1477.99, 26.2400, 6, 1064.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (61, 3, N'Single', 1478, 1866.99, 51.0800, 8, 1478.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (62, 3, N'Single', 1867, 41666.99, 82.2000, 9.3, 1867.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (63, 3, N'Single', 41667, NULL, 3783.6000, 10.3, 41667.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (64, 4, N'Headofhousehold', 0, 1137.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (65, 4, N'Headofhousehold', 1138, 2697.99, 11.3800, 2, 1138.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (66, 4, N'Headofhousehold', 2698, 3477.99, 42.5800, 4, 2698.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (67, 4, N'Headofhousehold', 3478, 4303.99, 73.7800, 6, 3478.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (68, 4, N'Headofhousehold', 4304, 5083.99, 123.3400, 8, 4304.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (69, 4, N'Headofhousehold', 5084, 83333.99, 185.7400, 9.3, 5084.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (70, 4, N'Headofhousehold', 83334, NULL, 7462.9900, 10.3, 83334.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (71, 4, N'Married', 0, 1135.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (72, 4, N'Married', 1136, 2695.99, 11.3600, 2, 1136.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (73, 4, N'Married', 2696, 4255.99, 42.5600, 4, 2696.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (74, 4, N'Married', 4256, 5911.99, 104.9600, 6, 4256.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (75, 4, N'Married', 5912, 7467.99, 204.3200, 8, 5912.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (76, 4, N'Married', 7468, 83333.99, 328.8000, 9.3, 7468.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (77, 4, N'Married', 83334, NULL, 7384.3400, 10.3, 83334.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (78, 4, N'Single', 0, 567.99, 0.0000, 1, 0.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (79, 4, N'Single', 568, 1347.99, 5.6800, 2, 568.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (80, 4, N'Single', 1348, 2127.99, 21.2800, 4, 1348.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (81, 4, N'Single', 2128, 2955.99, 52.4800, 6, 2128.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (82, 4, N'Single', 2956, 3733.99, 102.1600, 8, 2956.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (83, 4, N'Single', 3734, 83333.99, 164.4000, 9.3, 3734.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (84, 4, N'Single', 83334, NULL, 7567.2000, 10.3, 83334.0000, 2008)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (85, 1, N'Headofhousehold', 0, 254.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (86, 1, N'Headofhousehold', 255, 603.99, 2.5500, 2, 255.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (87, 1, N'Headofhousehold', 604, 777.99, 9.5300, 4, 604.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (88, 1, N'Headofhousehold', 778, 962.99, 16.4900, 6, 778.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (89, 1, N'Headofhousehold', 963, 1137.99, 27.5900, 8, 963.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (90, 1, N'Headofhousehold', 1138, 19230.99, 41.5900, 9.3, 1138.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (91, 1, N'Headofhousehold', 19231, NULL, 1724.2400, 10.3, 19231.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (92, 1, N'Married', 0, 253.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (93, 1, N'Married', 254, 603.99, 2.5400, 2, 254.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (94, 1, N'Married', 604, 951.99, 9.5400, 4, 604.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (95, 1, N'Married', 952, 1321.99, 23.4600, 6, 952.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (96, 1, N'Married', 1322, 1671.99, 45.6600, 8, 1322.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (97, 1, N'Married', 1672, 19230.99, 73.6600, 9.3, 1672.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (98, 1, N'Married', 19231, NULL, 1706.6500, 10.3, 19231.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (99, 1, N'Single', 0, 126.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (100, 1, N'Single', 127, 301.99, 1.2700, 2, 127.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (101, 1, N'Single', 302, 475.99, 4.7700, 4, 302.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (102, 1, N'Single', 476, 660.99, 11.7300, 6, 476.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (103, 1, N'Single', 661, 835.99, 22.8300, 8, 661.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (104, 1, N'Single', 836, 19230.99, 36.8300, 9.3, 836.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (105, 1, N'Single', 19231, NULL, 1747.5700, 10.3, 19231.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (106, 2, N'Headofhousehold', 0, 509.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (107, 2, N'Headofhousehold', 510, 1207.99, 5.1000, 2, 510.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (108, 2, N'Headofhousehold', 1208, 1555.99, 19.0600, 4, 1208.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (109, 2, N'Headofhousehold', 1556, 1925.99, 32.9800, 6, 1556.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (110, 2, N'Headofhousehold', 1926, 2275.99, 55.1800, 8, 1926.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (111, 2, N'Headofhousehold', 2276, 38461.99, 83.1800, 9.3, 2276.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (112, 2, N'Headofhousehold', 38462, NULL, 3448.4800, 10.3, 38462.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (113, 2, N'Married', 0, 507.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (114, 2, N'Married', 508, 1207.99, 5.0800, 2, 508.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (115, 2, N'Married', 1208, 1903.99, 19.0800, 4, 1208.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (116, 2, N'Married', 1904, 2643.99, 46.9200, 6, 1904.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (117, 2, N'Married', 2644, 3343.99, 91.3200, 8, 2644.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (118, 2, N'Married', 3344, 38461.99, 147.3200, 9.3, 3344.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (119, 2, N'Married', 38462, NULL, 3413.2900, 10.3, 38462.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (120, 2, N'Single', 0, 253.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (121, 2, N'Single', 254, 603.99, 2.5400, 2, 254.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (122, 2, N'Single', 604, 951.99, 9.5400, 4, 604.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (123, 2, N'Single', 952, 1321.99, 23.4600, 6, 952.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (124, 2, N'Single', 1322, 1671.99, 45.6600, 8, 1322.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (125, 2, N'Single', 1672, 38461.99, 73.6600, 9.3, 1672.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (126, 2, N'Single', 38462, NULL, 3495.1300, 10.3, 38462.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (127, 3, N'Headofhousehold', 0, 551.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (128, 3, N'Headofhousehold', 552, 1307.99, 5.5200, 2, 552.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (129, 3, N'Headofhousehold', 1308, 1685.99, 20.6400, 4, 1308.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (130, 3, N'Headofhousehold', 1686, 2086.99, 35.7600, 6, 1686.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (131, 3, N'Headofhousehold', 2087, 2464.99, 59.8200, 8, 2087.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (132, 3, N'Headofhousehold', 2465, 41666.99, 90.0600, 9.3, 2465.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (133, 3, N'Headofhousehold', 41667, NULL, 3735.8500, 10.3, 41667.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (134, 3, N'Married', 0, 551.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (135, 3, N'Married', 552, 1307.99, 5.5200, 2, 552.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (136, 3, N'Married', 1308, 2063.99, 20.6400, 4, 1308.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (137, 3, N'Married', 2064, 2865.99, 50.8800, 6, 2064.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (138, 3, N'Married', 2866, 3621.99, 99.0000, 8, 2866.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (139, 3, N'Married', 3622, 41666.99, 159.4800, 9.3, 3622.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (140, 3, N'Married', 41667, NULL, 3697.6700, 10.3, 41667.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (141, 3, N'Single', 0, 275.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (142, 3, N'Single', 276, 653.99, 2.7600, 2, 276.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (143, 3, N'Single', 654, 1031.99, 10.3200, 4, 654.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (144, 3, N'Single', 1032, 1432.99, 25.4400, 6, 1032.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (145, 3, N'Single', 1433, 1810.99, 49.5000, 8, 1433.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (146, 3, N'Single', 1811, 41666.99, 79.7400, 9.3, 1811.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (147, 3, N'Single', 41667, NULL, 3786.3500, 10.3, 41667.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (148, 4, N'Headofhousehold', 0, 1103.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (149, 4, N'Headofhousehold', 1104, 2615.99, 11.0400, 2, 1104.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (150, 4, N'Headofhousehold', 2616, 3371.99, 41.2800, 4, 2616.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (151, 4, N'Headofhousehold', 3372, 4173.99, 71.5200, 6, 3372.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (152, 4, N'Headofhousehold', 4174, 4929.99, 119.6400, 8, 4174.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (153, 4, N'Headofhousehold', 4930, 83333.99, 180.1200, 9.3, 4930.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (154, 4, N'Headofhousehold', 83334, NULL, 7471.6900, 10.3, 83334.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (155, 4, N'Married', 0, 1103.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (156, 4, N'Married', 1104, 2615.99, 11.0400, 2, 1104.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (157, 4, N'Married', 2616, 4127.99, 41.2800, 4, 2616.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (158, 4, N'Married', 4128, 5731.99, 101.7600, 6, 4128.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (159, 4, N'Married', 5732, 7243.99, 198.0000, 8, 5732.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (160, 4, N'Married', 7244, 83333.99, 318.9600, 9.3, 7244.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (161, 4, N'Married', 83334, NULL, 7395.3300, 10.3, 83334.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (162, 4, N'Single', 0, 551.99, 0.0000, 1, 0.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (163, 4, N'Single', 552, 1307.99, 5.5200, 2, 552.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (164, 4, N'Single', 1308, 2063.99, 20.6400, 4, 1308.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (165, 4, N'Single', 2064, 2865.99, 50.8800, 6, 2064.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (166, 4, N'Single', 2866, 3621.99, 99.0000, 8, 2866.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (167, 4, N'Single', 3622, 83333.99, 159.4800, 9.3, 3622.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (168, 4, N'Single', 83334, NULL, 7572.7000, 10.3, 83334.0000, 2007)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (169, 1, N'Headofhousehold', 0, 275.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (170, 1, N'Headofhousehold', 276, 653.99, 2.7600, 2, 276.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (171, 1, N'Headofhousehold', 654, 842.99, 10.3200, 4, 654.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (172, 1, N'Headofhousehold', 843, 1042.99, 17.8800, 6, 843.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (173, 1, N'Headofhousehold', 1043, 1231.99, 29.8800, 8, 1043.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (174, 1, N'Headofhousehold', 1232, 19230.99, 45.0000, 9.3, 1232.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (175, 1, N'Headofhousehold', 19231, NULL, 1718.9100, 10.3, 19231.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (176, 1, N'Married', 0, 275.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (177, 1, N'Married', 276, 653.99, 2.7600, 2, 276.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (178, 1, N'Married', 654, 1031.99, 10.3200, 4, 654.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (179, 1, N'Married', 1032, 1431.99, 25.4400, 6, 1032.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (180, 1, N'Married', 1432, 1809.99, 49.4400, 8, 1432.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (181, 1, N'Married', 1810, 19230.99, 79.6800, 9.3, 1810.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (182, 1, N'Married', 19231, NULL, 1699.8300, 10.3, 19231.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (183, 1, N'Single', 0, 137.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (184, 1, N'Single', 138, 326.99, 1.3800, 2, 138.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (185, 1, N'Single', 327, 515.99, 5.1600, 4, 327.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (186, 1, N'Single', 516, 715.99, 12.7200, 6, 516.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (187, 1, N'Single', 716, 904.99, 24.7200, 8, 716.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (188, 1, N'Single', 905, 19230.99, 39.8400, 9.3, 905.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (189, 1, N'Single', 19231, NULL, 1744.1600, 10.3, 19231.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (190, 2, N'Headofhousehold', 0, 551.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (191, 2, N'Headofhousehold', 552, 1307.99, 5.5200, 2, 552.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (192, 2, N'Headofhousehold', 1308, 1685.99, 20.6400, 4, 1308.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (193, 2, N'Headofhousehold', 1686, 2085.99, 35.7600, 6, 1686.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (194, 2, N'Headofhousehold', 2086, 2463.99, 59.7600, 8, 2086.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (195, 2, N'Headofhousehold', 2464, 38461.99, 90.0000, 9.3, 2464.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (196, 2, N'Headofhousehold', 38462, NULL, 3437.8100, 10.3, 38462.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (197, 2, N'Married', 0, 551.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (198, 2, N'Married', 552, 1307.99, 5.5200, 2, 552.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (199, 2, N'Married', 1308, 2063.99, 20.6400, 4, 1308.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (200, 2, N'Married', 2064, 2863.99, 50.8800, 6, 2064.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (201, 2, N'Married', 2864, 3619.99, 98.8800, 8, 2864.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (202, 2, N'Married', 3620, 38461.99, 159.3600, 9.3, 3620.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (203, 2, N'Married', 38462, NULL, 3399.6700, 10.3, 38462.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (204, 2, N'Single', 0, 275.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (205, 2, N'Single', 276, 653.99, 2.7600, 2, 276.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (206, 2, N'Single', 654, 1031.99, 10.3200, 4, 654.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (207, 2, N'Single', 1032, 1431.99, 25.4400, 6, 1032.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (208, 2, N'Single', 1432, 1809.99, 49.4400, 8, 1432.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (209, 2, N'Single', 1810, 38461.99, 79.6800, 9.3, 1810.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (210, 2, N'Single', 38462, NULL, 3488.3200, 10.3, 38462.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (211, 3, N'Headofhousehold', 0, 597.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (212, 3, N'Headofhousehold', 598, 1415.99, 5.9800, 2, 598.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (213, 3, N'Headofhousehold', 1416, 1825.99, 22.3400, 4, 1416.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (214, 3, N'Headofhousehold', 1826, 2258.99, 38.7400, 6, 1826.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (215, 3, N'Headofhousehold', 2259, 2668.99, 64.7200, 8, 2259.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (216, 3, N'Headofhousehold', 2669, 41666.99, 97.5200, 9.3, 2669.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (217, 3, N'Headofhousehold', 41667, NULL, 3724.3300, 10.3, 41667.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (218, 3, N'Married', 0, 597.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (219, 3, N'Married', 598, 1415.99, 5.9800, 2, 598.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (220, 3, N'Married', 1416, 2235.99, 22.3400, 4, 1416.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (221, 3, N'Married', 2236, 3101.99, 55.1400, 6, 2236.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (222, 3, N'Married', 3102, 3921.99, 107.1000, 8, 3102.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (223, 3, N'Married', 3922, 41666.99, 172.7000, 9.3, 3922.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (224, 3, N'Married', 41667, NULL, 3682.9900, 10.3, 41667.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (225, 3, N'Single', 0, 298.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (226, 3, N'Single', 299, 707.99, 2.9900, 2, 299.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (227, 3, N'Single', 708, 1117.99, 11.1700, 4, 708.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (228, 3, N'Single', 1118, 1550.99, 27.5700, 6, 1118.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (229, 3, N'Single', 1551, 1960.99, 53.5500, 8, 1551.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (230, 3, N'Single', 1961, 41666.99, 86.3500, 9.3, 1961.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (231, 3, N'Single', 41667, NULL, 3779.0100, 10.3, 41667.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (232, 4, N'Headofhousehold', 0, 1195.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (233, 4, N'Headofhousehold', 1196, 2831.99, 11.9600, 2, 1196.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (234, 4, N'Headofhousehold', 2832, 3651.99, 44.6800, 4, 2832.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (235, 4, N'Headofhousehold', 3652, 4517.99, 77.4800, 6, 3652.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (236, 4, N'Headofhousehold', 4518, 5337.99, 129.4400, 8, 4518.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (237, 4, N'Headofhousehold', 5338, 83333.99, 195.0400, 9.3, 5338.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (238, 4, N'Headofhousehold', 83334, NULL, 7448.6700, 10.3, 83334.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (239, 4, N'Married', 0, 1195.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (240, 4, N'Married', 1196, 2831.99, 11.9600, 2, 1196.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (241, 4, N'Married', 2832, 4471.99, 44.6800, 4, 2832.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (242, 4, N'Married', 4472, 6203.99, 110.2800, 6, 4472.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (243, 4, N'Married', 6204, 7843.99, 214.2000, 8, 6204.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (244, 4, N'Married', 7844, 83333.99, 345.4000, 9.3, 7844.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (245, 4, N'Married', 83334, NULL, 7365.9700, 10.3, 83334.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (246, 4, N'Single', 0, 597.99, 0.0000, 1, 0.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (247, 4, N'Single', 598, 1415.99, 5.9800, 2, 598.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (248, 4, N'Single', 1416, 2235.99, 22.3400, 4, 1416.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (249, 4, N'Single', 2236, 3101.99, 55.1400, 6, 2236.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (250, 4, N'Single', 3102, 3921.99, 107.1000, 8, 3102.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (251, 4, N'Single', 3922, 83333.99, 172.7000, 9.3, 3922.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (252, 4, N'Single', 83334, NULL, 7558.0200, 10.3, 83334.0000, 2009)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (253, 1, N'Headofhousehold', 0, 271.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (254, 1, N'Headofhousehold', 272, 643.99, 3.7400, 2.475, 272.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (255, 1, N'Headofhousehold', 644, 829.99, 12.9500, 4.675, 644.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (256, 1, N'Headofhousehold', 830, 1026.99, 21.6500, 6.875, 830.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (257, 1, N'Headofhousehold', 1027, 1212.99, 35.1900, 9.075, 1027.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (258, 1, N'Headofhousehold', 1213, 19230.99, 52.0700, 10.505, 1213.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (259, 1, N'Headofhousehold', 19231, NULL, 1944.8600, 11.605, 19231.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (260, 1, N'Married', 0, 271.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (261, 1, N'Married', 272, 643.99, 3.7400, 2.475, 272.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (262, 1, N'Married', 644, 1015.99, 12.9500, 4.675, 644.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (263, 1, N'Married', 1016, 1409.99, 30.3400, 6.875, 1016.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (264, 1, N'Married', 1410, 1781.99, 57.4300, 9.075, 1410.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (265, 1, N'Married', 1782, 19230.99, 91.1900, 10.505, 1782.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (266, 1, N'Married', 19231, NULL, 1924.2100, 11.605, 19231.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (267, 1, N'Single', 0, 135.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (268, 1, N'Single', 136, 321.99, 1.8700, 2.475, 136.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (269, 1, N'Single', 322, 507.99, 6.4700, 4.675, 322.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (270, 1, N'Single', 508, 704.99, 15.1700, 6.875, 508.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (271, 1, N'Single', 705, 890.99, 28.7100, 9.075, 705.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (272, 1, N'Single', 891, 19230.99, 45.5900, 10.505, 891.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (273, 1, N'Single', 19231, NULL, 1972.2100, 11.605, 19231.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (274, 2, N'Headofhousehold', 0, 543.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (275, 2, N'Headofhousehold', 544, 1287.99, 7.4800, 2.475, 544.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (276, 2, N'Headofhousehold', 1288, 1659.99, 25.8900, 4.675, 1288.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (277, 2, N'Headofhousehold', 1660, 2053.99, 43.2800, 6.875, 1660.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (278, 2, N'Headofhousehold', 2054, 2425.99, 70.3700, 9.075, 2054.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (279, 2, N'Headofhousehold', 2426, 38461.99, 104.1300, 10.505, 2426.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (280, 2, N'Headofhousehold', 38462, NULL, 3889.7100, 11.605, 38462.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (281, 2, N'Married', 0, 543.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (282, 2, N'Married', 544, 1287.99, 7.4800, 2.475, 544.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (283, 2, N'Married', 1288, 2031.99, 25.8900, 4.675, 1288.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (284, 2, N'Married', 2032, 2819.99, 60.6700, 6.875, 2032.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (285, 2, N'Married', 2820, 3563.99, 114.8500, 9.075, 2820.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (286, 2, N'Married', 3564, 38461.99, 182.3700, 10.505, 3564.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (287, 2, N'Married', 38462, NULL, 3848.4000, 11.605, 38462.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (288, 2, N'Single', 0, 271.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (289, 2, N'Single', 272, 643.99, 3.7400, 2.475, 272.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (290, 2, N'Single', 644, 1015.99, 12.9500, 4.675, 644.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (291, 2, N'Single', 1016, 1409.99, 30.3400, 6.875, 1016.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (292, 2, N'Single', 1410, 1781.99, 57.4300, 9.075, 1410.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (293, 2, N'Single', 1782, 38461.99, 91.1900, 10.505, 1782.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (294, 2, N'Single', 38462, NULL, 3944.4200, 11.605, 38462.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (295, 3, N'Headofhousehold', 0, 588.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (296, 3, N'Headofhousehold', 589, 1394.99, 8.1000, 2.475, 589.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (297, 3, N'Headofhousehold', 1395, 1797.99, 28.0500, 4.675, 1395.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (298, 3, N'Headofhousehold', 1798, 2265.99, 46.8900, 6.875, 1798.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (299, 3, N'Headofhousehold', 2266, 2628.99, 76.3200, 9.075, 2266.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (300, 3, N'Headofhousehold', 2629, 41666.99, 112.8900, 10.505, 2629.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (301, 3, N'Headofhousehold', 41667, NULL, 4213.8300, 11.605, 41667.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (302, 3, N'Married', 0, 587.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (303, 3, N'Married', 588, 1393.99, 8.0900, 2.475, 588.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (304, 3, N'Married', 1394, 2201.99, 28.0400, 4.675, 1394.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (305, 3, N'Married', 2202, 3055.99, 65.8100, 6.875, 2202.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (306, 3, N'Married', 3056, 3861.99, 124.5200, 9.075, 3056.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (307, 3, N'Married', 3862, 41666.99, 197.6600, 10.505, 3862.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (308, 3, N'Married', 41667, NULL, 4169.0800, 11.605, 41667.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (309, 3, N'Single', 0, 293.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (310, 3, N'Single', 294, 696.99, 4.0400, 2.475, 294.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (311, 3, N'Single', 697, 1100.99, 14.0100, 4.675, 697.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (312, 3, N'Single', 1101, 1527.99, 32.9000, 6.875, 1101.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (313, 3, N'Single', 1528, 1930.99, 62.2600, 9.075, 1528.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (314, 3, N'Single', 1931, 41666.99, 98.8300, 10.505, 1931.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (315, 3, N'Single', 41667, NULL, 4273.1000, 11.605, 41667.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (316, 4, N'Headofhousehold', 0, 1177.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (317, 4, N'Headofhousehold', 1178, 2789.99, 16.2000, 2.475, 1178.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (318, 4, N'Headofhousehold', 2790, 3595.99, 56.1000, 4.675, 2790.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (319, 4, N'Headofhousehold', 3596, 4451.99, 93.7800, 6.875, 3596.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (320, 4, N'Headofhousehold', 4452, 5257.99, 152.6300, 9.075, 4452.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (321, 4, N'Headofhousehold', 5258, 83333.99, 225.7700, 10.505, 5258.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (322, 4, N'Headofhousehold', 83334, NULL, 8427.6500, 11.605, 83334.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (323, 4, N'Married', 0, 1175.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (324, 4, N'Married', 1176, 2787.99, 16.1700, 2.475, 1176.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (325, 4, N'Married', 2788, 4403.99, 56.0700, 4.675, 2788.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (326, 4, N'Married', 4404, 6111.99, 131.6200, 6.875, 4404.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (327, 4, N'Married', 6112, 7723.99, 249.0500, 9.075, 6112.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (328, 4, N'Married', 7724, 83333.99, 395.3400, 10.505, 7724.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (329, 4, N'Married', 83334, NULL, 8338.1700, 11.605, 83334.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (330, 4, N'Single', 0, 587.99, 0.0000, 1.375, 0.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (331, 4, N'Single', 588, 1393.99, 8.0900, 2.475, 588.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (332, 4, N'Single', 1394, 2201.99, 28.0400, 4.675, 1394.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (333, 4, N'Single', 2202, 3055.99, 65.8100, 6.875, 2202.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (334, 4, N'Single', 3056, 3861.99, 124.5200, 9.075, 3056.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (335, 4, N'Single', 3862, 83333.99, 197.6600, 10.505, 3862.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (336, 4, N'Single', 83334, NULL, 8546.1900, 11.605, 83334.0000, 2010)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (337, 1, N'Headofhousehold', 0, 273.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (338, 1, N'Headofhousehold', 274, 649.99, 3.0100, 2.2, 274.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (339, 1, N'Headofhousehold', 650, 836.99, 11.2800, 4.4, 650.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (340, 1, N'Headofhousehold', 837, 1035.99, 19.5100, 6.6, 837.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (341, 1, N'Headofhousehold', 1036, 1223.99, 32.6400, 8.8, 1036.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (342, 1, N'Headofhousehold', 1224, 19230.99, 49.1800, 10.23, 1224.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (343, 1, N'Headofhousehold', 19231, NULL, 1891.3000, 11.33, 19231.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (344, 1, N'Married', 0, 273.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (345, 1, N'Married', 274, 649.99, 3.0100, 2.2, 274.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (346, 1, N'Married', 650, 1025.99, 11.2800, 4.4, 650.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (347, 1, N'Married', 1026, 1423.99, 27.8200, 6.6, 1026.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (348, 1, N'Married', 1424, 1797.99, 54.0900, 8.8, 1424.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (349, 1, N'Married', 1798, 19230.99, 87.0000, 10.23, 1798.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (350, 1, N'Married', 19231, NULL, 1870.4000, 11.33, 19231.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (351, 1, N'Single', 0, 136.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (352, 1, N'Single', 137, 324.99, 1.5100, 2.2, 137.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (353, 1, N'Single', 325, 512.99, 5.6500, 4.4, 325.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (354, 1, N'Single', 513, 711.99, 13.9200, 6.6, 513.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (355, 1, N'Single', 712, 898.99, 27.0500, 8.8, 712.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (356, 1, N'Single', 899, 19230.99, 43.5100, 10.23, 899.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (357, 1, N'Single', 19231, NULL, 1918.8700, 11.33, 19231.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (358, 2, N'Headofhousehold', 0, 547.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (359, 2, N'Headofhousehold', 548, 1299.99, 6.0300, 2.2, 548.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (360, 2, N'Headofhousehold', 1300, 1673.99, 22.5700, 4.4, 1300.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (361, 2, N'Headofhousehold', 1674, 2071.99, 39.0300, 6.6, 1674.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (362, 2, N'Headofhousehold', 2072, 2447.99, 65.3000, 8.8, 2072.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (363, 2, N'Headofhousehold', 2448, 38461.99, 98.3900, 10.23, 2448.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (364, 2, N'Headofhousehold', 38462, NULL, 3782.6200, 11.33, 38462.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (365, 2, N'Married', 0, 547.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (366, 2, N'Married', 548, 1299.99, 6.0300, 2.2, 548.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (367, 2, N'Married', 1300, 2051.99, 22.5700, 4.4, 1300.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (368, 2, N'Married', 2052, 2847.99, 55.6600, 6.6, 2052.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (369, 2, N'Married', 2848, 3595.99, 108.2000, 8.8, 2848.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (370, 2, N'Married', 3596, 38461.99, 174.0200, 10.23, 3596.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (371, 2, N'Married', 38462, NULL, 3740.8100, 11.33, 38462.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (372, 2, N'Single', 0, 273.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (373, 2, N'Single', 274, 649.99, 3.0100, 2.2, 274.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (374, 2, N'Single', 650, 1025.99, 11.2800, 4.4, 650.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (375, 2, N'Single', 1026, 1423.99, 27.8200, 6.6, 1026.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (376, 2, N'Single', 1424, 1797.99, 54.0900, 8.8, 1424.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (377, 2, N'Single', 1798, 38461.99, 87.0000, 10.23, 1798.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (378, 2, N'Single', 38462, NULL, 3837.7300, 11.33, 38462.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (379, 3, N'Headofhousehold', 0, 593.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (380, 3, N'Headofhousehold', 594, 1407.99, 6.5300, 2.2, 594.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (381, 3, N'Headofhousehold', 1408, 1813.99, 24.4400, 4.4, 1408.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (382, 3, N'Headofhousehold', 1814, 2245.99, 42.3000, 6.6, 1814.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (383, 3, N'Headofhousehold', 2246, 2651.99, 70.8100, 8.8, 2246.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (384, 3, N'Headofhousehold', 2652, 41666.99, 106.5400, 10.23, 2652.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (385, 3, N'Headofhousehold', 41667, NULL, 4097.7700, 11.33, 41667.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (386, 3, N'Married', 0, 593.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (387, 3, N'Married', 594, 1407.99, 6.5300, 2.2, 594.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (388, 3, N'Married', 1408, 2221.99, 24.4400, 4.4, 1408.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (389, 3, N'Married', 2222, 3083.99, 60.2600, 6.6, 2222.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (390, 3, N'Married', 3084, 3897.99, 117.1500, 8.8, 3084.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (391, 3, N'Married', 3898, 41666.99, 188.7800, 10.23, 3898.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (392, 3, N'Married', 41667, NULL, 4052.5500, 11.33, 41667.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (393, 3, N'Single', 0, 296.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (394, 3, N'Single', 297, 703.99, 3.2700, 2.2, 297.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (395, 3, N'Single', 704, 1110.99, 12.2200, 4.4, 704.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (396, 3, N'Single', 1111, 1541.99, 30.1300, 6.6, 1111.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (397, 3, N'Single', 1542, 1948.99, 58.5800, 8.8, 1542.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (398, 3, N'Single', 1949, 41666.99, 94.4000, 10.23, 1949.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (399, 3, N'Single', 41667, NULL, 4157.5500, 11.33, 41667.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (400, 4, N'Headofhousehold', 0, 1187.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (401, 4, N'Headofhousehold', 1188, 2815.99, 13.0700, 2.2, 1188.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (402, 4, N'Headofhousehold', 2816, 3627.99, 48.8900, 4.4, 2816.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (403, 4, N'Headofhousehold', 3628, 4491.99, 84.6200, 6.6, 3628.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (404, 4, N'Headofhousehold', 4492, 5303.99, 141.6400, 8.8, 4492.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (405, 4, N'Headofhousehold', 5304, 83333.99, 213.1000, 10.23, 5304.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (406, 4, N'Headofhousehold', 83334, NULL, 8195.5700, 11.33, 83334.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (407, 4, N'Married', 0, 1187.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (408, 4, N'Married', 1188, 2815.99, 13.0700, 2.2, 1188.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (409, 4, N'Married', 2816, 4443.99, 48.8900, 4.4, 2816.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (410, 4, N'Married', 4444, 6167.99, 120.5200, 6.6, 4444.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (411, 4, N'Married', 6168, 7795.99, 234.3000, 8.8, 6168.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (412, 4, N'Married', 7796, 83333.99, 377.5600, 10.23, 7796.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (413, 4, N'Married', 83334, NULL, 8105.1000, 11.33, 83334.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (414, 4, N'Single', 0, 593.99, 0.0000, 1.1, 0.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (415, 4, N'Single', 594, 1407.99, 6.5300, 2.2, 594.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (416, 4, N'Single', 1408, 2221.99, 24.4400, 4.4, 1408.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (417, 4, N'Single', 2222, 3083.99, 60.2600, 6.6, 2222.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (418, 4, N'Single', 3084, 3897.99, 117.1500, 8.8, 3084.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (419, 4, N'Single', 3898, 83333.99, 188.7800, 10.23, 3898.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (420, 4, N'Single', 83334, NULL, 8315.0800, 11.33, 83334.0000, 2011)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (421, 1, N'Headofhousehold', 0, 281.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (422, 1, N'Headofhousehold', 282, 666.99, 3.1000, 2.2, 282.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (423, 1, N'Headofhousehold', 667, 859.99, 11.5700, 4.4, 667.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (424, 1, N'Headofhousehold', 860, 1063.99, 20.0600, 6.6, 860.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (425, 1, N'Headofhousehold', 1064, 1256.99, 33.5200, 8.8, 1064.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (426, 1, N'Headofhousehold', 1257, 19230.99, 50.5000, 10.23, 1257.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (427, 1, N'Headofhousehold', 19231, NULL, 1889.2400, 11.33, 19231.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (428, 1, N'Married', 0, 281.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (429, 1, N'Married', 282, 667.99, 3.1000, 2.2, 282.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (430, 1, N'Married', 668, 1051.99, 11.5900, 4.4, 668.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (431, 1, N'Married', 1052, 1461.99, 28.4900, 6.6, 1052.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (432, 1, N'Married', 1462, 1847.99, 55.5500, 8.8, 1462.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (433, 1, N'Married', 1848, 19230.99, 89.5200, 10.23, 1848.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (434, 1, N'Married', 19231, NULL, 1867.8000, 11.33, 19231.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (435, 1, N'Single', 0, 140.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (436, 1, N'Single', 141, 333.99, 1.5500, 2.2, 141.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (437, 1, N'Single', 334, 525.99, 5.8000, 4.4, 334.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (438, 1, N'Single', 526, 730.99, 14.2500, 6.6, 526.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (439, 1, N'Single', 731, 923.99, 27.7800, 8.8, 731.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (440, 1, N'Single', 924, 19230.99, 44.7600, 10.23, 924.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (441, 1, N'Single', 19231, NULL, 1917.5700, 11.33, 19231.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (442, 2, N'Headofhousehold', 0, 563.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (443, 2, N'Headofhousehold', 564, 1333.99, 6.2000, 2.2, 564.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (444, 2, N'Headofhousehold', 1334, 1719.99, 23.1400, 4.4, 1334.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (445, 2, N'Headofhousehold', 1720, 2127.99, 40.1200, 6.6, 1720.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (446, 2, N'Headofhousehold', 2128, 2513.99, 67.0500, 8.8, 2128.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (447, 2, N'Headofhousehold', 2514, 38461.99, 101.0200, 10.23, 2514.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (448, 2, N'Headofhousehold', 38462, NULL, 3778.5000, 11.33, 38462.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (449, 2, N'Married', 0, 563.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (450, 2, N'Married', 564, 1335.99, 6.2000, 2.2, 564.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (451, 2, N'Married', 1336, 2103.99, 23.1800, 4.4, 1336.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (452, 2, N'Married', 2104, 2923.99, 56.9700, 6.6, 2104.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (453, 2, N'Married', 2924, 3695.99, 111.0900, 8.8, 2924.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (454, 2, N'Married', 3696, 38461.99, 179.0300, 10.23, 3696.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (455, 2, N'Married', 38462, NULL, 3735.5900, 11.33, 38462.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (456, 2, N'Single', 0, 281.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (457, 2, N'Single', 282, 667.99, 3.1000, 2.2, 282.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (458, 2, N'Single', 668, 1051.99, 11.5900, 4.4, 668.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (459, 2, N'Single', 1052, 1461.99, 28.4900, 6.6, 1052.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (460, 2, N'Single', 1462, 1847.99, 55.5500, 8.8, 1462.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (461, 2, N'Single', 1848, 38461.99, 89.5200, 10.23, 1848.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (462, 2, N'Single', 38462, NULL, 3835.1300, 11.33, 38462.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (463, 3, N'Headofhousehold', 0, 609.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (464, 3, N'Headofhousehold', 610, 1445.99, 6.7100, 2.2, 610.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (465, 3, N'Headofhousehold', 1446, 1862.99, 25.1000, 4.4, 1446.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (466, 3, N'Headofhousehold', 1863, 2305.99, 43.4500, 6.6, 1863.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (467, 3, N'Headofhousehold', 2306, 2723.99, 72.6900, 8.8, 2306.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (468, 3, N'Headofhousehold', 2724, 41666.99, 109.4700, 10.23, 2724.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (469, 3, N'Headofhousehold', 41667, NULL, 4093.3400, 11.33, 41667.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (470, 3, N'Married', 0, 609.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (471, 3, N'Married', 610, 1445.99, 6.7100, 2.2, 610.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (472, 3, N'Married', 1446, 2281.99, 25.1000, 4.4, 1446.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (473, 3, N'Married', 2282, 3167.99, 61.8800, 6.6, 2282.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (474, 3, N'Married', 3168, 4001.99, 120.3600, 8.8, 3168.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (475, 3, N'Married', 4002, 41666.99, 193.7500, 10.23, 4002.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (476, 3, N'Married', 41667, NULL, 4046.8800, 11.33, 41667.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (477, 3, N'Single', 0, 304.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (478, 3, N'Single', 305, 722.99, 3.3600, 2.2, 305.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (479, 3, N'Single', 723, 1140.99, 12.5600, 4.4, 723.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (480, 3, N'Single', 1141, 1583.99, 30.9500, 6.6, 1141.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (481, 3, N'Single', 1584, 2000.99, 60.1900, 8.8, 1584.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (482, 3, N'Single', 2001, 41666.99, 96.8900, 10.23, 2001.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (483, 3, N'Single', 41667, NULL, 4154.7200, 11.33, 41667.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (484, 4, N'Headofhousehold', 0, 1219.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (485, 4, N'Headofhousehold', 1220, 2891.99, 13.4200, 2.2, 1220.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (486, 4, N'Headofhousehold', 2892, 3725.99, 50.2000, 4.4, 2892.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (487, 4, N'Headofhousehold', 3726, 4611.99, 86.9000, 6.6, 3726.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (488, 4, N'Headofhousehold', 4612, 5447.99, 145.3800, 8.8, 4612.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (489, 4, N'Headofhousehold', 5448, 83333.99, 218.9500, 10.23, 5448.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (490, 4, N'Headofhousehold', 83334, NULL, 8186.6900, 11.33, 83334.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (491, 4, N'Married', 0, 1219.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (492, 4, N'Married', 1220, 2891.99, 13.4200, 2.2, 1220.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (493, 4, N'Married', 2892, 4563.99, 50.2000, 4.4, 2892.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (494, 4, N'Married', 4564, 6335.99, 123.7700, 6.6, 4564.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (495, 4, N'Married', 6336, 8003.99, 240.7200, 8.8, 6336.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (496, 4, N'Married', 8004, 83333.99, 387.5000, 10.23, 8004.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (497, 4, N'Married', 83334, NULL, 8093.7600, 11.33, 83334.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (498, 4, N'Single', 0, 609.99, 0.0000, 1.1, 0.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (499, 4, N'Single', 610, 1445.99, 6.7100, 2.2, 610.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (500, 4, N'Single', 1446, 2281.99, 25.1000, 4.4, 1446.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (501, 4, N'Single', 2282, 3167.99, 61.8800, 6.6, 2282.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (502, 4, N'Single', 3168, 4001.99, 120.3600, 8.8, 3168.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (503, 4, N'Single', 4002, 83333.99, 193.7500, 10.23, 4002.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (504, 4, N'Single', 83334, NULL, 8309.4100, 11.33, 83334.0000, 2012)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (505, 1, N'Headofhousehold', 0, 286.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (506, 1, N'Headofhousehold', 287, 679.99, 3.1600, 2.2, 287.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (507, 1, N'Headofhousehold', 680, 875.99, 11.8100, 4.4, 680.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (508, 1, N'Headofhousehold', 876, 1084.99, 20.4300, 6.6, 876.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (509, 1, N'Headofhousehold', 1085, 1280.99, 34.2200, 8.8, 1085.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (510, 1, N'Headofhousehold', 1281, 6537.99, 51.4700, 10.23, 1281.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (511, 1, N'Headofhousehold', 6538, 7845.99, 589.2600, 11.33, 6538.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (512, 1, N'Married', 0, 285.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (513, 1, N'Married', 286, 679.99, 3.1500, 2.2, 286.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (514, 1, N'Married', 680, 1071.99, 11.8200, 4.4, 680.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (515, 1, N'Married', 1072, 1489.99, 29.0700, 6.6, 1072.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (516, 1, N'Married', 1490, 1881.99, 56.6600, 8.8, 1490.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (517, 1, N'Married', 1882, 9615.99, 91.1600, 10.23, 1882.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (518, 1, N'Married', 9616, 11537.99, 882.3500, 11.33, 9616.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (519, 1, N'Single', 0, 142.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (520, 1, N'Single', 143, 339.99, 1.5700, 2.2, 143.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (521, 1, N'Single', 340, 535.99, 5.9000, 4.4, 340.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (522, 1, N'Single', 536, 744.99, 14.5200, 6.6, 536.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (523, 1, N'Single', 745, 940.99, 28.3100, 8.8, 745.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (524, 1, N'Single', 941, 4807.99, 45.5600, 10.23, 941.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (525, 1, N'Single', 4808, 5768.99, 441.1500, 11.33, 4808.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (526, 2, N'Headofhousehold', 0, 575.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (527, 2, N'Headofhousehold', 576, 1359.99, 6.3100, 2.2, 576.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (528, 2, N'Headofhousehold', 1360, 1751.99, 23.6000, 4.4, 1360.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (529, 2, N'Headofhousehold', 1752, 2169.99, 40.8500, 6.6, 1752.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (530, 2, N'Headofhousehold', 2170, 2561.99, 68.4400, 8.8, 2170.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (531, 2, N'Headofhousehold', 2562, 13075.99, 102.9400, 10.23, 2562.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (532, 2, N'Headofhousehold', 13076, 15691.99, 1178.5200, 11.3, 13076.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (533, 2, N'Married', 0, 571.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (534, 2, N'Married', 572, 1359.99, 6.2900, 2.2, 572.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (535, 2, N'Married', 1360, 2143.99, 23.6300, 4.4, 1360.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (536, 2, N'Married', 2144, 2979.99, 58.1300, 6.6, 2144.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (537, 2, N'Married', 2980, 3763.99, 113.3100, 8.8, 2980.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (538, 2, N'Married', 3764, 19231.99, 182.3000, 10.23, 3764.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (539, 2, N'Married', 19232, 23075.99, 1764.6800, 11.33, 19232.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (540, 2, N'Single', 0, 285.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (541, 2, N'Single', 286, 679.99, 3.1500, 2.2, 286.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (542, 2, N'Single', 680, 1071.99, 11.8200, 4.4, 680.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (543, 2, N'Single', 1072, 1489.99, 29.0700, 6.6, 1072.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (544, 2, N'Single', 1490, 1881.99, 56.6600, 8.8, 1490.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (545, 2, N'Single', 1882, 9615.99, 91.1600, 10.23, 1882.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (546, 2, N'Single', 9616, 11537.99, 882.3500, 11.33, 9616.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (547, 3, N'Headofhousehold', 0, 621.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (548, 3, N'Headofhousehold', 622, 1472.99, 6.8400, 2.2, 622.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (549, 3, N'Headofhousehold', 1473, 1898.99, 25.5600, 4.4, 1473.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (550, 3, N'Headofhousehold', 1899, 2349.99, 44.3000, 6.6, 1899.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (551, 3, N'Headofhousehold', 2350, 2775.99, 74.0700, 8.8, 2350.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (552, 3, N'Headofhousehold', 2776, 14166.99, 111.5600, 10.23, 2776.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (553, 3, N'Headofhousehold', 14167, 16999.99, 1276.8600, 11.33, 14167.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (554, 3, N'Married', 0, 621.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (555, 3, N'Married', 622, 1473.99, 6.8400, 2.2, 622.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (556, 3, N'Married', 1474, 2323.99, 25.5800, 4.4, 1474.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (557, 3, N'Married', 2324, 3227.99, 62.9800, 6.6, 2324.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (558, 3, N'Married', 3228, 4077.99, 122.6400, 8.8, 3228.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (559, 3, N'Married', 4078, 20833.99, 197.4400, 10.23, 4078.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (560, 3, N'Married', 20834, 24999.99, 1911.5800, 11.33, 20834.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (561, 3, N'Single', 0, 310.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (562, 3, N'Single', 311, 736.99, 3.4200, 2.2, 311.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (563, 3, N'Single', 737, 1161.99, 12.7900, 4.4, 737.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (564, 3, N'Single', 1162, 1613.99, 31.4900, 6.6, 1162.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (565, 3, N'Single', 1614, 2038.99, 61.3200, 8.8, 1614.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (566, 3, N'Single', 2039, 10416.99, 98.7200, 10.23, 2039.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (567, 3, N'Single', 10417, 12499.99, 955.7900, 11.33, 10417.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (568, 4, N'Headofhousehold', 0, 1243.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (569, 4, N'Headofhousehold', 1244, 2945.99, 13.6800, 2.2, 1244.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (570, 4, N'Headofhousehold', 2946, 3797.99, 51.1200, 4.4, 2946.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (571, 4, N'Headofhousehold', 3798, 4699.99, 88.6100, 6.6, 3798.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (572, 4, N'Headofhousehold', 4700, 5551.99, 148.1400, 8.8, 4700.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (573, 4, N'Headofhousehold', 5552, 28333.99, 223.1200, 10.23, 5552.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (574, 4, N'Headofhousehold', 28334, 33999.99, 2553.7200, 11.33, 28334.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (575, 4, N'Married', 0, 1243.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (576, 4, N'Married', 1244, 2947.99, 13.6800, 2.2, 1244.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (577, 4, N'Married', 2948, 4647.99, 51.1700, 4.4, 2948.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (578, 4, N'Married', 4648, 6455.99, 125.9700, 6.6, 4648.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (579, 4, N'Married', 6456, 8155.99, 245.3000, 8.8, 6456.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (580, 4, N'Married', 8156, 41667.99, 394.9000, 10.23, 8156.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (581, 4, N'Married', 41668, 49999.99, 3823.1800, 11.33, 41668.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (582, 4, N'Single', 0, 621.99, 0.0000, 1.1, 0.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (583, 4, N'Single', 622, 1473.99, 6.8400, 2.2, 622.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (584, 4, N'Single', 1474, 2323.99, 25.5800, 4.4, 1474.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (585, 4, N'Single', 2324, 3227.99, 62.9800, 6.6, 2324.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (586, 4, N'Single', 3228, 4077.99, 122.6400, 8.8, 3228.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (587, 4, N'Single', 4078, 20833.99, 197.4400, 10.23, 4078.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (588, 4, N'Single', 20834, 24999.99, 1911.5800, 11.33, 20834.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (589, 1, N'Single', 0, 145.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (590, 1, N'Single', 146, 345.99, 1.6100, 2.2, 146.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (591, 1, N'Single', 346, 545.99, 6.0100, 4.4, 346.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (592, 1, N'Single', 546, 756.99, 14.8100, 6.6, 546.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (593, 1, N'Single', 757, 956.99, 28.7400, 8.8, 757.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (594, 1, N'Single', 957, 4888.99, 46.3400, 10.23, 957.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (595, 1, N'Single', 4889, 5866.99, 448.5800, 11.33, 4889.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (596, 1, N'Single', 5867, 9778.99, 559.3900, 12.43, 5867.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (597, 1, N'Single', 9779, 19230.99, 1045.6500, 13.53, 9779.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (598, 1, N'Single', 19231, NULL, 2324.5100, 14.63, 19231.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (599, 1, N'Headofhousehold', 0, 291.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (600, 1, N'Headofhousehold', 292, 690.99, 3.2100, 2.2, 292.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (601, 1, N'Headofhousehold', 691, 890.99, 11.9900, 4.4, 691.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (602, 1, N'Headofhousehold', 7846, 13076.99, 737.4600, 12.43, 7846.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (603, 1, N'Headofhousehold', 13077, 19230.99, 1387.6700, 13.53, 13077.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (604, 1, N'Headofhousehold', 19231, NULL, 2220.3100, 14.63, 19231.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (605, 1, N'Headofhousehold', 891, 1102.99, 20.7900, 6.6, 891.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (606, 1, N'Married', 11538, 19230.99, 1100.1100, 12.43, 11538.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (607, 1, N'Married', 19231, NULL, 2056.3500, 14.63, 19231.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (608, 1, N'Single', 5769, 9614.99, 550.0300, 12.43, 5769.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (609, 1, N'Single', 9615, 19230.99, 1028.0900, 13.53, 9615.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (610, 1, N'Single', 19231, NULL, 2329.1300, 14.63, 19231.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (611, 2, N'Headofhousehold', 15692, 26153.99, 1474.9100, 12.43, 15692.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (612, 2, N'Headofhousehold', 26154, 38461.99, 2775.3400, 13.53, 26154.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (613, 2, N'Headofhousehold', 38462, NULL, 4440.6100, 14.63, 38462.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (614, 1, N'Headofhousehold', 1103, 1302.99, 34.7800, 8.8, 1103.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (615, 2, N'Married', 23076, 38461.99, 2200.2100, 12.43, 23076.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (616, 2, N'Married', 38462, NULL, 4112.6900, 14.63, 38462.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (617, 2, N'Single', 11538, 19229.99, 1100.1100, 12.43, 11538.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (618, 2, N'Single', 19230, 38461.99, 2056.2300, 13.53, 19230.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (619, 2, N'Single', 38462, NULL, 4658.3200, 14.63, 38462.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (620, 3, N'Headofhousehold', 17000, 28332.99, 1597.8400, 12.43, 17000.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (621, 3, N'Headofhousehold', 28333, 41666.99, 3006.5300, 13.53, 28333.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (622, 3, N'Headofhousehold', 41667, NULL, 4810.6200, 14.63, 41667.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (623, 1, N'Headofhousehold', 1303, 6649.99, 52.3800, 10.23, 1303.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (624, 3, N'Married', 25000, 41666.99, 2383.5900, 12.43, 25000.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (625, 3, N'Married', 41667, NULL, 4455.3000, 14.63, 41667.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (626, 3, N'Single', 12500, 20832.99, 1191.7900, 12.43, 12500.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (627, 3, N'Single', 20833, 41666.99, 2227.5800, 13.53, 20833.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (628, 3, N'Single', 41667, NULL, 5046.4200, 14.63, 41667.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (629, 4, N'Headofhousehold', 34000, 56665.99, 3195.6800, 12.43, 34000.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (630, 4, N'Headofhousehold', 56666, 83333.99, 6013.0600, 13.53, 56666.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (631, 4, N'Headofhousehold', 83334, NULL, 9612.2400, 14.63, 83334.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (632, 1, N'Headofhousehold', 6650, 7979.99, 599.3800, 11.33, 6650.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (633, 4, N'Married', 50000, 83333.99, 4767.2000, 12.43, 50000.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (634, 4, N'Married', 83334, NULL, 8910.6200, 14.63, 83334.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (635, 4, N'Single', 25000, 41665.99, 2383.5900, 12.43, 25000.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (636, 4, N'Single', 41666, 83333.99, 4455.1700, 13.53, 41666.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (637, 4, N'Single', 83334, NULL, 10092.8500, 14.63, 83334.0000, 2013)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (638, 1, N'Headofhousehold', 7980, 13298.99, 750.0700, 12.43, 7980.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (639, 1, N'Headofhousehold', 13299, 19230.99, 1411.2200, 13.53, 13299.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (640, 1, N'Headofhousehold', 19231, NULL, 2213.8200, 14.63, 19231.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (641, 1, N'Married', 0, 291.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (642, 1, N'Married', 292, 691.99, 3.2100, 2.2, 292.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (643, 1, N'Married', 692, 1091.99, 12.0100, 4.4, 692.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (644, 1, N'Married', 1092, 1513.99, 29.6100, 6.6, 1092.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (645, 1, N'Married', 1514, 1913.99, 57.4600, 8.8, 1514.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (646, 1, N'Married', 1914, 9777.99, 92.6600, 10.23, 1914.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (647, 1, N'Married', 9778, 11733.99, 897.1500, 11.33, 9778.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (648, 1, N'Married', 11734, 19230.99, 1118.7600, 12.43, 11734.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (649, 1, N'Married', 19231, 19557.99, 2050.6400, 13.53, 19231.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (650, 1, N'Married', 19558, NULL, 2094.8800, 14.63, 19558.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (651, 2, N'Single', 0, 291.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (652, 2, N'Single', 292, 691.99, 3.2100, 2.2, 292.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (653, 2, N'Single', 692, 1091.99, 12.0100, 4.4, 692.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (654, 2, N'Single', 1092, 1513.99, 29.6100, 6.6, 1092.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (655, 2, N'Single', 1514, 1913.99, 57.4600, 8.8, 1514.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (656, 2, N'Single', 1914, 9777.99, 92.6600, 10.23, 1914.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (657, 2, N'Single', 9778, 11733.99, 897.1500, 11.33, 9778.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (658, 2, N'Single', 11734, 19557.99, 1118.7600, 12.43, 11734.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (659, 2, N'Single', 19558, 38461.99, 2091.2800, 13.53, 19558.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (660, 2, N'Single', 38462, NULL, 4648.9900, 14.63, 38462.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (661, 2, N'Headofhousehold', 0, 583.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (662, 2, N'Headofhousehold', 584, 1381.99, 6.4200, 2.2, 584.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (663, 2, N'Headofhousehold', 1382, 1781.99, 23.9800, 4.4, 1382.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (664, 2, N'Headofhousehold', 1782, 2205.99, 41.5800, 6.6, 1782.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (665, 2, N'Headofhousehold', 2206, 2605.99, 69.5600, 8.8, 2206.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (666, 2, N'Headofhousehold', 2606, 13299.99, 104.7600, 10.23, 2606.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (667, 2, N'Headofhousehold', 13300, 15959.99, 1198.7600, 11.33, 13300.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (668, 2, N'Headofhousehold', 15960, 26597.99, 1500.1400, 12.43, 15960.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (669, 2, N'Headofhousehold', 26598, 38461.99, 2822.4400, 13.53, 26598.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (670, 2, N'Headofhousehold', 38462, NULL, 4427.6400, 14.63, 38462.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (671, 2, N'Married', 0, 583.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (672, 2, N'Married', 584, 1383.99, 6.4200, 2.2, 584.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (673, 2, N'Married', 1384, 2183.99, 24.0200, 4.4, 1384.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (674, 2, N'Married', 2184, 3027.99, 59.2200, 6.6, 2184.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (675, 2, N'Married', 3028, 3827.99, 114.9200, 8.8, 3028.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (676, 2, N'Married', 3828, 19555.99, 185.3200, 10.23, 3828.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (677, 2, N'Married', 19556, 23467.99, 1794.2900, 11.33, 19556.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (678, 2, N'Married', 23468, 38461.99, 2237.5200, 12.43, 23468.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (679, 2, N'Married', 38462, 39115.99, 4101.2700, 13.53, 38462.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (680, 2, N'Married', 39116, NULL, 4189.7600, 14.63, 39116.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (681, 3, N'Single', 0, 315.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (682, 3, N'Single', 316, 748.99, 3.4800, 2.2, 316.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (683, 3, N'Single', 749, 1181.99, 13.0100, 4.4, 749.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (684, 3, N'Single', 1182, 1640.99, 32.0600, 6.6, 1182.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (685, 3, N'Single', 1641, 2073.99, 62.3500, 8.8, 1641.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (686, 3, N'Single', 2074, 10593.99, 100.4500, 10.23, 2074.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (687, 3, N'Single', 10594, 12712.99, 972.0500, 11.33, 10594.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (688, 3, N'Single', 12713, 21187.99, 1212.1300, 12.43, 12713.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (689, 3, N'Single', 21188, 41666.99, 2265.5700, 13.53, 21188.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (690, 3, N'Single', 41667, NULL, 5036.3800, 14.63, 41667.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (691, 3, N'Headofhousehold', 0, 631.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (692, 3, N'Headofhousehold', 632, 1497.99, 6.9500, 2.2, 632.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (693, 3, N'Headofhousehold', 1498, 1930.99, 26.0000, 4.4, 1498.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (694, 3, N'Headofhousehold', 1931, 2389.99, 45.0500, 6.6, 1931.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (695, 3, N'Headofhousehold', 2390, 2822.99, 75.3400, 8.8, 2390.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (696, 3, N'Headofhousehold', 2823, 14407.99, 113.4400, 10.23, 2823.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (697, 3, N'Headofhousehold', 14408, 17288.99, 1298.5900, 11.33, 14408.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (698, 3, N'Headofhousehold', 17289, 28814.99, 1625.0100, 12.43, 17289.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (699, 3, N'Headofhousehold', 28815, 41666.99, 3057.6900, 13.53, 28815.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (700, 3, N'Headofhousehold', 41667, NULL, 4796.5700, 14.63, 41667.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (701, 3, N'Married', 0, 631.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (702, 3, N'Married', 632, 1497.99, 6.9500, 2.2, 632.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (703, 3, N'Married', 1498, 2363.99, 26.0000, 4.4, 1498.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (704, 3, N'Married', 2364, 3281.99, 64.1000, 6.6, 2364.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (705, 3, N'Married', 3282, 4147.99, 124.6900, 8.8, 3282.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (706, 3, N'Married', 4148, 21187.99, 200.9000, 10.23, 4148.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (707, 3, N'Married', 21188, 25425.99, 1944.0900, 11.33, 21188.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (708, 3, N'Married', 25426, 41666.99, 2424.2600, 12.43, 25426.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (709, 3, N'Married', 41667, 42374.99, 4443.0200, 13.53, 41667.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (710, 3, N'Married', 42375, NULL, 4538.8100, 14.63, 42375.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (711, 4, N'Single', 0, 631.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (712, 4, N'Single', 632, 1497.99, 6.9500, 2.2, 632.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (713, 4, N'Single', 1498, 2363.99, 26.0000, 4.4, 1498.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (714, 4, N'Single', 2364, 3281.99, 64.1000, 6.6, 2364.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (715, 4, N'Single', 3282, 4147.99, 124.6900, 8.8, 3282.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (716, 4, N'Single', 4148, 21187.99, 200.9000, 10.23, 4148.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (717, 4, N'Single', 21188, 25425.99, 1944.0900, 11.33, 21188.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (718, 4, N'Single', 25426, 42375.99, 2424.2600, 12.43, 25426.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (719, 4, N'Single', 42376, 83333.99, 4531.1500, 13.53, 42376.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (720, 4, N'Single', 83334, NULL, 10072.7700, 14.63, 83334.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (721, 4, N'Headofhousehold', 0, 1263.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (722, 4, N'Headofhousehold', 1264, 2995.99, 13.9000, 2.2, 1264.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (723, 4, N'Headofhousehold', 2996, 3861.99, 52.0000, 4.4, 2996.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (724, 4, N'Headofhousehold', 3862, 4779.99, 90.1000, 6.6, 3862.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (725, 4, N'Headofhousehold', 4780, 5645.99, 150.6900, 8.8, 4780.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (726, 4, N'Headofhousehold', 5646, 28815.99, 226.9000, 10.23, 5646.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (727, 4, N'Headofhousehold', 28816, 34577.99, 2597.1900, 11.33, 28816.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (728, 4, N'Headofhousehold', 34578, 57629.99, 3250.0200, 12.43, 34578.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (729, 4, N'Headofhousehold', 57630, 83333.99, 6115.3800, 13.53, 57630.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (730, 4, N'Headofhousehold', 83334, NULL, 9593.1300, 14.63, 83334.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (731, 4, N'Married', 0, 1263.99, 0.0000, 1.1, 0.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (732, 4, N'Married', 1264, 2995.99, 13.9000, 2.2, 1264.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (733, 4, N'Married', 2996, 4727.99, 52.0000, 4.4, 2996.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (734, 4, N'Married', 4728, 6563.99, 128.2100, 6.6, 4728.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (735, 4, N'Married', 6564, 8295.99, 249.3900, 8.8, 6564.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (736, 4, N'Married', 8296, 42375.99, 401.8100, 10.23, 8296.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (737, 4, N'Married', 42376, 50851.99, 3888.1900, 11.33, 42376.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (738, 4, N'Married', 50852, 83333.99, 4848.5200, 12.43, 50852.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (739, 4, N'Married', 83334, 84749.99, 8886.0300, 13.53, 83334.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (740, 4, N'Married', 84750, NULL, 9077.6100, 14.63, 84750.0000, 2014)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (741, 1, N'Single', 0, 148.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (742, 1, N'Single', 149, 352.99, 1.6400, 2.2, 149.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (743, 1, N'Single', 353, 557.99, 6.1300, 4.4, 353.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (744, 1, N'Single', 558, 773.99, 15.1500, 6.6, 558.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (745, 1, N'Single', 774, 977.99, 29.4100, 8.8, 774.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (746, 1, N'Single', 978, 4996.99, 47.3600, 10.23, 978.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (747, 1, N'Single', 4997, 5995.99, 458.5000, 11.33, 4997.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (748, 1, N'Single', 5996, 9993.99, 571.6900, 12.43, 5996.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (749, 1, N'Single', 9994, 19230.99, 1068.6400, 13.53, 9994.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (750, 1, N'Single', 19231, NULL, 2318.4100, 14.63, 19231.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (751, 1, N'Headofhousehold', 0, 297.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (752, 1, N'Headofhousehold', 298, 706.99, 3.2800, 2.2, 298.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (753, 1, N'Headofhousehold', 707, 910.99, 12.2800, 4.4, 707.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (754, 1, N'Headofhousehold', 911, 1126.99, 21.2600, 6.6, 911.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (755, 1, N'Headofhousehold', 1127, 1331.99, 35.5200, 8.8, 1127.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (756, 1, N'Headofhousehold', 1332, 6795.99, 53.5600, 10.23, 1332.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (757, 1, N'Headofhousehold', 6796, 8154.99, 612.5300, 11.33, 6796.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (758, 1, N'Headofhousehold', 8155, 13591.99, 766.5000, 12.43, 8155.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (759, 1, N'Headofhousehold', 13592, 19230.99, 1442.3200, 13.53, 13592.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (760, 1, N'Headofhousehold', 19231, NULL, 2205.2800, 14.63, 19231.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (761, 1, N'Married', 0, 297.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (762, 1, N'Married', 298, 705.99, 3.2800, 2.2, 298.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (763, 1, N'Married', 706, 1115.99, 12.2600, 4.4, 706.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (764, 1, N'Married', 1116, 1547.99, 30.3000, 6.6, 1116.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (765, 1, N'Married', 1548, 1955.99, 58.8100, 8.8, 1548.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (766, 1, N'Married', 1956, 9993.99, 94.7100, 10.23, 1956.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (767, 1, N'Married', 9994, 11991.99, 917.0000, 11.33, 9994.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (768, 1, N'Married', 11992, 19230.99, 1143.3700, 12.43, 11992.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (769, 1, N'Married', 19231, 19987.99, 2043.1800, 13.53, 19231.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (770, 1, N'Married', 19988, NULL, 2145.6000, 14.63, 19988.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (771, 2, N'Single', 0, 297.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (772, 2, N'Single', 298, 705.99, 3.2800, 2.2, 298.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (773, 2, N'Single', 706, 1115.99, 12.2600, 4.4, 706.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (774, 2, N'Single', 1116, 1547.99, 30.3000, 6.6, 1116.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (775, 2, N'Single', 1548, 1955.99, 58.8100, 8.8, 1548.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (776, 2, N'Single', 1956, 9993.99, 94.7100, 10.23, 1956.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (777, 2, N'Single', 9994, 11991.99, 917.0000, 11.33, 9994.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (778, 2, N'Single', 11992, 19987.99, 1143.3700, 12.43, 11992.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (779, 2, N'Single', 19988, 38461.99, 2137.2700, 13.53, 19988.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (780, 2, N'Single', 38462, NULL, 4636.8000, 14.63, 38462.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (781, 2, N'Headofhousehold', 0, 595.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (782, 2, N'Headofhousehold', 596, 1413.99, 6.5600, 2.2, 596.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (783, 2, N'Headofhousehold', 1414, 1821.99, 24.5600, 4.4, 1414.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (784, 2, N'Headofhousehold', 1822, 2253.99, 42.5100, 6.6, 1822.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (785, 2, N'Headofhousehold', 2254, 2663.99, 71.0200, 8.8, 2254.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (786, 2, N'Headofhousehold', 2664, 13591.99, 107.1000, 10.23, 2664.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (787, 2, N'Headofhousehold', 13592, 16309.99, 1225.0300, 11.33, 13592.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (788, 2, N'Headofhousehold', 16310, 27183.99, 1532.9800, 12.43, 16310.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (789, 2, N'Headofhousehold', 27184, 38461.99, 2884.6200, 13.53, 27184.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (790, 2, N'Headofhousehold', 38462, NULL, 4410.5300, 14.63, 38462.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (791, 2, N'Married', 0, 595.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (792, 2, N'Married', 596, 1411.99, 6.5600, 2.2, 596.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (793, 2, N'Married', 1412, 2231.99, 24.5100, 4.4, 1412.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (794, 2, N'Married', 2232, 3095.99, 60.5900, 6.6, 2232.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (795, 2, N'Married', 3096, 3911.99, 117.6100, 8.8, 3096.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (796, 2, N'Married', 3912, 19987.99, 189.4200, 10.23, 3912.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (797, 2, N'Married', 19988, 23983.99, 1833.9900, 11.33, 19988.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (798, 2, N'Married', 23984, 38461.99, 2286.7400, 12.43, 23984.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (799, 2, N'Married', 38462, 39975.99, 4086.3600, 13.53, 38462.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (800, 2, N'Married', 39976, NULL, 4291.6000, 14.63, 39976.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (801, 3, N'Single', 0, 322.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (802, 3, N'Single', 323, 764.99, 3.5500, 2.2, 323.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (803, 3, N'Single', 765, 1207.99, 13.2700, 4.4, 765.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (804, 3, N'Single', 1208, 1676.99, 32.7600, 6.6, 1208.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (805, 3, N'Single', 1677, 2119.99, 63.7100, 8.8, 1677.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (806, 3, N'Single', 2120, 10826.99, 102.6900, 10.23, 2120.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (807, 3, N'Single', 10827, 12991.99, 993.4200, 11.33, 10827.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (808, 3, N'Single', 12992, 21653.99, 1238.7100, 12.43, 12992.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (809, 3, N'Single', 21654, 41666.99, 2315.4000, 13.53, 21654.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (810, 3, N'Single', 41667, NULL, 5023.1600, 14.63, 41667.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (811, 3, N'Headofhousehold', 0, 645.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (812, 3, N'Headofhousehold', 646, 1530.99, 7.1100, 2.2, 646.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (813, 3, N'Headofhousehold', 1531, 1973.99, 26.5800, 4.4, 1531.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (814, 3, N'Headofhousehold', 1974, 2442.99, 46.0700, 6.6, 1974.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (815, 3, N'Headofhousehold', 2443, 2884.99, 77.0200, 8.8, 2443.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (816, 3, N'Headofhousehold', 2885, 14723.99, 115.9200, 10.23, 2885.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (817, 3, N'Headofhousehold', 14724, 17668.99, 1327.0500, 11.33, 14724.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (818, 3, N'Headofhousehold', 17669, 29448.99, 1660.7200, 12.43, 17669.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (819, 3, N'Headofhousehold', 29449, 41666.99, 3124.9700, 13.53, 29449.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (820, 3, N'Headofhousehold', 41667, NULL, 4778.0700, 14.63, 41667.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (821, 3, N'Married', 0, 645.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (822, 3, N'Married', 646, 1529.99, 7.1100, 2.2, 646.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (823, 3, N'Married', 1530, 2415.99, 26.5600, 4.4, 1530.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (824, 3, N'Married', 2416, 3353.99, 65.5400, 6.6, 2416.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (825, 3, N'Married', 3354, 4239.99, 127.4500, 8.8, 3354.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (826, 3, N'Married', 4240, 21653.99, 205.4200, 10.23, 4240.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (827, 3, N'Married', 21654, 25983.99, 1986.8700, 11.33, 21654.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (828, 3, N'Married', 25984, 41666.99, 2477.4600, 12.43, 25984.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (829, 3, N'Married', 41667, 43306.99, 4426.8600, 13.53, 41667.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (830, 3, N'Married', 43307, NULL, 4648.7500, 14.63, 43307.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (831, 4, N'Single', 0, 645.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (832, 4, N'Single', 646, 1529.99, 7.1100, 2.2, 646.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (833, 4, N'Single', 1530, 2415.99, 26.5600, 4.4, 1530.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (834, 4, N'Single', 2416, 3353.99, 65.5400, 6.6, 2416.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (835, 4, N'Single', 3354, 4239.99, 127.4500, 8.8, 3354.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (836, 4, N'Single', 4240, 21653.99, 205.4200, 10.23, 4240.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (837, 4, N'Single', 21654, 25983.99, 1986.8700, 11.33, 21654.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (838, 4, N'Single', 25984, 43307.99, 2477.4600, 12.43, 25984.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (839, 4, N'Single', 43308, 83333.99, 4630.8300, 13.53, 43308.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (840, 4, N'Single', 83334, NULL, 10046.3500, 14.63, 83334.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (841, 4, N'Headofhousehold', 0, 1291.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (842, 4, N'Headofhousehold', 1292, 3061.99, 14.2100, 2.2, 1292.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (843, 4, N'Headofhousehold', 3062, 3947.99, 53.1500, 4.4, 3062.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (844, 4, N'Headofhousehold', 3948, 4885.99, 92.1300, 6.6, 3948.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (845, 4, N'Headofhousehold', 4886, 5769.99, 154.0400, 8.8, 4886.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (846, 4, N'Headofhousehold', 5770, 29447.99, 231.8300, 10.23, 5770.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (847, 4, N'Headofhousehold', 29448, 35337.99, 2654.0900, 11.33, 29448.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (848, 4, N'Headofhousehold', 35338, 58897.99, 3321.4300, 12.43, 35338.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (849, 4, N'Headofhousehold', 58898, 83333.99, 6249.9400, 13.53, 58898.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (850, 4, N'Headofhousehold', 83334, NULL, 9556.1300, 14.63, 83334.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (851, 4, N'Married', 0, 1291.99, 0.0000, 1.1, 0.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (852, 4, N'Married', 1292, 3059.99, 14.2100, 2.2, 1292.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (853, 4, N'Married', 3060, 4831.99, 53.1100, 4.4, 3060.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (854, 4, N'Married', 4832, 6707.99, 131.0800, 6.6, 4832.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (855, 4, N'Married', 6708, 8479.99, 254.9000, 8.8, 6708.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (856, 4, N'Married', 8480, 43307.99, 410.8400, 10.23, 8480.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (857, 4, N'Married', 43308, 51967.99, 3973.7400, 11.33, 43308.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (858, 4, N'Married', 51968, 83333.99, 4954.9200, 12.43, 51968.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (859, 4, N'Married', 83334, 86613.99, 8853.7100, 13.53, 83334.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (860, 4, N'Married', 86614, NULL, 9297.4900, 14.63, 86614.0000, 2015)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (861, 1, N'Single', 0, 150.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (862, 1, N'Single', 151, 357.99, 1.6600, 2.2, 151.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (863, 1, N'Single', 358, 564.99, 6.2100, 4.4, 358.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (864, 1, N'Single', 565, 783.99, 15.3200, 6.6, 565.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (865, 1, N'Single', 784, 990.99, 29.7700, 8.8, 784.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (866, 1, N'Single', 991, 5061.99, 47.9900, 10.23, 991.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (867, 1, N'Single', 5062, 6073.99, 464.4500, 11.33, 5062.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (868, 1, N'Single', 6074, 10123.99, 579.1100, 12.43, 6074.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (869, 1, N'Single', 10124, 19230.99, 1082.5300, 13.53, 10124.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (870, 1, N'Single', 19231, NULL, 2314.7100, 14.63, 19231.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (871, 1, N'Headofhousehold', 0, 301.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (872, 1, N'Headofhousehold', 302, 715.99, 3.3200, 2.2, 302.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (873, 1, N'Headofhousehold', 716, 922.99, 12.4300, 4.4, 716.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (874, 1, N'Headofhousehold', 923, 1141.99, 21.5400, 6.6, 923.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (875, 1, N'Headofhousehold', 1142, 1348.99, 35.9900, 8.8, 1142.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (876, 1, N'Headofhousehold', 1349, 6883.99, 54.2100, 10.23, 1349.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (877, 1, N'Headofhousehold', 6884, 8260.99, 620.4400, 11.33, 6884.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (878, 1, N'Headofhousehold', 8261, 13768.99, 776.4500, 12.43, 8261.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (879, 1, N'Headofhousehold', 13769, 19230.99, 1461.0900, 13.53, 13769.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (880, 1, N'Headofhousehold', 19231, NULL, 2200.1000, 14.63, 19231.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (881, 1, N'Married', 0, 301.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (882, 1, N'Married', 302, 715.99, 3.3200, 2.2, 302.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (883, 1, N'Married', 716, 1129.99, 12.4300, 4.4, 716.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (884, 1, N'Married', 1130, 1567.99, 30.6500, 6.6, 1130.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (885, 1, N'Married', 1568, 1981.99, 59.5600, 8.8, 1568.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (886, 1, N'Married', 1982, 10123.99, 95.9900, 10.23, 1982.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (887, 1, N'Married', 10124, 12147.99, 928.9200, 11.33, 10124.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (888, 1, N'Married', 12148, 19230.99, 1158.2400, 12.43, 12148.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (889, 1, N'Married', 19231, 20247.99, 2038.6600, 13.53, 19231.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (890, 1, N'Married', 20248, NULL, 2176.2600, 14.63, 20248.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (891, 2, N'Single', 0, 301.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (892, 2, N'Single', 302, 715.99, 3.3200, 2.2, 302.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (893, 2, N'Single', 716, 1129.99, 12.4300, 4.4, 716.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (894, 2, N'Single', 1130, 1567.99, 30.6500, 6.6, 1130.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (895, 2, N'Single', 1568, 1981.99, 59.5600, 8.8, 1568.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (896, 2, N'Single', 1982, 10123.99, 95.9900, 10.23, 1982.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (897, 2, N'Single', 10124, 12147.99, 928.9200, 11.33, 10124.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (898, 2, N'Single', 12148, 20247.99, 1158.2400, 12.43, 12148.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (899, 2, N'Single', 20248, 38461.99, 2165.0700, 13.53, 20248.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (900, 2, N'Single', 38462, NULL, 4629.4200, 14.63, 38462.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (901, 2, N'Headofhousehold', 0, 603.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (902, 2, N'Headofhousehold', 604, 1431.99, 6.6400, 2.2, 604.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (903, 2, N'Headofhousehold', 1432, 1845.99, 24.8600, 4.4, 1432.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (904, 2, N'Headofhousehold', 1846, 2283.99, 43.0800, 6.6, 1846.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (905, 2, N'Headofhousehold', 2284, 2697.99, 71.9900, 8.8, 2284.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (906, 2, N'Headofhousehold', 2698, 13767.99, 108.4200, 10.23, 2698.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (907, 2, N'Headofhousehold', 13768, 16521.99, 1240.8800, 11.33, 13768.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (908, 2, N'Headofhousehold', 16522, 27537.99, 1552.9100, 12.43, 16522.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (909, 2, N'Headofhousehold', 27538, 38461.99, 2922.2000, 13.53, 27538.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (910, 2, N'Headofhousehold', 38462, NULL, 4400.2200, 14.63, 38462.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (911, 2, N'Married', 0, 603.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (912, 2, N'Married', 604, 1431.99, 6.6400, 2.2, 604.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (913, 2, N'Married', 1432, 2259.99, 24.8600, 4.4, 1432.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (914, 2, N'Married', 2260, 3135.99, 61.2900, 6.6, 2260.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (915, 2, N'Married', 3136, 3963.99, 119.1100, 8.8, 3136.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (916, 2, N'Married', 3964, 20247.99, 191.9700, 10.23, 3964.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (917, 2, N'Married', 20248, 24295.99, 1857.8200, 11.33, 20248.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (918, 2, N'Married', 24296, 38461.99, 2316.4600, 12.43, 24296.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (919, 2, N'Married', 38462, 40495.99, 4077.2900, 13.53, 38462.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (920, 2, N'Married', 40496, NULL, 4352.4900, 14.63, 40496.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (921, 3, N'Single', 0, 326.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (922, 3, N'Single', 327, 774.99, 3.6000, 2.2, 327.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (923, 3, N'Single', 775, 1223.99, 13.4600, 4.4, 775.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (924, 3, N'Single', 1224, 1698.99, 33.2200, 6.6, 1224.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (925, 3, N'Single', 1699, 2146.99, 64.5700, 8.8, 1699.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (926, 3, N'Single', 2147, 10967.99, 103.9900, 10.23, 2147.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (927, 3, N'Single', 10968, 13160.99, 1006.3800, 11.33, 10968.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (928, 3, N'Single', 13161, 21934.99, 1254.8500, 12.43, 13161.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (929, 3, N'Single', 21935, 41666.99, 2345.4600, 13.53, 21935.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (930, 3, N'Single', 41667, NULL, 5015.2000, 14.63, 41667.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (931, 3, N'Headofhousehold', 0, 654.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (932, 3, N'Headofhousehold', 655, 1550.99, 7.2100, 2.2, 655.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (933, 3, N'Headofhousehold', 1551, 1998.99, 26.9200, 4.4, 1551.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (934, 3, N'Headofhousehold', 1999, 2473.99, 46.6300, 6.6, 1999.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (935, 3, N'Headofhousehold', 2474, 2922.99, 77.9800, 8.8, 2474.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (936, 3, N'Headofhousehold', 2923, 14915.99, 117.4900, 10.23, 2923.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (937, 3, N'Headofhousehold', 14916, 17898.99, 1344.3700, 11.33, 14916.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (938, 3, N'Headofhousehold', 17899, 29831.99, 1682.3400, 12.43, 17899.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (939, 3, N'Headofhousehold', 29832, 41666.99, 3165.6100, 13.53, 29832.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (940, 3, N'Headofhousehold', 41667, NULL, 4766.8900, 14.63, 41667.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (941, 3, N'Married', 0, 653.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (942, 3, N'Married', 654, 1549.99, 7.1900, 2.2, 654.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (943, 3, N'Married', 1550, 2447.99, 26.9000, 4.4, 1550.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (944, 3, N'Married', 2448, 3397.99, 66.4100, 6.6, 2448.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (945, 3, N'Married', 3398, 4293.99, 129.1100, 8.8, 3398.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (946, 3, N'Married', 4294, 21935.99, 207.9600, 10.23, 4294.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (947, 3, N'Married', 21936, 26321.99, 2012.7400, 11.33, 21936.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (948, 3, N'Married', 26322, 41666.99, 2509.6700, 12.43, 26322.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (949, 3, N'Married', 41667, 43869.99, 4417.0500, 13.53, 41667.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (950, 3, N'Married', 43870, NULL, 4715.1200, 14.63, 43870.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (951, 4, N'Single', 0, 653.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (952, 4, N'Single', 654, 1549.99, 7.1900, 2.2, 654.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (953, 4, N'Single', 1550, 2447.99, 26.9000, 4.4, 1550.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (954, 4, N'Single', 2448, 3397.99, 66.4100, 6.6, 2448.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (955, 4, N'Single', 3398, 4293.99, 129.1100, 8.8, 3398.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (956, 4, N'Single', 4294, 21935.99, 207.9600, 10.23, 4294.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (957, 4, N'Single', 21936, 26321.99, 2012.7400, 11.33, 21936.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (958, 4, N'Single', 26322, 43869.99, 2509.6700, 12.43, 26322.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (959, 4, N'Single', 43870, 83333.99, 4690.8900, 13.53, 43870.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (960, 4, N'Single', 83334, NULL, 10030.3700, 14.63, 83334.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (961, 4, N'Headofhousehold', 0, 1309.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (962, 4, N'Headofhousehold', 1310, 3101.99, 14.4100, 2.2, 1310.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (963, 4, N'Headofhousehold', 3102, 3997.99, 53.8300, 4.4, 3102.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (964, 4, N'Headofhousehold', 3998, 4947.99, 93.2500, 6.6, 3998.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (965, 4, N'Headofhousehold', 4948, 5845.99, 155.9500, 8.8, 4948.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (966, 4, N'Headofhousehold', 5846, 29831.99, 234.9700, 10.23, 5846.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (967, 4, N'Headofhousehold', 29832, 35797.99, 2688.7400, 11.33, 29832.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (968, 4, N'Headofhousehold', 35798, 59663.99, 3364.6900, 12.43, 35798.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (969, 4, N'Headofhousehold', 59664, 83333.99, 6331.2300, 13.53, 59664.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (970, 4, N'Headofhousehold', 83334, NULL, 9533.7800, 14.63, 83334.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (971, 4, N'Married', 0, 1307.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (972, 4, N'Married', 1308, 3099.99, 14.3900, 2.2, 1308.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (973, 4, N'Married', 3100, 4895.99, 53.8100, 4.4, 3100.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (974, 4, N'Married', 4896, 6795.99, 132.8300, 6.6, 4896.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (975, 4, N'Married', 6796, 8587.99, 258.2300, 8.8, 6796.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (976, 4, N'Married', 8588, 43871.99, 415.9300, 10.23, 8588.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (977, 4, N'Married', 43872, 52643.99, 4025.4800, 11.33, 43872.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (978, 4, N'Married', 52644, 83333.99, 5019.3500, 12.43, 52644.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (979, 4, N'Married', 83334, 87739.99, 8834.1200, 13.53, 83334.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (980, 4, N'Married', 87740, NULL, 9430.2500, 14.63, 87740.0000, 2016)
GO
SET IDENTITY_INSERT [dbo].[SITTaxTable] OFF
GO
SET IDENTITY_INSERT [dbo].[StandardDeductionTable] ON 

GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (1, 1, N'Single', 68.0000, 68.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (2, 2, N'Single', 135.0000, 135.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (3, 3, N'Single', 147.0000, 147.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (4, 4, N'Single', 293.0000, 293.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (5, 1, N'DualIncomeMarried', 68.0000, 68.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (6, 2, N'DualIncomeMarried', 135.0000, 135.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (7, 3, N'DualIncomeMarried', 147.0000, 147.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (8, 4, N'DualIncomeMarried', 293.0000, 293.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (9, 1, N'MarriedWithMultipleEmployers', 68.0000, 68.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (10, 2, N'MarriedWithMultipleEmployers', 135.0000, 135.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (11, 3, N'MarriedWithMultipleEmployers', 147.0000, 147.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (12, 4, N'MarriedWithMultipleEmployers', 293.0000, 293.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (13, 1, N'Married ', 68.0000, 135.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (14, 2, N'Married ', 135.0000, 270.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (15, 3, N'Married ', 147.0000, 293.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (16, 4, N'Married ', 293.0000, 586.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (17, 1, N'Headofhousehold', 135.0000, 135.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (18, 2, N'Headofhousehold', 270.0000, 270.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (19, 3, N'Headofhousehold', 293.0000, 293.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (20, 4, N'Headofhousehold', 586.0000, 586.0000, 2008)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (21, 1, N'Single', 66.0000, 66.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (22, 2, N'Single', 131.0000, 131.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (23, 3, N'Single', 142.0000, 142.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (24, 4, N'Single', 284.0000, 284.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (25, 1, N'DualIncomeMarried', 66.0000, 66.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (26, 2, N'DualIncomeMarried', 131.0000, 131.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (27, 3, N'DualIncomeMarried', 142.0000, 142.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (28, 4, N'DualIncomeMarried', 284.0000, 284.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (29, 1, N'MarriedWithMultipleEmployers', 66.0000, 66.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (30, 2, N'MarriedWithMultipleEmployers', 131.0000, 131.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (31, 3, N'MarriedWithMultipleEmployers', 142.0000, 142.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (32, 4, N'MarriedWithMultipleEmployers', 284.0000, 284.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (33, 1, N'Married ', 66.0000, 131.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (34, 2, N'Married ', 131.0000, 262.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (35, 3, N'Married ', 142.0000, 284.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (36, 4, N'Married ', 284.0000, 568.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (37, 1, N'Headofhousehold', 131.0000, 131.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (38, 2, N'Headofhousehold', 262.0000, 262.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (39, 3, N'Headofhousehold', 284.0000, 284.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (40, 4, N'Headofhousehold', 568.0000, 568.0000, 2007)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (41, 1, N'Single', 71.0000, 71.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (42, 2, N'Single', 142.0000, 142.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (43, 3, N'Single', 154.0000, 154.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (44, 4, N'Single', 308.0000, 308.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (45, 1, N'DualIncomeMarried', 71.0000, 71.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (46, 2, N'DualIncomeMarried', 142.0000, 142.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (47, 3, N'DualIncomeMarried', 154.0000, 154.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (48, 4, N'DualIncomeMarried', 308.0000, 308.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (49, 1, N'MarriedWithMultipleEmployers', 71.0000, 71.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (50, 2, N'MarriedWithMultipleEmployers', 142.0000, 142.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (51, 3, N'MarriedWithMultipleEmployers', 154.0000, 154.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (52, 4, N'MarriedWithMultipleEmployers', 308.0000, 308.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (53, 1, N'Married ', 71.0000, 142.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (54, 2, N'Married ', 142.0000, 284.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (55, 3, N'Married ', 154.0000, 308.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (56, 4, N'Married ', 308.0000, 615.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (57, 1, N'Headofhousehold', 142.0000, 142.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (58, 2, N'Headofhousehold', 284.0000, 284.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (59, 3, N'Headofhousehold', 308.0000, 308.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (60, 4, N'Headofhousehold', 615.0000, 615.0000, 2009)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (61, 1, N'Single', 70.0000, 70.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (62, 2, N'Single', 140.0000, 140.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (63, 3, N'Single', 152.0000, 152.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (64, 4, N'Single', 303.0000, 303.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (65, 1, N'DualIncomeMarried', 70.0000, 70.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (66, 2, N'DualIncomeMarried', 140.0000, 140.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (67, 3, N'DualIncomeMarried', 152.0000, 152.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (68, 4, N'DualIncomeMarried', 303.0000, 303.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (69, 1, N'MarriedWithMultipleEmployers', 70.0000, 70.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (70, 2, N'MarriedWithMultipleEmployers', 140.0000, 140.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (71, 3, N'MarriedWithMultipleEmployers', 152.0000, 152.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (72, 4, N'MarriedWithMultipleEmployers', 303.0000, 303.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (73, 1, N'Married ', 70.0000, 140.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (74, 2, N'Married ', 140.0000, 280.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (75, 3, N'Married ', 152.0000, 303.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (76, 4, N'Married ', 303.0000, 606.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (77, 1, N'Headofhousehold', 140.0000, 140.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (78, 2, N'Headofhousehold', 280.0000, 280.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (79, 3, N'Headofhousehold', 303.0000, 303.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (80, 4, N'Headofhousehold', 606.0000, 606.0000, 2010)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (81, 1, N'Single', 71.0000, 71.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (82, 2, N'Single', 141.0000, 141.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (83, 3, N'Single', 153.0000, 153.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (84, 4, N'Single', 306.0000, 306.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (85, 1, N'DualIncomeMarried', 71.0000, 71.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (86, 2, N'DualIncomeMarried', 141.0000, 141.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (87, 3, N'DualIncomeMarried', 153.0000, 153.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (88, 4, N'DualIncomeMarried', 306.0000, 306.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (89, 1, N'MarriedWithMultipleEmployers', 71.0000, 71.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (90, 2, N'MarriedWithMultipleEmployers', 141.0000, 141.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (91, 3, N'MarriedWithMultipleEmployers', 153.0000, 153.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (92, 4, N'MarriedWithMultipleEmployers', 306.0000, 306.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (93, 1, N'Married ', 71.0000, 141.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (94, 2, N'Married ', 141.0000, 282.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (95, 3, N'Married ', 153.0000, 306.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (96, 4, N'Married ', 306.0000, 612.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (97, 1, N'Headofhousehold', 141.0000, 141.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (98, 2, N'Headofhousehold', 282.0000, 282.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (99, 3, N'Headofhousehold', 306.0000, 306.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (100, 4, N'Headofhousehold', 612.0000, 612.0000, 2011)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (101, 1, N'Single', 72.0000, 72.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (102, 2, N'Single', 145.0000, 145.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (103, 3, N'Single', 157.0000, 157.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (104, 4, N'Single', 314.0000, 314.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (105, 1, N'DualIncomeMarried', 72.0000, 72.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (106, 2, N'DualIncomeMarried', 145.0000, 145.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (107, 3, N'DualIncomeMarried', 157.0000, 157.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (108, 4, N'DualIncomeMarried', 314.0000, 314.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (109, 1, N'MarriedWithMultipleEmployers', 72.0000, 72.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (110, 2, N'MarriedWithMultipleEmployers', 145.0000, 145.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (111, 3, N'MarriedWithMultipleEmployers', 157.0000, 157.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (112, 4, N'MarriedWithMultipleEmployers', 314.0000, 314.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (113, 1, N'Married ', 72.0000, 145.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (114, 2, N'Married ', 145.0000, 290.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (115, 3, N'Married ', 157.0000, 314.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (116, 4, N'Married ', 314.0000, 628.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (117, 1, N'Headofhousehold', 145.0000, 145.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (118, 2, N'Headofhousehold', 290.0000, 290.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (119, 3, N'Headofhousehold', 314.0000, 314.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (120, 4, N'Headofhousehold', 628.0000, 628.0000, 2012)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (121, 1, N'Single', 68.0000, 68.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (122, 2, N'Single', 135.0000, 135.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (123, 3, N'Single', 147.0000, 147.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (124, 4, N'Single', 293.0000, 293.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (125, 1, N'DualIncomeMarried', 68.0000, 68.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (126, 2, N'DualIncomeMarried', 135.0000, 135.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (127, 3, N'DualIncomeMarried', 147.0000, 147.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (128, 4, N'DualIncomeMarried', 293.0000, 293.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (129, 1, N'MarriedWithMultipleEmployers', 68.0000, 68.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (130, 2, N'MarriedWithMultipleEmployers', 135.0000, 135.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (131, 3, N'MarriedWithMultipleEmployers', 147.0000, 147.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (132, 4, N'MarriedWithMultipleEmployers', 293.0000, 293.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (133, 1, N'Married ', 68.0000, 135.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (134, 2, N'Married ', 135.0000, 270.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (135, 3, N'Married ', 147.0000, 293.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (136, 4, N'Married ', 293.0000, 586.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (137, 1, N'Headofhousehold', 135.0000, 135.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (138, 2, N'Headofhousehold', 270.0000, 270.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (139, 3, N'Headofhousehold', 293.0000, 293.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (140, 4, N'Headofhousehold', 586.0000, 586.0000, 2013)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (141, 1, N'Single', 75.0000, 75.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (142, 2, N'Single', 150.0000, 150.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (143, 3, N'Single', 163.0000, 163.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (144, 4, N'Single', 326.0000, 326.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (145, 1, N'DualIncomeMarried', 75.0000, 75.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (146, 2, N'DualIncomeMarried', 150.0000, 150.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (147, 3, N'DualIncomeMarried', 163.0000, 163.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (148, 4, N'DualIncomeMarried', 326.0000, 326.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (149, 1, N'MarriedWithMultipleEmployers', 75.0000, 75.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (150, 2, N'MarriedWithMultipleEmployers', 150.0000, 150.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (151, 3, N'MarriedWithMultipleEmployers', 163.0000, 163.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (152, 4, N'MarriedWithMultipleEmployers', 326.0000, 326.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (153, 1, N'Married ', 75.0000, 150.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (154, 2, N'Married ', 150.0000, 300.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (155, 3, N'Married ', 163.0000, 326.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (156, 4, N'Married ', 326.0000, 651.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (157, 1, N'Headofhousehold', 150.0000, 150.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (158, 2, N'Headofhousehold', 300.0000, 300.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (159, 3, N'Headofhousehold', 326.0000, 326.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (160, 4, N'Headofhousehold', 651.0000, 651.0000, 2014)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (161, 1, N'Single', 77.0000, 77.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (162, 2, N'Single', 154.0000, 154.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (163, 3, N'Single', 166.0000, 166.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (164, 4, N'Single', 333.0000, 333.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (165, 1, N'DualIncomeMarried', 77.0000, 77.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (166, 2, N'DualIncomeMarried', 154.0000, 154.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (167, 3, N'DualIncomeMarried', 166.0000, 166.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (168, 4, N'DualIncomeMarried', 333.0000, 333.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (169, 1, N'MarriedWithMultipleEmployers', 77.0000, 77.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (170, 2, N'MarriedWithMultipleEmployers', 154.0000, 154.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (171, 3, N'MarriedWithMultipleEmployers', 166.0000, 166.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (172, 4, N'MarriedWithMultipleEmployers', 333.0000, 333.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (173, 1, N'Married ', 77.0000, 154.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (174, 2, N'Married ', 154.0000, 307.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (175, 3, N'Married ', 166.0000, 333.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (176, 4, N'Married ', 333.0000, 665.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (177, 1, N'Headofhousehold', 154.0000, 154.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (178, 2, N'Headofhousehold', 307.0000, 307.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (179, 3, N'Headofhousehold', 333.0000, 333.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (180, 4, N'Headofhousehold', 665.0000, 665.0000, 2015)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (181, 1, N'Single', 78.0000, 78.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (182, 2, N'Single', 156.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (183, 3, N'Single', 169.0000, 169.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (184, 4, N'Single', 337.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (185, 1, N'DualIncomeMarried', 78.0000, 78.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (186, 2, N'DualIncomeMarried', 156.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (187, 3, N'DualIncomeMarried', 169.0000, 169.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (188, 4, N'DualIncomeMarried', 337.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (189, 1, N'MarriedWithMultipleEmployers', 78.0000, 78.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (190, 2, N'MarriedWithMultipleEmployers', 156.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (191, 3, N'MarriedWithMultipleEmployers', 169.0000, 169.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (192, 4, N'MarriedWithMultipleEmployers', 337.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (193, 1, N'Married ', 78.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (194, 2, N'Married ', 156.0000, 311.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (195, 3, N'Married ', 169.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (196, 4, N'Married ', 337.0000, 674.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (197, 1, N'Headofhousehold', 156.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (198, 2, N'Headofhousehold', 311.0000, 311.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (199, 3, N'Headofhousehold', 337.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (200, 4, N'Headofhousehold', 674.0000, 674.0000, 2016)
GO
SET IDENTITY_INSERT [dbo].[StandardDeductionTable] OFF
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FIT', 6)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FIT', 7)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FIT', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'MD_Employer', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'MD_Employee', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SS_Employee', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SS_Employer', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FUTA', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'MD_Employee', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'MD_Employer', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SS_Employee', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SS_Employer', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FUTA', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SIT', 6)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SIT', 7)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SIT', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SDI', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SUI', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'ETT', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SDI', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SUI', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'ETT', 8)
GO
