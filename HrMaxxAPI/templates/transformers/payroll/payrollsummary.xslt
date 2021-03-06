<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:math="http://exslt.org/math" exclude-result-prefixes="msxsl"
    
>
	<xsl:import href="../reports/Utils.xslt" />
	
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:output method="xml" indent="no"/>
	<xsl:template match="Payroll">
		<ReportTransformed>
			<Name><xsl:value-of select="concat(Id,'.pdf')"/></Name>
			<Reports>
				<Report>
					<TemplatePath></TemplatePath>
					<Template>PayrollSummary</Template>
					<ReportType>Html</ReportType>
					<HtmlData>
						<xsl:call-template name="test">
							<xsl:with-param name="payroll" select="."/>
						</xsl:call-template>
						
					</HtmlData>

				</Report>
				
			</Reports>
		</ReportTransformed>
	</xsl:template>
	<xsl:template name="test">
		<xsl:param name="payroll"/>
		<html>
			<head>
				<style>
					table.border tr td {
					border:1px solid gray;
					}
					table.border tr th {
					border:1px solid gray;
					}
					table.noborder tr td {
					border:0!important;
					}
					table.noborder tr th {
					border:0!important;
					}
				</style>
			</head>
			<body>
				<div style="width:99%;" >
					<table style="font-size:8pt; width:100%">
						<tr>
							<td width="70%">
								<b>
									<xsl:value-of select="$payroll/Company/Name"/>
								</b>
							</td>
							<td width="30%">
								Pay Date: <xsl:value-of select="msxsl:format-date($payroll/PayDay, 'MM/dd/yyyy')"/>
							</td>
						</tr>
						<xsl:if test="$payroll/InvoiceId">
							<tr>
								<td></td>
								<td>
									Invoice #: <xsl:value-of select="$payroll/InvoiceNumber"/>
								</td>

							</tr>
						</xsl:if>
						<tr>
							<td></td>
							<td><xsl:value-of select="msxsl:format-date($payroll/StartDate, 'MM/dd/yyyy')"/> - <xsl:value-of select="msxsl:format-date($payroll/EndDate, 'MM/dd/yyyy')"/>
							</td>
							
						</tr>
						<tr>
							<td>Notes:</td>
							<td>
								<xsl:value-of select="$payroll/Notes"/>
							</td>
						</tr>
					</table>
					<table style="font-size:9pt; width:100%; border-collapse:collapse;" class="border" >
						<thead>
							<tr >
								<th style="width:15%">Employee</th>
								<th style="width:10%">Wage(s)</th>
								<th style="width:10%">Amount</th>
								<th style="width:10%">YTD</th>
								<th style="width:25%">PayCode(s)</th>
								
								<th style="width:20%">Tax/Deductions</th>
								<th style="width:10%">Amount</th>
								<th style="width:10%">YTD</th>
								
							</tr>
							
						</thead>
						<tbody>
							<xsl:choose>
								<xsl:when test="Company/CompanyCheckPrintOrder='CompanyEmployeeNo'">
									<xsl:apply-templates select="PayChecks/PayCheck[IsVoid='false']">
										<xsl:sort select="Employee/CompanyEmployeeNo" data-type="number"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="PayChecks/PayCheck[IsVoid='false']">
										<xsl:sort select="Employee/LastName" data-type="text"/>
										<xsl:sort select="Employee/FirstName" data-type="text"/>
										<xsl:sort select="Employee/MiddleInitial" data-type="text"/>
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
							
						</tbody>
					</table>

					<br/>
					<br/>
					<table style="font-size:9pt; width:100%;border-collapse:collapse" class="border">
						<tbody>
							<tr>
								<th style="width:25%">No. Checks</th>
								<th style="width:25%">Total Gross Pay</th>
								<th style="width:25%">Total Deductions</th>
								<th style="width:25%">Total Taxes EE</th>
								<th style="width:25%">Total Net Pay</th>
							</tr>
							

							<tr>
								<td style="text-align:right">
									<xsl:value-of select="count(PayChecks/PayCheck[IsVoid='false'])"/>
								</td>
								<td style="text-align:right">
									$<xsl:value-of select="format-number(sum(PayChecks/PayCheck[IsVoid='false']/GrossWage),'#,##0.00')"/>
								</td>
								<td style="text-align:right">
									$<xsl:value-of select="format-number(sum(PayChecks/PayCheck[IsVoid='false']/Deductions/PayrollDeduction/Amount),'#,##0.00')"/>
								</td>
								<td style="text-align:right">
									$<xsl:value-of select="format-number(sum(PayChecks/PayCheck[IsVoid='false']/Taxes/PayrollTax[Tax/IsEmployeeTax='true']/Amount),'#,##0.00')"/>
								</td>
								<td style="text-align:right">
									$<xsl:value-of select="format-number(sum(PayChecks/PayCheck[IsVoid='false']/NetWage),'#,##0.00')"/>
								</td>
								

							</tr>



						</tbody>
					</table>
					

				</div>
			</body>
			
			
		</html>
	</xsl:template>
	<xsl:template match="PayrollTax">
		<tr>
			<td style="width:50%; text-align:left;">
				<xsl:value-of select="Tax/Name"/>
			</td>
			<td style="width:25%; text-align:right;">
				$<xsl:value-of select="format-number(Amount,'#,##0.00')"/>
			</td>
			<td style="width:30%; text-align:right;">
				$<xsl:value-of select="format-number(YTDTax,'#,##0.00')"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="PayrollPayType">
		<tr>
			<td style="width:33%; text-align:left;">
				<xsl:value-of select="PayType/Name"/>
			</td>
			<td style="width:33%; text-align:right;">
				$<xsl:value-of select="format-number(Amount,'#,##0.00')"/>
			</td>
			<td style="width:33%; text-align:right;">
				$<xsl:value-of select="format-number(YTD,'#,##0.00')"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="PayrollDeduction">
		<tr>
			<td style="width:45%; text-align:left;">
				<xsl:value-of select="Deduction/DeductionName"/>
			</td>
			<td style="width:25%; text-align:right;">
				$<xsl:value-of select="format-number(Amount,'#,##0.00')"/>
			</td>
			<td style="width:25%; text-align:right;">
				$<xsl:value-of select="format-number(YTD,'#,##0.00')"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="PayrollPayCode">
		<tr>
			<td style="width:40%;">
				<xsl:value-of select="PayCode/Description"/> ($<xsl:value-of select="format-number(PayCode/HourlyRate,'#,##0.00')"/>)
			</td>
			<td style="width:20%; text-align:center">
				<xsl:value-of select="format-number(Hours,'#,##0.00')"/>
			</td>
			<td style="width:20%; text-align:center">
				<xsl:value-of select="format-number(OvertimeHours,'#,##0.00')"/>
			</td>
			<td style="width:20%; text-align:center">
				$<xsl:value-of select="format-number(Amount + OvertimeAmount,'#,##0.00')"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="PayCheck">
		<tr>
			<td valign="top">
				<table style="font-size:8px;width:100%" class="noborder">
					<tr>
						<td style="width:100%;text-align:center;">
							<strong>
								<xsl:choose>
								<xsl:when test="Company/CompanyCheckPrintOrder='CompanyEmployeeNo'">
									<xsl:value-of select="concat(Employee/FirstName,' ',Employee/MiddleInitial, ' ', Employee/LastName)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat(Employee/LastName,', ',Employee/FirstName, ' ', Employee/MiddleInitial)"/>
								</xsl:otherwise>
								</xsl:choose>
							</strong>
						</td>
					</tr>
					<tr>
						<td style="width:50%; text-align:left;">
							<strong>Employee #:</strong>
						</td>
						<td style="width:50%; text-align:right;">
							<xsl:value-of select="Employee/CompanyEmployeeNo"/>
						</td>
					</tr>
					<tr>
						<td style="width:50%; text-align:left;">
							<strong>SSN:</strong>
						</td>
						<td style="width:50%; text-align:right;">
							<xsl:value-of select="concat('***-**-',substring(Employee/SSN,6,4))"/>
						</td>
					</tr>
					<tr>
						<td style="width:50%; text-align:left;">
							Check#
						</td>
						<td style="width:50%; text-align:right;">
							<xsl:choose>
								<xsl:when test="PaymentMethod='Check'">
									<xsl:value-of select="CheckNumber"/>
								</xsl:when>
								<xsl:otherwise>EFT</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td style="width:50%; text-align:left;">
							<strong>Pay Rate:</strong>
						</td>
						<td style="width:50%; text-align:right;">
							$<xsl:value-of select="format-number(Employee/Rate,'#,##0.00')"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:if test="Notes.length>0">
								<span style="width:100%">
									<xsl:value-of select="Notes[0]"/>
								</span>
							</xsl:if>
						</td>
						
							
							
					</tr>
					<xsl:if test="Accumulations/PayTypeAccumulation[PayType/CompanyManaged='false']">
						<tr>
							<td>
								<strong>Accruals:</strong>	
							</td>
						</tr>
						<xsl:for-each select="Accumulations/PayTypeAccumulation[PayType/CompanyManaged='false']">
								<tr>
										<td style="width:40%; text-align:left;">
											<pre><u>
												- <xsl:value-of select="PayType/PayType/Name"/>:
											</u>
											</pre>
										</td>
										<td style="width:0%; text-align:right;">
											<xsl:value-of select="AccumulatedValue"/> (YTD: <xsl:value-of select="YTDFiscal"/>)
										</td>
									</tr>
									<tr>
										<td style="width:40%; text-align:left;">
											<pre>
												<pre>
													<i>--Used:</i>
												</pre>
											</pre>
											
										</td>
										<td style="width:60%; text-align:right;">
											<xsl:value-of select="Used"/> (YTD: <xsl:value-of select="YTDUsed"/>)
										</td>
									</tr>
									<tr>
										<td style="width:50%; text-align:left;">
											<i>--C/O</i>
										</td>
										<td style="width:50%; text-align:right;">
											<xsl:value-of select="CarryOver"/>
										</td>
									</tr>
									<tr>
										<td style="width:50%; text-align:left;">
											<i>--Avail</i>
										</td>
										<td style="width:50%; text-align:right;">
											<xsl:value-of select="format-number(YTDFiscal + CarryOver - YTDUsed, '###.00')"/>
										</td>
									</tr>
								
						</xsl:for-each>
					</xsl:if>	
					
				</table>
			</td>
			<td colspan="3" valign="top">
				<table style="font-size:8px;width:100%" class="noborder">
					<tr>
						<td style="width:33%; text-align:left;">
							Gross Wage
						</td>
						<td style="width:33%; text-align:right;">
							$<xsl:value-of select="format-number(GrossWage,'#,##0.00')"/>
						</td>
						<td style="width:33%; text-align:right;">
							$<xsl:value-of select="format-number(YTDGrossWage,'#,##0.00')"/>
						</td>
					</tr>
					<tr>
						<td style="width:33%; text-align:left;">
							Salary
						</td>
						<td style="width:33%; text-align:right;">
							$<xsl:choose>
								<xsl:when test="Employee/PayType='JobCost'">
									<xsl:value-of select="format-number(GrossWage,'#,##0.00')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number(Salary,'#,##0.00')"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td style="width:33%; text-align:right;">
							$<xsl:choose>
							<xsl:when test="Employee/PayType='JobCost'">
								<xsl:value-of select="format-number(YTDGrossWage,'#,##0.00')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(YTDSalary,'#,##0.00')"/>
							</xsl:otherwise>
						</xsl:choose>
						</td>
					</tr>
					<tr>
						<td style="width:33%; text-align:left;">
							Net Wage
						</td>
						<td style="width:40%; text-align:right;">
							$<xsl:value-of select="format-number(NetWage,'#,##0.00')"/>
						</td>
						<td style="width:40%; text-align:right;">
							$<xsl:value-of select="format-number(YTDNetWage,'#,##0.00')"/>
						</td>
					</tr>
					<xsl:apply-templates select="Compensations/PayrollPayType"/>
				</table>
			
				
			</td>
			<td valign="top">
				<xsl:if test="Employee/PayType='Hourly' or Employee/PayType='PieceWork'">
					<table style="font-size:8px;width:100%" class="noborder">
						<thead>
							<tr>
								<th>Pay Code</th>
								<th>Hours</th>
								<th>Overtime</th>
								<th>Amount</th>
							</tr>
						</thead>
						<xsl:apply-templates select="PayCodes/PayrollPayCode"/>
						<xsl:choose>
							<xsl:when test="Notes">
								<tr>
									<td colspan="4">
										<xsl:value-of select="Notes"/>
									</td>
								</tr>
							</xsl:when>
						</xsl:choose>
					</table>
				</xsl:if>
				
			</td>
			<td colspan="3" valign="top">
				<table style="font-size:8px;width:100%" class="noborder">
					<xsl:apply-templates select="Taxes/PayrollTax[Tax/IsEmployeeTax='true']"/>
					<xsl:apply-templates select="Deductions/PayrollDeduction"/>
					
				</table>

			</td>
			
		
		</tr>
		
	</xsl:template>
	
</xsl:stylesheet>