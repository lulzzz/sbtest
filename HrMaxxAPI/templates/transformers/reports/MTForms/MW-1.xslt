<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../../reports/Utils.xslt" />
  
	<xsl:param name="periodEndDate"/>
  <xsl:param name="stateEin"/>
	
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
		
<xsl:output method="xml" indent="no"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>MW-1</Name>
		<Reports>
			<xsl:apply-templates select="Company"/>
			
		</Reports>
	</ReportTransformed>
</xsl:template>

<xsl:template match="Company">
	<xsl:variable name="fein1" select="FederalEIN"/>
  <xsl:variable name="TotalIncomeTax" select="translate(format-number(sum(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='MT-SIT']/YTD),'#####0.00'),'.','')"/>
	<Report>
		<TemplatePath>GovtForms\MTForms\</TemplatePath>
		<Template>MW-1.pdf</Template>
		<Fields>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'n1'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'a1'"/><xsl:with-param name="val1" select="translate(BusinessAddress/AddressLine1,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'a2'"/><xsl:with-param name="val1" select="translate(BusinessAddress/AddressLine2,$smallcase,$uppercase)"/></xsl:call-template>
      <xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'contact'"/><xsl:with-param name="val1" select="concat(../CompanyContact/FirstName, ' ', ../CompanyContact/LastName)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ph1'"/><xsl:with-param name="val1" select="substring(../CompanyContact/Phone, 1,3)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ph2'"/><xsl:with-param name="val1" select="substring(../CompanyContact/Phone,4,7)"/></xsl:call-template>
      <xsl:call-template name="eachLetter">
        <xsl:with-param name="startIndex" select="1"/>
        <xsl:with-param name="prefix" select="'f'"/>
        <xsl:with-param name="data" select="$fein1"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetter">
        <xsl:with-param name="startIndex" select="1"/>
        <xsl:with-param name="prefix" select="'d'"/>
        <xsl:with-param name="data" select="$periodEndDate"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetter">
        <xsl:with-param name="startIndex" select="1"/>
        <xsl:with-param name="prefix" select="'s'"/>
        <xsl:with-param name="data" select="$stateEin"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetterReverse">
        <xsl:with-param name="startIndex" select="8"/>
        <xsl:with-param name="prefix" select="'am'"/>
        <xsl:with-param name="data" select="$TotalIncomeTax"/>
      </xsl:call-template>
		</Fields>
	</Report>
</xsl:template>

</xsl:stylesheet>