<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" xmlns:foo="http://whatever">
<xsl:param name="MagFileUserId"/>
<xsl:param name="selectedYear"/>
<xsl:output method="text" indent="no"/>
<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
<xsl:variable name="apos">'</xsl:variable>
<xsl:variable name="special" select="concat('/.,_-?;:~\', $apos)"/>
<xsl:template match="/">RA462262313<xsl:value-of select="$MagFileUserId"/>$$spaces5$$$$spaces2$$$$spaces2$$0$$spaces5$$$$spaces1$$98
CORPORATE BENEFITS CORP$$spaces20$$$$spaces10$$$$spaces2$$$$spaces2$$
2750 N BELLFLOWER BLVD2750 N BELLFLOWER BLVDLONG BEACH #200$$spaces5$$$$spaces2$$CA90815$$spaces5$$$$spaces2$$$$spaces2$$
$$spaces20$$$$spaces20$$
CORPORATE BENEFITS CORP$$spaces20$$$$spaces10$$$$spaces2$$$$spaces2$$
2750 N BELLFLOWER BLVD #200$$spaces10$$$$spaces2$$$$spaces5$$LONG BEACH$$spaces10$$$$spaces2$$CA90815
$$spaces20$$$$spaces20$$$$spaces5$$$$spaces2$$$$spaces2$$
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'Jay Shen'"/><xsl:with-param name="count" select="27"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="5624252005"/><xsl:with-param name="count" select="23"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'jshen@calemp.com'"/><xsl:with-param name="count" select="40"/></xsl:call-template>
$$spaces2$$$$spaces1$$5624252008$$spaces1$$S$$spaces10$$$$spaces2$$
<xsl:text>$$n</xsl:text>
<xsl:apply-templates select="ExtractResponse/Hosts/ExtractHost">
<xsl:sort select="HostCompany/TaxFilingName"/>
</xsl:apply-templates>
RF$$spaces5$$<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(ExtractResponse/Hosts/ExtractHost/EmployeeAccumulationList/Accumulation[PayCheckWages/GrossWage>0])"/><xsl:with-param name="count" select="9"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="496"/></xsl:call-template>
<xsl:text>$$n</xsl:text>

  </xsl:template>
	<xsl:template match="ExtractHost">
		<xsl:variable name="totalTips" select="sum(PayCheckAccumulation/Compensations/PayCheckCompensation[PayTypeId=3]/YTD)"/>
		<xsl:variable name="fitWages" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage)"/>
		<xsl:variable name="totalSSWages" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage)"/>
		<xsl:variable name="SSETax" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTD)"/>
		<xsl:variable name="MDETax" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTD)"/>

		<xsl:variable name="totalMDWages" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage)"/>
		<xsl:variable name="totalFITTax" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT']/YTD)"/>
		<xsl:variable name="totalSSTax" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employee' or Tax/Code='SS_Employer']/YTD)"/>
		<xsl:variable name="totalMDTax" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee' or Tax/Code='MD_Employer']/YTD)"/>
RE<xsl:value-of select="$selectedYear"/>$$spaces1$$<xsl:value-of select="translate(HostCompany/FederalEIN,'-','')"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="9"/></xsl:call-template>
0$$spaces10$$$$spaces2$$$$spaces1$$<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(HostCompany/TaxFilingName,$smallcase,$uppercase)"/><xsl:with-param name="count" select="57"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="22"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(HostCompany/BusinessAddress/AddressLine1,$smallcase,$uppercase)"/><xsl:with-param name="count" select="22"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(HostCompany/BusinessAddress/City,$smallcase,$uppercase)"/><xsl:with-param name="count" select="22"/></xsl:call-template>
<xsl:value-of select="States/CompanyTaxState[position()=1]/State/Abbreviation"/><xsl:value-of select="HostCompany/BusinessAddress/Zip"/><xsl:call-template name="padRight"><xsl:with-param name="data" select="HostCompany/BusinessAddress/ZipExtension"/><xsl:with-param name="count" select="4"/></xsl:call-template>
N<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="19"/></xsl:call-template>$$spaces20$$$$spaces5$$
<xsl:choose><xsl:when test="HostCompany/IsFiler944">F</xsl:when><xsl:otherwise>R</xsl:otherwise></xsl:choose>$$spaces1$$0
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(translate(concat(Contact/FirstName,' ',Contact/MiddleInitial,' ',Contact/LastName),$smallcase,$uppercase),$special,'')"/><xsl:with-param name="count" select="27"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Contact/Phone,'-','')"/><xsl:with-param name="count" select="20"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Contact/Fax,'-','')"/><xsl:with-param name="count" select="10"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="Contact/Email"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="194"/></xsl:call-template>
<xsl:text>$$n</xsl:text>
<xsl:apply-templates select="EmployeeAccumulationList/Accumulation[PayCheckWages/GrossWage>0]">
<xsl:sort select="SSNVal" data-type="number"/>
</xsl:apply-templates>

RT<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(EmployeeAccumulationList/Accumulation[PayCheckWages/GrossWage>0])"/><xsl:with-param name="count" select="7"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number($fitWages,'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number($totalFITTax,'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(($totalSSWages - $totalTips),'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number($SSETax,'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number($totalMDWages,'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number($MDETax,'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number($totalTips,'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>

<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(sum(PayCheckAccumulation/Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=6]/YTD),'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(sum(PayCheckAccumulation/Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=7]/YTD),'#########.00'),'.','')"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="15"/></xsl:call-template>
$$spaces20$$$$spaces20$$$$spaces20$$$$spaces20$$$$spaces10$$$$spaces5$$$$spaces2$$$$spaces1$$
<xsl:text>$$n</xsl:text>
</xsl:template>



<xsl:template match="Accumulation">
RW<xsl:value-of select="translate(SSNVal,'-','')"/><xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(translate(FirstName,$smallcase,$uppercase),$special,'')"/><xsl:with-param name="count" select="15"/></xsl:call-template><xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(translate(MiddleInitial,$smallcase,$uppercase),$special,'')"/><xsl:with-param name="count" select="15"/></xsl:call-template><xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(translate(LastName,$smallcase,$uppercase),$special,'')"/><xsl:with-param name="count" select="20"/></xsl:call-template>$$spaces2$$$$spaces2$$$$spaces20$$$$spaces2$$
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Contact/Address/AddressLine1,$smallcase,$uppercase)"/><xsl:with-param name="count" select="22"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Contact/Address/City,$smallcase,$uppercase)"/><xsl:with-param name="count" select="22"/></xsl:call-template><xsl:value-of select="'CA'"/><xsl:call-template name="padRight"><xsl:with-param name="data" select="Contact/Address/Zip"/><xsl:with-param name="count" select="5"/></xsl:call-template><xsl:call-template name="padRight"><xsl:with-param name="data" select="Contact/Address/ZipExtension"/><xsl:with-param name="count" select="4"/></xsl:call-template>
$$spaces20$$$$spaces20$$$$spaces5$$
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage,'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(Taxes/PayCheckTax[Tax/Code='FIT']/YTD,'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage - sum(Compensations/PayCheckCompensation[PayTypeId=3]/YTD),'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTD,'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage,'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTD,'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(sum(Compensations/PayCheckCompensation[PayTypeId=3]/YTD),'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(sum(Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=6]/YTD),'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="translate(format-number(sum(Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=7]/YTD),'#########.00'),'.','')"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
$$spaces10$$$$spaces1$$
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="0"/><xsl:with-param name="count" select="11"/></xsl:call-template>$$spaces1$$0$$spaces1$$
<xsl:choose><xsl:when test="sum(Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/W2_13R])>0">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
0$$spaces20$$$$spaces2$$$$spaces1$$
<xsl:text>$$n</xsl:text>

</xsl:template>
  <xsl:template name="padRight">                 
    <xsl:param name="data"/> 
    <xsl:param name="count"/>
    <xsl:variable name="spaces" select="'                                                                                                    '"/>
	<xsl:value-of select="substring(concat($data,$spaces,$spaces,$spaces,$spaces,$spaces,$spaces),1,$count)"/>
  </xsl:template> 
  <xsl:template name="padLeft">                 
    <xsl:param name="data"/> 
    <xsl:param name="count"/>
    <xsl:variable name="start" select="100+string-length($data) - $count + 1"/>
    <xsl:value-of select="substring(concat('0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',$data),$start,$count)"/>
  </xsl:template> 

</xsl:stylesheet>
                                                                                                    
