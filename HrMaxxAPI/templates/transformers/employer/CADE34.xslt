<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../reports/Utils.xslt" />
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:variable name="fein" select="concat('EIN# ',substring(/ReportResponse/Company/FederalEIN,1,2),'-',substring(/ReportResponse/Company/FederalEIN,3,7))"/>
	<xsl:variable name="sein" select="concat('EDD# ',substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>
	<xsl:variable name="empCount" select="count(/ReportResponse/Employees/Employee)"/>
<xsl:output method="xml" indent="no"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledFormI9</Name>
		<Reports>
			<xsl:call-template name="Report">
				<xsl:with-param name="page" select="1"/>
			</xsl:call-template>
		</Reports>
	</ReportTransformed>
</xsl:template>

<xsl:template match="Company">
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'compName'"/>
		<xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'compName1'"/>
		<xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'compAddress'"/>
		<xsl:with-param name="val1" select="translate(BusinessAddress/AddressLine1,$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'city'"/>
		<xsl:with-param name="val1" select="translate(concat(BusinessAddress/City,', ','CA',' ', BusinessAddress/Zip),$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'compAddress1'"/>
		<xsl:with-param name="val1" select="translate(concat(BusinessAddress/AddressLine1, ', ',BusinessAddress/City,', ','CA',' ', BusinessAddress/Zip),$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'edd'"/>
		<xsl:with-param name="val1" select="translate($sein,$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'fein'"/>
		<xsl:with-param name="val1" select="translate($fein,$smallcase,$uppercase)"/>
	</xsl:call-template>
</xsl:template>
<xsl:template match="Employee">
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('empName',position())"/><xsl:with-param name="val1" select="translate(concat(FirstName,' ', LastName),$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('empSSN', position())"/><xsl:with-param name="val1" select="concat(substring(SSN, 1, 3),'-',substring(SSN,4,2),'-',substring(SSN,6,4))"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('empAddress', position())"/><xsl:with-param name="val1" select="concat(Contact/Address/AddressLine1,', ',Contact/Address/City,', ','CA',', ',Contact/Address/Zip)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat('empHireDate', position())"/><xsl:with-param name="val1" select="msxsl:format-date(HireDate, 'MM/dd/yyyy')"/></xsl:call-template>
			
</xsl:template>
<xsl:template name="Report">
	<xsl:param name="page"/>
	<Report>
		<TemplatePath>GovtForms\EmployerForms\</TemplatePath>
		<Template>DE34.pdf</Template>
		<Fields>
			<xsl:apply-templates select="Company"/>
			<xsl:apply-templates select="Employees/Employee[position()>(($page - 1)*16) and position() &lt; ($page*16 + 1)]"/>
		</Fields>
	</Report>
	<xsl:if test="$empCount>($page*16)">
		<xsl:call-template name="Report">
			<xsl:with-param name="page" select="$page+1"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>