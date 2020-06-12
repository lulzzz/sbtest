<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:math="http://exslt.org/math" exclude-result-prefixes="msxsl"
    
>
	<xsl:import href="../reports/Utils.xslt" />
	
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:param name="timesheets"/>
	<xsl:output method="xml" indent="yes"/>
  <xsl:variable name="employeeCount" select="count(/CertifiedPayroll/Payroll/PayChecks/PayCheck)"/>
	<xsl:variable name="pages" select="ceiling($employeeCount div 4)"/>
  <xsl:variable name="project" select="/CertifiedPayroll/Payroll/Project"/>
  <xsl:template match="CertifiedPayroll">
		<ReportTransformed>
			<Name>CertifiedReport</Name>
			<Reports>
				<xsl:call-template name="Page">
					<xsl:with-param name="currPage" select="'1'"/>
					<xsl:with-param name="totalPages" select="$pages"/>
					<xsl:with-param name="payroll" select="Payroll"/>
          
          
	
				</xsl:call-template>
      <Report>
				<TemplatePath>Payroll\</TemplatePath>
		<Template>CertifiedReportPage2.pdf</Template>
				<Fields>
				</Fields>
			</Report>
			</Reports>
		</ReportTransformed>
	</xsl:template>
<xsl:template name="Page">
	<xsl:param name="currPage"/>
	<xsl:param name="totalPages"/>
	<xsl:param name="payroll"/>
  
	
	<Report>
		<TemplatePath>Payroll\</TemplatePath>
		<Template>CertifiedReport.pdf</Template>
		<Fields>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'page'"/><xsl:with-param name="val1" select="$currPage"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'pages'"/><xsl:with-param name="val1" select="$totalPages"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'companyname'"/><xsl:with-param name="val1" select="$payroll/Company/TaxFilingName"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'license'"/><xsl:with-param name="val1" select="$project/LicenseNo"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'address'"/><xsl:with-param name="val1" select="$payroll/Company/BusinessAddress/AddressLine1"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'enddate'"/><xsl:with-param name="val1" select="msxsl:format-date($payroll/EndDate, 'MM/dd/yyyy')"/></xsl:call-template>
      <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'registrationno'"/><xsl:with-param name="val1" select="$project/RegistrationNo"/></xsl:call-template>
      <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'wcpolicy'"/><xsl:with-param name="val1" select="$project/PolicyNo"/></xsl:call-template>
      <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'payrollno'"/><xsl:with-param name="val1" select="/CertifiedPayroll/Payroll/PayrollNo"/></xsl:call-template>
			
			
			<xsl:variable name="start" select="4*($currPage - 1)"/>
			<xsl:variable name="end">
				<xsl:choose>
					<xsl:when test="$employeeCount>($start+4)"><xsl:value-of select="$start+5"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$employeeCount+1"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:apply-templates select="$payroll/PayChecks/PayCheck[position()>$start and position() &lt; $end]">
				<xsl:with-param name="currPage" select="$currPage"/>
			</xsl:apply-templates>
			
			
		</Fields>
	</Report>
	<xsl:if test="$totalPages>$currPage">
		<xsl:call-template name="Page">
			<xsl:with-param name="currPage" select="$currPage+1"/>
			<xsl:with-param name="totalPages" select="$totalPages"/>
			<xsl:with-param name="payroll" select="$payroll"/>		
    
		</xsl:call-template>
	</xsl:if>
	
</xsl:template>
	<xsl:template match="PayCheck">
	<xsl:param name="currPage"/>
   <xsl:variable name ="pos" select="position()"/>
   <xsl:variable name ="bpc" select="PayCodes/PayrollPayCode[PayCode/Id=0]"/>
		<xsl:variable name="emp" select ="Employee/Id"/>
	<xsl:variable name="ssn" select="concat(substring(Employee/SSN,1,3),'-',substring(Employee/SSN,4,2),'-',substring(Employee/SSN,6,4))"/>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('emp-', $pos)"/><xsl:with-param name="val1" select="concat(Employee/FirstName, ' ', Employee/LastName, '\n', $ssn, '\n', Employee/Contact/Address/AddressLine1, '\n', Employee/Contact/Address/AddressLine2)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('exemptions-', $pos)"/><xsl:with-param name="val1" select="Employee/FederalExemptions"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('classification-', $pos)"/><xsl:with-param name="val1" select="Employee/WorkClassification"/></xsl:call-template>
  <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('hours-', $pos)"/><xsl:with-param name="val1" select="format-number($bpc/Hours, '#.00')"/></xsl:call-template>
  <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('overtime-', $pos)"/><xsl:with-param name="val1" select="format-number($bpc/OvertimeHours, '#.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('hourlyrate-', $pos)"/><xsl:with-param name="val1" select="format-number($bpc/PayCode/HourlyRate, '#.00')"/></xsl:call-template>
  <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('overtimerate-', $pos)"/><xsl:with-param name="val1" select="format-number($bpc/PayCode/HourlyRate * 1.5, '#.00')"/></xsl:call-template>
  <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('grossproject-', $pos)"/><xsl:with-param name="val1" select="format-number(GrossWage, '#.00')"/></xsl:call-template>
  <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('netwage-', $pos)"/><xsl:with-param name="val1" select="format-number(NetWage, '#.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('checkno-', $pos)"/><xsl:with-param name="val1" select="format-number(CheckNumber, '#')"/></xsl:call-template>
  <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('ded-', $pos)"/><xsl:with-param name="val1" select="format-number(sum(Deductions/Amount), '0.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('fit-', $pos)"/><xsl:with-param name="val1" select="format-number(sum(Taxes/PayrollTax[Tax/Code='FIT']/Amount), '0.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('sit-', $pos)"/><xsl:with-param name="val1" select="format-number(sum(Taxes/PayrollTax[Tax/Code='SIT']/Amount), '0.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('sdi-', $pos)"/><xsl:with-param name="val1" select="format-number(sum(Taxes/PayrollTax[Tax/Code='SDI']/Amount), '0.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('ss-', $pos)"/><xsl:with-param name="val1" select="format-number(sum(Taxes/PayrollTax[Tax/Code='SS_Employee']/Amount), '0.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('ett-', $pos)"/><xsl:with-param name="val1" select="format-number(sum(Taxes/PayrollTax[Tax/Code='ETT']/Amount), '0.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('vac-', $pos)"/><xsl:with-param name="val1" select="format-number(sum(PayTypes/PayrollPayType[PayType/Id=5]/Amount), '0.00')"/></xsl:call-template>
    <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('other-', $pos)"/><xsl:with-param name="val1" select="format-number(sum(PayTypes/PayrollPayType[PayType/Id!=5]/Amount), '0.00')"/></xsl:call-template>
    <xsl:for-each select="//CertifiedPayroll/Timesheets/TimesheetEntry[EmployeeId=$emp]">
      
      <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('e-', $pos, '-', Day)"/><xsl:with-param name="val1" select="Hours"/></xsl:call-template>
      <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('o-', $pos, '-', Day)"/><xsl:with-param name="val1" select="Overtime"/></xsl:call-template>
    
    </xsl:for-each>
	
</xsl:template>

</xsl:stylesheet>