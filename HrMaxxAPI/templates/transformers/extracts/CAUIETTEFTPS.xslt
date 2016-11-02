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
		<xsl:variable name="UISum" select="Accumulation/Taxes/PayrollTax[Tax/Id=10]/Amount"/>
		<xsl:variable name="ETTSum" select="Accumulation/Taxes/PayrollTax[Tax/Id=9]/Amount"/>
		<xsl:variable name="totalTax" select="$UISum + $ETTSum"/>
		<xsl:variable name="UISumString" select="format-number($UISum,'0000000000.00')"/>
		<xsl:variable name="ETTSumString" select="format-number($ETTSum,'0000000000.00')"/>
		<xsl:variable name="totalTaxString" select="format-number($totalTax,'00000000000.00')"/>
		<xsl:variable name="totalTaxStringL" select="format-number($totalTax,'###########.00')"/>
		
<xsl:choose>
<xsl:when test="$totalTax>0">
<xsl:value-of select="$reportConst"/>,
<xsl:value-of select="translate(States/CompanyTaxState[State/StateId=1]/StateEIN,'-','')"/>,
<xsl:value-of select="States/CompanyTaxState[State/StateId=1]/StatePIn"/>,
<xsl:value-of select="$enddate"/>,
<xsl:value-of select="$settleDate"/>,
<xsl:value-of select="$UISumString"/>,
<xsl:value-of select="$ETTSumString"/>,
0.00
<xsl:text>$$n</xsl:text>
</xsl:when>
</xsl:choose>
</xsl:template>
 
</xsl:stylesheet>
