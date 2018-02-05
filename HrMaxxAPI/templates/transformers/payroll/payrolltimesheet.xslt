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
					<Template>PayrollTimesheet-<xsl:value-of select="Id"/>
				</Template>
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
							<td colspan="3" style="text-align:center">
								<h4>
									Time Sheet
								</h4>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<br/>
							</td>
						</tr>
						<tr>
							<td width="20%" style="text-align:left">
								<h5>
									Company No: <xsl:value-of select="$payroll/Company/CompanyNo"/>
								</h5>
							</td>
							<td width="50%" style="text-align:center">
								<h5><xsl:value-of select="$payroll/Company/Name"/>
								</h5>
							</td>
							<td width="30%" style="text-align:right">
								<xsl:value-of select="concat('From: ','___/___/______', '  To: ','___/___/______')"/>
							</td>
						</tr>
					</table>
					<br/>
					<table style="font-size:10pt; width:100%; border-collapse:collapse;" class="border" >
						<thead>
							<tr style="height:25px">
								<th colspan="2">
									Payroll Before: <xsl:value-of select="msxsl:format-date($payroll/StartDate, 'MM/dd/yyyy')"/> - <xsl:value-of select="msxsl:format-date($payroll/EndDate, 'MM/dd/yyyy')"/>
								</th>
								<th colspan="2">P/Rate</th>
								<th >&#160;</th>
								<th >&#160;</th>
								<th >&#160;</th>

								<th>&#160;</th>
								<th >&#160;</th>
								<th >&#160;</th>
								<th >&#160;</th>
							</tr>
							<tr style="height:25px">
								<th style="width:5%">Emp#</th>
								<th style="width:15%">Name</th>
								<th style="width:10%">Before</th>
								<th style="width:10%">New Rate</th>
								<th style="width:10%">Hours</th>
								<th style="width:10%">Overtime</th>
								<th style="width:5%">Double</th>
								<th style="width:5%">Others</th>
								<th style="width:10%">Salary</th>
								<th style="width:10%">P/W Amt</th>
								<th style="width:10%">Total</th>
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
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</tbody>
					</table>
					<br/>
					<h5>
						No. of Employees: <xsl:value-of select="count(PayChecks/PayCheck[IsVoid='false'])"/>
					</h5>

				</div>
			</body>
			
			
		</html>
	</xsl:template>
	<xsl:template match="PayCheck">
		<tr style="height:25px">
			<td >
				<xsl:value-of select="Employee/CompanyEmployeeNo"/>
			</td>
			<td >
				<xsl:value-of select="concat(Employee/FirstName,' ',Employee/MiddleInitial, ' ', Employee/LastName)"/>
			</td>
			<td >
				$<xsl:value-of select="format-number(Employee/Rate,'#,##0.00')"/>
			</td>
			<td >&#160;</td>
			<td >&#160;</td>
			<td >&#160;</td>
			<td >&#160;</td>
			<td >&#160;</td>
			<td >&#160;</td>
			<td >&#160;</td>
			<td >&#160;</td>
		</tr>
		
		
	</xsl:template>
	
</xsl:stylesheet>