<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
	
  <xsl:param name="enddate"/>
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:variable name="sein" select="translate(concat('WH',/ReportResponse/Company/States/CompanyTaxState[State/StateId=10]/StateEIN), $smallcase, $uppercase)"/>

	<xsl:variable name="SITTax" select="translate(format-number(sum(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='HI-SIT']/YTD),'########0.00'),'.','')"/>
	
<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="ReportResponse">
		<ReportTransformed>
			<Name>FilledFormHI-VP1</Name>
			<Reports>
				<xsl:apply-templates select="Company"/>
			</Reports>
		</ReportTransformed>
	</xsl:template>

<xsl:template match="Company">	
	<Report>
		<TemplatePath>GovtForms\HIForms\</TemplatePath>
		<Template>VP1.pdf</Template>
		<Fields>
			
			<xsl:call-template name="eachLetter">
        <xsl:with-param name="startIndex" select="1"/>
        <xsl:with-param name="prefix" select="'fsn-'"/>
        <xsl:with-param name="data" select="$sein"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetterReverse">
        <xsl:with-param name="startIndex" select="11"/>
        <xsl:with-param name="prefix" select="'tp-'"/>
        <xsl:with-param name="data" select="$SITTax"/>
      </xsl:call-template>
      <xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'chkTaxType'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
      <xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'chkPeriod'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
      <xsl:call-template name="eachLetter">
        <xsl:with-param name="startIndex" select="1"/>
        <xsl:with-param name="prefix" select="'fpp-'"/>
        <xsl:with-param name="data" select="$enddate"/>
      </xsl:call-template>
		</Fields>
	</Report>
</xsl:template>	
</xsl:stylesheet>

  