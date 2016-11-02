<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
  <xsl:param name="batchFilerId"/>
  <xsl:param name="masterPinNumber"/>
  <xsl:param name="fileSeq"/>
    
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
		<xsl:variable name="totalFUTATax" select="Accumulation/Taxes/PayrollTax[Tax/Id=6]/Amount"/>
		<xsl:variable name="FUTASum" select="format-number($totalFUTATax,'000000000000.00')"/>		
		<xsl:if test="$totalFUTATax>0">
<xsl:value-of select="format-number($batchFilerId,'000000000')"/><xsl:value-of select="format-number($masterPinNumber,'0000')"/>		
<xsl:value-of select="$today"/><xsl:value-of select="format-number($fileSeq,'000')"/><xsl:value-of select="format-number(position(),'0000')"/>
P<xsl:value-of select="translate(Company/FederalEIN,'-','')"/><xsl:value-of select="Company/FederalPin"/>B09405<xsl:value-of select="$selectedYear"/>12<xsl:value-of select="$settleDate"/>
<xsl:value-of select="format-number(translate($FUTASum,'.',''),'000000000000000')"/>$$spaces2$$$$spaces1$$$$spaces10$$$$spaces5$$
$$spaces2$$$$spaces1$$$$spaces10$$$$spaces5$$
$$spaces2$$$$spaces1$$$$spaces10$$$$spaces5$$
$$spaces10$$$$spaces10$$$$spaces10$$$$spaces5$$$$spaces1$$
<xsl:text>$$n</xsl:text>
		</xsl:if>
</xsl:template>
</xsl:stylesheet>
