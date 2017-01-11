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
<xsl:apply-templates select="ExtractResponse/Hosts/ExtractHost[count(Accumulation/PayChecks/PayCheck)>0]" >
</xsl:apply-templates>
    
  </xsl:template>
  <xsl:template match="ExtractHost">
E$$spaces20$$$$spaces2$$<xsl:value-of select="substring(concat(translate(HostCompany/TaxFilingName,$smallcase,$uppercase),'                                                  '),1,50)"/>
<xsl:apply-templates select="Contact"/>
<xsl:apply-templates select="EmployeeAccumulations/EmployeeAccumulation"/>
T<xsl:value-of select="format-number(count(EmployeeAccumulations/EmployeeAccumulation),'0000000')"/>$$spaces10$$$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:variable name="WagesSum" select="Accumulation/GrossWage" />
<xsl:variable name="Sum125C" select="sum(Accumulation/Deductions/PayrollDeduction[Deduction/Type/Id=9]/Amount)"/>
<xsl:variable name="SUIWageSum" select="($WagesSum - $Sum125C)" />
<xsl:variable name="SITWageSum" select="Accumulation/Taxes/PayrollTax[Tax/Code='SIT']/TaxableWage" />
<xsl:variable name="SITSum" select="Accumulation/Taxes/PayrollTax[Tax/Code='SIT']/Amount" />
<xsl:value-of select="translate(format-number($SUIWageSum,'000000000000.00'),'.','')"/>
$$spaces100$$$$spaces20$$$$spaces20$$$$spaces10$$$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:value-of select="translate(format-number($SITWageSum,'000000000000.00'),'.','')"/>
<xsl:value-of select="translate(format-number($SITSum,'000000000000.00'),'.','')"/>
<xsl:choose>
<xsl:when test="Accumulation/Count1">
<xsl:value-of select="format-number(Accumulation/Count1,'0000000')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="format-number(0,'0000000')"/>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="Accumulation/Count2">
<xsl:value-of select="format-number(Accumulation/Count2,'0000000')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="format-number(0,'0000000')"/>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="Accumulation/Count3">
<xsl:value-of select="format-number(Accumulation/Count3,'0000000')"/>
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
<xsl:text>$$n</xsl:text>
 </xsl:template>
  <xsl:template match="EmployeeAccumulation">
<xsl:variable name="empState" select="Employee/State/State/StateId"/>
S<xsl:value-of select="translate(Employee/SSN,'-','')"/> <xsl:value-of select="substring(concat(translate(Employee/LastName,$smallcase,$uppercase),'                                                  '),1,20)"/>
<xsl:value-of select="substring(concat(translate(Employee/FirstName,$smallcase,$uppercase),'                                                  '),1,12)"/>
<xsl:value-of select="substring(concat(translate(Employee/MiddleInitial,$smallcase,$uppercase),'                                                  '),1,1)"/>06$$spaces10$$$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:choose>
<xsl:when test="sum(Accumulation/Deductions/PayrollDeduction[Deduction/Type/Id=9]/Amount)">
<xsl:value-of select="translate(format-number((Accumulation/GrossWage - sum(Accumulation/Deductions/PayrollDeduction[Deduction/Type/Id=9]/Amount)),'000000000000.00'),'.','')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="translate(format-number(Accumulation/GrossWage,'000000000000.00'),'.','')"/>
</xsl:otherwise>
</xsl:choose>
$$spaces20$$$$spaces20$$$$spaces20$$$$spaces5$$$$spaces2$$$$spaces2$$
<xsl:value-of select="translate(../../States/CompanyTaxState[State/StateId=$empState]/StateEIN,'-','')"/>000$$spaces10$$$$spaces5$$$$spaces2$$$$spaces2$$
<xsl:value-of select="translate(format-number(Accumulation/Taxes/PayrollTax[Tax/Code='SIT']/TaxableWage,'000000000000.00'),'.','')"/>
<xsl:value-of select="translate(format-number(Accumulation/Taxes/PayrollTax[Tax/Code='SIT']/Amount,'000000000000.00'),'.','')"/>
$$spaces5$$$$spaces1$$S$$spaces2$$$$spaces1$$<xsl:value-of select="format-number($endQuarterMonth,'00')"/><xsl:value-of select="$selectedYear"/>$$spaces20$$$$spaces20$$$$spaces5$$$$spaces5$$$$spaces5$$
<xsl:text>$$n</xsl:text>
  </xsl:template>
</xsl:stylesheet>
