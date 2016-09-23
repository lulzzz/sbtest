<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../reports/Utils.xslt" />
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:variable name="compDetails" select="translate(concat(/ReportResponse/Company/TaxFilingName, ':' ,/ReportResponse/Company/BusinessAddress/AddressLine1,' ',/ReportResponse/Company/BusinessAddress/City,', ','CA',', ',/ReportResponse/Company/BusinessAddress/Zip),$smallcase,$uppercase)"/>
	
<xsl:output method="xml" indent="no"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledFormW4</Name>
		<Reports>
			<xsl:apply-templates select="Employees/Employee"/>
			<Report>
				<TemplatePath>GovtForms\EmployerForms\</TemplatePath>
				<Template>fw4-page2.pdf</Template>
				<Fields>
				</Fields>
			</Report>
		</Reports>
	</ReportTransformed>
</xsl:template>

<xsl:template match="Employee">
	<Report>
		<TemplatePath>GovtForms\EmployerForms\</TemplatePath>
		<Template>fw4-page1.pdf</Template>
		<Fields>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_09(0)'"/><xsl:with-param name="val1" select="translate(FirstName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_10(0)'"/><xsl:with-param name="val1" select="translate(LastName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_11(0)'"/><xsl:with-param name="val1" select="substring(ssn, 1,3)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_12(0)'"/><xsl:with-param name="val1" select="substring(ssn, 4,2)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_13(0)'"/><xsl:with-param name="val1" select="substring(ssn, 6,4)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f1_14(0)'"/>
				<xsl:with-param name="val1" select="Contact/Address/AddressLine1"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f1_15(0)'"/>
				<xsl:with-param name="val1" select="concat(Contact/Address/City,', ','CA',' ',Contact/Address/Zip)"/>
			</xsl:call-template>
			<xsl:if test="FederalStatus='Single'">
				<xsl:call-template name="CheckTemplate">
					<xsl:with-param name="name1" select="'c1_01(0)'"/>
					<xsl:with-param name="val1" select="'On'"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="FederalStatus='Married'">
				<xsl:call-template name="CheckTemplate">
					<xsl:with-param name="name1" select="'c1_02(0)'"/>
					<xsl:with-param name="val1" select="'On'"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="FederalStatus='UnmarriedHeadofHousehold'">
				<xsl:call-template name="CheckTemplate">
					<xsl:with-param name="name1" select="'c1_03(0)'"/>
					<xsl:with-param name="val1" select="'On'"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f1_16(0)'"/>
				<xsl:with-param name="val1" select="FederalExemptions"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f1_17(0)'"/>
				<xsl:with-param name="val1" select="format-number(FederalAdditionalAmount, '#,##0.00')"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f1_19(0)'"/>
				<xsl:with-param name="val1" select="$compDetails"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f1_21(0)'"/>
				<xsl:with-param name="val1" select="substring(../Company/FederalEIN,1,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f1_22(0)'"/>
				<xsl:with-param name="val1" select="substring(../Company/FederalEIN,3,7)"/>
			</xsl:call-template>
		</Fields>
	</Report>
</xsl:template>

</xsl:stylesheet>