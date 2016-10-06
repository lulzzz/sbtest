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
			<body>
				<div style="width:95%" >
					<table style="font-size:8pt; width:100%">
						<tr>
							<td>Pay Period Start Date: <xsl:value-of select="msxsl:format-date($payroll/StartDate, 'MM/dd/yyyy')"/>
						</td>
							<td></td>
						</tr>
						<tr>
							<td>Pay Period End Date: <xsl:value-of select="msxsl:format-date($payroll/EndDate, 'MM/dd/yyyy')"/>
						</td>
							<td></td>
						</tr>
						<tr>
							<td>Check Date:<xsl:value-of select="msxsl:format-date($payroll/PayDay, 'MM/dd/yyyy')"/>
						</td>
							<td></td>
						</tr>
						<tr>
							<td>Starting Check Number: <xsl:value-of select="$payroll/StartingCheckNumber"/></td>
							<td></td>
						</tr>
						<tr>
							<td>Notes:</td>
							<td>
								<xsl:value-of select="$payroll/Notes"/>
							</td>
						</tr>
					</table>

					<table style="font-size:9pt; width:100%;">
						<tbody>
							<tr>
								<th style="width:20%">Employee</th>
								<th style="width:10%">Gross Pay</th>
								<th style="width:10%">Deductions</th>
								<th style="width:10%">Taxes EE</th>
								<th style="width:10%">Taxes ER</th>
								<th style="width:10%">Net Pay</th>
								<th style="width:10%">Total Cost</th>
								<th style="width:20%">Payment Method</th>

							</tr>
							<xsl:apply-templates select="PayChecks/PayCheck"/>

							<tr>
								<td style="width:20%" align="right">
									Total
								</td>
								<td style="width:10%;" align="right">
									<xsl:value-of select="format-number(sum(PayChecks/PayCheck/GrossWage),'#,##0.00')"/>
								</td>
								<td style="width:10%" align="right">
									<xsl:value-of select="format-number(sum(PayChecks/PayCheck/Deductions/PayrollDeduction/Amount),'#,##0.00')"/>
								</td>
								<td style="width:10%" align="right">
									<xsl:value-of select="format-number(sum(PayChecks/PayCheck/Taxes/PayrollTax[Tax/IsEmployeeTax='true']/Amount),'#,##0.00')"/>
								</td>
								<td style="width:10%" align="right">
									<xsl:value-of select="format-number(sum(PayChecks/PayCheck/Taxes/PayrollTax[Tax/IsEmployeeTax='false']/Amount),'#,##0.00')"/>
								</td>
								<td style="width:10%" align="right">
									<xsl:value-of select="format-number(sum(PayChecks/PayCheck/NetWage),'#,##0.00')"/>
								</td>
								<td style="width:10%" align="right">
									<xsl:value-of select="format-number(sum(PayChecks/PayCheck/GrossWage) - sum(PayChecks/PayCheck/Taxes/PayrollTax[Tax/IsEmployeeTax='false']/Amount),'#,##0.00')"/>
								</td>
								<td style="width:20%">
									
								</td>

							</tr>
							


						</tbody>
					</table>
					

				</div>
			</body>
			
			
		</html>
	</xsl:template>
	<xsl:template match="PayCheck">
		<tr>
			<td style="width:20%">
				<xsl:value-of select="concat(Employee/FirstName,' ',Employee/MiddleInitial, ' ', Employee/LastName)"/>
			</td>
			<td style="width:10%;" align="right">
				<xsl:value-of select="format-number(GrossWage,'#,##0.00')"/>
			</td>
			<td style="width:10%" align="right">
				<xsl:value-of select="format-number(sum(Deductions/PayrollDeduction/Amount),'#,##0.00')"/>
			</td>
			<td style="width:10%" align="right">
				<xsl:value-of select="format-number(sum(Taxes/PayrollTax[Tax/IsEmployeeTax='true']/Amount),'#,##0.00')"/>
			</td>
			<td style="width:10%" align="right">
				<xsl:value-of select="format-number(sum(Taxes/PayrollTax[Tax/IsEmployeeTax='false']/Amount),'#,##0.00')"/>
			</td>
			<td style="width:10%" align="right">
				<xsl:value-of select="format-number(NetWage,'#,##0.00')"/>
			</td>
			<td style="width:10%" align="right">
				<xsl:value-of select="format-number(GrossWage - sum(Taxes/PayrollTax[Tax/IsEmployeeTax='false']/Amount),'#,##0.00')"/>
			</td>
			<td style="width:20%" align="right">
				<xsl:choose>
					<xsl:when test="PaymentMethod=1">Check</xsl:when>
					<xsl:otherwise>EFT</xsl:otherwise>
				</xsl:choose>
			</td>

		</tr>
	</xsl:template>
	
</xsl:stylesheet>