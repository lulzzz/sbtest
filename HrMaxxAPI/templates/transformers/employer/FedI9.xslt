<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../reports/Utils.xslt" />
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:variable name="compDetails" select="translate(concat(/ReportResponse/Company/TaxFilingName, ', ' ,/ReportResponse/Company/BusinessAddress/AddressLine1,' ',/ReportResponse/Company/BusinessAddress/City,', ',/ReportResponse/Company/BusinessAddress/StateCode,', ',/ReportResponse/Company/BusinessAddress/Zip),$smallcase,$uppercase)"/>
	
<xsl:output method="xml" indent="no"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledFormI9</Name>
		<Reports>
			<xsl:apply-templates select="Employees/Employee"/>
			
		</Reports>
	</ReportTransformed>
</xsl:template>

<xsl:template match="Employee">
	<Report>
		<TemplatePath>GovtForms\EmployerForms\</TemplatePath>
		<Template>I9.pdf</Template>
		<Fields>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'firstname'"/><xsl:with-param name="val1" select="translate(FirstName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'lastname'"/><xsl:with-param name="val1" select="translate(LastName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'mi'"/><xsl:with-param name="val1" select="translate(MiddleInitial,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'address'"/><xsl:with-param name="val1" select="Contact/Address/AddressLine1"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'city'"/><xsl:with-param name="val1" select="Contact/Address/City"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'state'"/><xsl:with-param name="val1" select="Contact/Address/StateCode"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'zip'"/><xsl:with-param name="val1" select="Contact/Address/Zip"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'dob'"/><xsl:with-param name="val1" select="msxsl:format-date(BirthDate, 'MM/dd/yyyy')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ssn'"/><xsl:with-param name="val1" select="concat(substring(SSN,1,3),'-',substring(SSN,4,2),'-',substring(SSN,6,10))"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compAdd'"/><xsl:with-param name="val1" select="$compDetails"/></xsl:call-template>
			
		</Fields>
	</Report>
</xsl:template>

</xsl:stylesheet>