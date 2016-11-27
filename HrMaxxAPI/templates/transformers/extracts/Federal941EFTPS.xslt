<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
  <xsl:param name="batchFilerId"/>
  <xsl:param name="masterPinNumber"/>
  <xsl:param name="fileSeq"/>
    
  <xsl:param name="endQuarterMonth"/>
  <xsl:param name="selectedYear"/>
  <xsl:param name="today"/>
  <xsl:param name="settleDate"/>
  
  <xsl:output method="text" indent="no"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="/">
<xsl:apply-templates select="ExtractResponse/Hosts/ExtractHost[count(Accumulation/PayChecks/PayCheck)>0]" >	

</xsl:apply-templates>
    
  </xsl:template>
  
  <xsl:template match="ExtractHost">
		<xsl:variable name="totalSSWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=4]/TaxableWage - sum(Accumulation/Compensations[PayType/Id=3]/Amount)"/>
		<xsl:variable name="totalMDWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=2]/TaxableWage"/>
		<xsl:variable name="totalFITTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=1]/Amount"/>
		<xsl:variable name="totalSSTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=4]/Amount + Accumulation/Taxes/PayrollTax[Tax/Id=5]/Amount"/>
		<xsl:variable name="totalMDTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=2]/Amount + Accumulation/Taxes/PayrollTax[Tax/Id=3]/Amount"/>
		<xsl:variable name="line11" select="format-number(($totalFITTax + $totalSSTax + $totalMDTax),'000000000000.00')"/>
		<xsl:variable name="SSSum" select="format-number($totalSSTax,'000000000000.00')"/>
		<xsl:variable name="MDSum" select="format-number($totalMDTax,'000000000000.00')"/>
		<xsl:variable name="FITSum" select="format-number($totalFITTax,'000000000000.00')"/>		
<xsl:choose>
<xsl:when test="$line11>0">
<xsl:value-of select="format-number($batchFilerId,'000000000')"/><xsl:value-of select="format-number($masterPinNumber,'0000')"/>
<xsl:value-of select="$today"/><xsl:value-of select="format-number($fileSeq,'000')"/><xsl:value-of select="format-number(position(),'0000')"/>
P<xsl:value-of select="translate(Company/FederalEIN,'-','')"/><xsl:value-of select="Company/FederalPin"/>B94105<xsl:value-of select="$selectedYear"/><xsl:value-of select="$endQuarterMonth"/><xsl:value-of select="$settleDate"/> 
<xsl:value-of select="format-number(translate($line11,'.',''),'000000000000000')"/>001
<xsl:choose>
<xsl:when test="$totalSSTax>0"><xsl:value-of select="format-number(translate($SSSum,'.',''),'000000000000000')"/></xsl:when>
<xsl:otherwise>$$spaces10$$$$spaces5$$</xsl:otherwise>
</xsl:choose>002
<xsl:choose>
<xsl:when test="$totalMDTax>0"><xsl:value-of select="format-number(translate($MDSum,'.',''),'000000000000000')"/></xsl:when>
<xsl:otherwise>$$spaces10$$$$spaces5$$</xsl:otherwise>
</xsl:choose>003
<xsl:choose>
<xsl:when test="$totalFITTax>0"><xsl:value-of select="format-number(translate($FITSum,'.',''),'000000000000000')"/></xsl:when>
<xsl:otherwise>$$spaces10$$$$spaces5$$</xsl:otherwise>
</xsl:choose>$$spaces20$$$$spaces10$$$$spaces5$$$$spaces1$$
<xsl:text>$$n</xsl:text>
</xsl:when>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
