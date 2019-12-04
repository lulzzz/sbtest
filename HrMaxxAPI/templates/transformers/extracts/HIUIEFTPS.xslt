<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
	<xsl:param name="selectedYear"/>
  <xsl:param name="reportConst"/>
  <xsl:param name="quarter"/>
  <xsl:param name="settleDate"/>
  
  <xsl:output method="text" indent="no"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="apos">'</xsl:variable>
  <xsl:variable name="special" select="concat('/.,_-?;:~\', $apos)"/>
  
  <xsl:template match="/">
<xsl:apply-templates select="ExtractResponse/Hosts/ExtractHost" >
	<xsl:sort select="HostCompany/TaxFilingName"/>
</xsl:apply-templates>
    
  </xsl:template>
  
  <xsl:template match="ExtractHost">
		<xsl:variable name="HIUISum" select="PayCheckAccumulation/ApplicableTaxes/YTD"/>
    <xsl:variable name="OOSSum" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI' or Tax/Code='TX-SUTA']/YTD"/>
    <xsl:apply-templates select="EmployeeAccumulationList/Accumulation[PayCheckWages/GrossWage>0 and (ApplicableWages>0 or OOSWages>0)]">
      <xsl:sort select="translate(SSNVal,'-','')" data-type="number"/>
    </xsl:apply-templates>
		
  </xsl:template>
  <xsl:template match="Accumulation">
    <xsl:variable name="HIUIWages" select="format-number(ApplicableWages, '######0.00')"/>
    <xsl:variable name="OOSWages" select="format-number(OutOfStateUIWages, '######0.00')"/>
<xsl:value-of select="$selectedYear"/>, <xsl:value-of select="$quarter"/>, <xsl:value-of select="../../States[CompanyTaxState/State/StateId=10]/CompanyTaxState/StateUIAccount"/>, 
<xsl:value-of select="substring(translate(translate(LastName,$smallcase,$uppercase),$special,''), 1, 30)"/>, 
<xsl:value-of select="substring(translate(translate(FirstName,$smallcase,$uppercase),$special,''), 1, 30)"/>, 
<xsl:value-of select="substring(translate(translate(MiddleInitial,$smallcase,$uppercase),$special,''), 1, 2)"/>,  
<xsl:value-of select="translate(SSNVal,'-','')"/>, 
<xsl:value-of select="$HIUIWages"/>, <xsl:value-of select="$OOSWages"/>, <xsl:value-of select="'CA'"/>, 
<xsl:choose>
<xsl:when test="(PayCheckWages/Twelve1) > 0">Y</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>, <xsl:choose>
<xsl:when test="(PayCheckWages/Twelve2) > 0">Y</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>,<xsl:choose>
<xsl:when test="(PayCheckWages/Twelve3) > 0">Y</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
    <xsl:text>$$n</xsl:text>
</xsl:template>
</xsl:stylesheet>
