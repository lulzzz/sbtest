<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
	<xsl:param name="selectedYear"/>
  <xsl:param name="reportConst"/>
  <xsl:param name="enddate"/>
  <xsl:param name="settleDate"/>
  
  <xsl:output method="text" indent="no"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="/">
<xsl:apply-templates select="ExtractResponse/Hosts/ExtractHost[count(Accumulation/PayChecks/PayCheck)>0]" >	
</xsl:apply-templates>
    
  </xsl:template>
  
  <xsl:template match="ExtractHost">
		<xsl:variable name="SDISum" select="Accumulation/Taxes/PayrollTax[Tax/Code='SDI']/Amount"/>
		<xsl:variable name="SITSum" select="Accumulation/Taxes/PayrollTax[Tax/Code='SIT']/Amount"/>
		<xsl:variable name="totalTax" select="$SDISum + $SITSum"/>
		<xsl:variable name="SDISumString" select="format-number($SDISum,'##########.00')"/>
		<xsl:variable name="SITSumString" select="format-number($SITSum,'##########.00')"/>
		<xsl:variable name="totalTaxString" select="format-number($totalTax,'##########.00')"/>
		
<xsl:choose>
<xsl:when test="$totalTax>0">
<xsl:value-of select="$reportConst"/>,
<xsl:value-of select="translate(States/CompanyTaxState[State/StateId=1]/StateEIN,'-','')"/>,
<xsl:value-of select="States/CompanyTaxState[State/StateId=1]/StatePIN"/>,
<xsl:value-of select="$enddate"/>,
<xsl:value-of select="$settleDate"/>,
<xsl:value-of select="$SDISumString"/>,
<xsl:value-of select="$SITSumString"/>,
0.00
<xsl:text>$$n</xsl:text>
</xsl:when>
</xsl:choose>
</xsl:template>
 
</xsl:stylesheet>
