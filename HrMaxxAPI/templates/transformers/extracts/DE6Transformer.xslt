<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>

  <xsl:param name="endQuarterMonth"/>
  <xsl:param name="selectedYear"/>
  <xsl:output method="text" indent="no"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="/">
<xsl:apply-templates select="ExtractResponse/Hosts/ExtractHost[count(PayCheckAccumulation/PayCheckList/PayCheckSummary)>0]" >
	<xsl:sort select="HostCompany/TaxFilingName"/>
</xsl:apply-templates>
    
  </xsl:template>
  <xsl:template match="ExtractHost">
E$$spaces20$$$$spaces2$$<xsl:value-of select="substring(concat(translate(HostCompany/TaxFilingName,$smallcase,$uppercase),'                                                  '),1,50)"/>
<xsl:value-of disable-output-escaping="no" select="substring(concat(translate(HostCompany/BusinessAddress/AddressLine1,$smallcase,$uppercase),'                                                  '),1,40)"/>
<xsl:value-of select="substring(concat(translate(HostCompany/BusinessAddress/City,$smallcase,$uppercase),'                                                  '),1,25)"/>06$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:choose>
<xsl:when test="HostCompany/BusinessAddress/ZipExtension">
<xsl:text>-</xsl:text><xsl:value-of select="substring(concat(HostCompany/BusinessAddress/ZipExtension,'                                                  '),1,4)"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="substring(concat(HostCompany/BusinessAddress/ZipExtension,'                                                  '),1,5)"/>
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="substring(concat(HostCompany/BusinessAddress/Zip,'                                                  '),1,5)"/>$$spaces100$$$$spaces10$$$$spaces5$$$$spaces2$$
<xsl:text>$$n</xsl:text>
<xsl:apply-templates select="EmployeeAccumulationList/Accumulation">
<xsl:sort select="SSNVal" data-type="number"/>
</xsl:apply-templates>
T<xsl:value-of select="format-number(count(EmployeeAccumulationList/Accumulation),'0000000')"/>$$spaces10$$$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:variable name="WagesSum" select="PayCheckAccumulation/PayCheckWages/GrossWage" />
<xsl:variable name="Sum125C" select="sum(PayCheckAccumulation/Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=9]/YTD)"/>
<xsl:variable name="SUIWageSum" select="($WagesSum - $Sum125C)" />
<xsl:variable name="SITWageSum" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage" />
<xsl:variable name="SITSum" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SIT']/YTD" />
<xsl:value-of select="translate(format-number($SUIWageSum,'000000000000.00'),'.','')"/>
$$spaces100$$$$spaces20$$$$spaces20$$$$spaces10$$$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:value-of select="translate(format-number($SITWageSum,'000000000000.00'),'.','')"/>
<xsl:value-of select="translate(format-number($SITSum,'000000000000.00'),'.','')"/>
<xsl:choose>
<xsl:when test="PayCheckAccumulation/PayCheckWages/Twelve1">
<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/Twelve1,'0000000')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="format-number(0,'0000000')"/>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="PayCheckAccumulation/PayCheckWages/Twelve2">
<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/Twelve2,'0000000')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="format-number(0,'0000000')"/>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="PayCheckAccumulation/PayCheckWages/Twelve3">
<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/Twelve3,'0000000')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="format-number(0,'0000000')"/>
</xsl:otherwise>
</xsl:choose>
$$spaces20$$$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:text>$$n</xsl:text>
  </xsl:template>
  <xsl:template match="Contact">
<xsl:value-of disable-output-escaping="no" select="substring(concat(translate(Address/AddressLine1,$smallcase,$uppercase),'                                                  '),1,40)"/>
    
<xsl:value-of select="substring(concat(translate(Address/City,$smallcase,$uppercase),'                                                  '),1,25)"/>06$$spaces5$$$$spaces2$$$$spaces1$$

<xsl:choose>
<xsl:when test="Address/ZipExtension">
<xsl:text>-</xsl:text><xsl:value-of select="substring(concat(Address/ZipExtension,'                                                  '),1,4)"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="substring(concat(Address/ZipExtension,'                                                  '),1,5)"/>
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="substring(concat(Address/Zip,'                                                  '),1,5)"/>$$spaces100$$$$spaces10$$$$spaces5$$$$spaces2$$
</xsl:template>
  <xsl:template match="Accumulation">
<xsl:variable name="empState" select="1"/>
S<xsl:value-of select="translate(SSNVal,'-','')"/> <xsl:value-of select="substring(concat(translate(LastName,$smallcase,$uppercase),'                                                  '),1,20)"/>
<xsl:value-of select="substring(concat(translate(FirstName,$smallcase,$uppercase),'                                                  '),1,12)"/>
<xsl:value-of select="substring(concat(translate(MiddleInitial,$smallcase,$uppercase),'                                                  '),1,1)"/>06$$spaces10$$$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:choose>
<xsl:when test="sum(Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=9]/YTD)">
<xsl:value-of select="translate(format-number((PayCheckWages/GrossWage - sum(Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=9]/YTD)),'000000000000.00'),'.','')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="translate(format-number(PayCheckWages/GrossWage,'000000000000.00'),'.','')"/>
</xsl:otherwise>
</xsl:choose>
$$spaces20$$$$spaces20$$$$spaces20$$$$spaces5$$$$spaces2$$$$spaces2$$
<xsl:value-of select="translate(../../States/CompanyTaxState[State/StateId=$empState]/StateEIN,'-','')"/>000$$spaces10$$$$spaces5$$$$spaces2$$$$spaces2$$
<xsl:value-of select="translate(format-number(Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage,'000000000000.00'),'.','')"/>
<xsl:value-of select="translate(format-number(Taxes/PayCheckTax[Tax/Code='SIT']/YTD,'000000000000.00'),'.','')"/>
$$spaces5$$$$spaces1$$S$$spaces2$$$$spaces1$$<xsl:value-of select="format-number($endQuarterMonth,'00')"/><xsl:value-of select="$selectedYear"/>$$spaces20$$$$spaces20$$$$spaces5$$$$spaces5$$$$spaces5$$
<xsl:text>$$n</xsl:text>
  </xsl:template>
</xsl:stylesheet>
