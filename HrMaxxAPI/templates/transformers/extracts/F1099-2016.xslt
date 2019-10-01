<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
<xsl:import href="../Reports/Utils.xslt" />
  <xsl:param name="MagFileUserId"/>
  <xsl:param name="selectedYear"/>
  <xsl:param name="currentYear"/>
  <xsl:param name="tcc"/>
  <xsl:output method="text" indent="no"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="/">
T<xsl:value-of select="$selectedYear"/>
<xsl:choose><xsl:when test="$selectedYear &lt; ($currentYear - 1)">P</xsl:when><xsl:otherwise>$$spaces1$$</xsl:otherwise></xsl:choose>
201621276<xsl:value-of select="$tcc"/>$$spaces5$$$$spaces2$$$$spaces2$$
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'E DATA PROCESSING INC'"/><xsl:with-param name="count" select="80"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'E DATA PROCESSING, INC'"/><xsl:with-param name="count" select="80"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'2750 N BELLFLOWER BLVD'"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'LONG BEACH'"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'CA90815'"/><xsl:with-param name="count" select="26"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(ExtractResponse/Hosts/ExtractHost/Companies/ExtractCompany/Vendors/CompanyVendor)"/><xsl:with-param name="count" select="8"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'JAY SHEN'"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'5624252005'"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'JSHEN@CALEMP.COM'"/><xsl:with-param name="count" select="50"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="91"/></xsl:call-template>mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="10"/></xsl:call-template>I
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="232"/></xsl:call-template><xsl:text>$$n</xsl:text>
<xsl:apply-templates select="ExtractResponse/Hosts/ExtractHost[count(Companies/ExtractCompany/Vendors/CompanyVendor)>0]/HostCompany"/>
F<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(ExtractResponse/Hosts/ExtractHost/Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='MISC'])+count(ExtractResponse/Hosts/ExtractHost/Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='DIV'])+count(ExtractResponse/Hosts/ExtractHost/Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='INT'])"/><xsl:with-param name="count" select="8"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="21"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="19"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(ExtractResponse/Hosts/ExtractHost/Companies/ExtractCompany/Vendors/CompanyVendor)"/><xsl:with-param name="count" select="8"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="442"/></xsl:call-template>
mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="243"/></xsl:call-template>
<xsl:text>$$n</xsl:text>
</xsl:template>
  
  
<xsl:template match="HostCompany">
<xsl:if test="count(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='MISC'])>0">
	<xsl:apply-templates select="." mode="type">
		<xsl:with-param name="vType" select="'1099-MISC'"/>
	</xsl:apply-templates>
C<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='MISC'])"/><xsl:with-param name="count" select="8"/></xsl:call-template>$$spaces5$$$$spaces1$$
<xsl:variable name="sumRents" select="sum(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='MISC' and Vendor/SubType1099='Rents']/Amount)"/>
<xsl:variable name="sumOtherIncome" select="sum(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='MISC' and Vendor/SubType1099='OtherIncome']/Amount)"/>
<xsl:variable name="sumNonEmp" select="sum(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='MISC' and Vendor/SubType1099='NonEmployeeComp']/Amount)"/>

<xsl:call-template name="padLeft"><xsl:with-param name="data" select="concat(floor($sumRents),format-number(($sumRents - floor($sumRents))*100,'00'))"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="concat(floor($sumOtherIncome),format-number(($sumOtherIncome - floor($sumOtherIncome))*100,'00'))"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="concat(floor($sumNonEmp),format-number(($sumNonEmp - floor($sumNonEmp))*100,'00'))"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="36"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="196"/></xsl:call-template>mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="243"/></xsl:call-template>
<xsl:text>$$n</xsl:text>
</xsl:if>
<xsl:if test="count(Vendors/CompanyVendor[Vendor/Type1099='DIV'])>0">
	<xsl:apply-templates select="." mode="type">
		<xsl:with-param name="vType" select="'1099-DIV'"/>
	</xsl:apply-templates>
C<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='DIV'])"/><xsl:with-param name="count" select="8"/></xsl:call-template>$$spaces5$$$$spaces1$$
<xsl:variable name="sumODiv" select="sum(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='DIV']/Amount)"/>
<xsl:variable name="sumQDiv" select="sum(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='DIV' and Vendor/SubType1099='QualifiedDividend']/Amount)"/>
<xsl:variable name="sumCGD" select="sum(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='DIV' and Vendor/SubType1099='CaptialGainDist']/Amount)"/>
<xsl:variable name="sumNDD" select="sum(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='DIV' and Vendor/SubType1099='NonDividendDist']/Amount)"/>

<xsl:call-template name="padLeft"><xsl:with-param name="data" select="concat(floor($sumODiv),format-number(($sumODiv - floor($sumODiv))*100,'00'))"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="concat(floor($sumQDiv),format-number(($sumQDiv - floor($sumQDiv))*100,'00'))"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="concat(floor($sumCGD),format-number(($sumCGD - floor($sumCGD))*100,'00'))"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="concat(floor($sumNDD),format-number(($sumNDD - floor($sumNDD))*100,'00'))"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="36"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="196"/></xsl:call-template>mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="243"/></xsl:call-template>
<xsl:text>$$n</xsl:text>
</xsl:if>
<xsl:if test="count(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='INT'])>0">
	<xsl:apply-templates select="." mode="type">
		<xsl:with-param name="vType" select="'1099-INT'"/>
	</xsl:apply-templates>
C<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='INT'])"/><xsl:with-param name="count" select="8"/></xsl:call-template>$$spaces5$$$$spaces1$$
<xsl:variable name="sumINT" select="sum(../Companies/ExtractCompany/Vendors/CompanyVendor[Vendor/Type1099='INT' and Vendor/SubType1099='InterestIncome']/Amount)"/>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="concat(floor($sumINT),format-number(($sumINT - floor($sumINT))*100,'00'))"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="18"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="36"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="196"/></xsl:call-template>mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="243"/></xsl:call-template>
<xsl:text>$$n</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="HostCompany" mode="type">
<xsl:param name="vType"/>
A<xsl:value-of select="$selectedYear"/>$$spaces5$$$$spaces1$$<xsl:value-of select="translate(FederalEIN,'-','')"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(substring(TaxFilingName,1,4),$smallcase,$uppercase)"/><xsl:with-param name="count" select="4"/></xsl:call-template>$$spaces1$$
<xsl:call-template name="getTypeCode"><xsl:with-param name="type" select="$vType"/></xsl:call-template>$$spaces1$$
<xsl:variable name="amCode">
<xsl:call-template name="getAmountCode"><xsl:with-param name="type" select="$vType"/></xsl:call-template>
</xsl:variable>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="$amCode"/><xsl:with-param name="count" select="14"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="10"/></xsl:call-template>$$spaces1$$
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(TaxFilingName,$smallcase,$uppercase)"/><xsl:with-param name="count" select="80"/></xsl:call-template>0
<xsl:variable name="mailingAddress" select="translate(substring(../Contact/Address/AddressLine1,1,40),$smallcase,$uppercase)"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="$mailingAddress"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(../Contact/Address/City,$smallcase,$uppercase)"/><xsl:with-param name="count" select="40"/></xsl:call-template>CA
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(concat('',../Contact/Address/Zip,../Contact/Address/ZipExtension),$smallcase,$uppercase)"/><xsl:with-param name="count" select="9"/></xsl:call-template>
<xsl:variable name="phone" select="substring(concat('',translate(../Contact/Phone,'-','')),1,15)"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="$phone"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="260"/></xsl:call-template>
mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="243"/></xsl:call-template>
<xsl:text>$$n</xsl:text>
<xsl:apply-templates select="../Companies/ExtractCompany/Vendors/CompanyVendor"/>
</xsl:template>



<xsl:template match="CompanyVendor">
<xsl:variable name="amt" select="concat(floor(Amount),format-number((Amount - floor(Amount))*100,'00'))"/>
B<xsl:value-of select="$selectedYear"/>$$spaces1$$<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(substring(Vendor/Contact/LastName,1,4),$smallcase,$uppercase)"/><xsl:with-param name="count" select="4"/></xsl:call-template>
<xsl:choose>
<xsl:when test="Vednor/IndividualSSN!=''">
	<xsl:choose><xsl:when test="starts-with(Vednor/IndividualSSN,'9')">3</xsl:when><xsl:otherwise>2</xsl:otherwise></xsl:choose>
	<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Vednor/IndividualSSN,'-','')"/><xsl:with-param name="count" select="9"/></xsl:call-template></xsl:when>
<xsl:otherwise>
	<xsl:choose>
		<xsl:when test="Vendor/BusinessFIN!=''">1<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Vendor/BusinessFIN,'-','')"/><xsl:with-param name="count" select="9"/></xsl:call-template></xsl:when>
		<xsl:otherwise><xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="10"/></xsl:call-template></xsl:otherwise>
	</xsl:choose>
	
</xsl:otherwise>
</xsl:choose>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="Vendor/AccountNo"/><xsl:with-param name="count" select="20"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="4"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="10"/></xsl:call-template>
<xsl:choose>
	<xsl:when test="Vendor/Type1099='MISC'">
		<xsl:choose>
			<xsl:when test="Vendor/SubType1099='NonEmployeeComp'">
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="$amt"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
			</xsl:when>
			<xsl:when test="Vendor/SubType1099='OtherIncome'">
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="$amt"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
			</xsl:when>
			<xsl:when test="Vendor/SubType1099='Rents'">
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="$amt"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
			</xsl:when>
		
		</xsl:choose>
	
	</xsl:when>
	<xsl:when test="Vendor/Type1099='DIV'">
		<xsl:choose>
			<xsl:when test="Vendor/SubType1099='OrdinaryDividend'">
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="$amt"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
			</xsl:when>
			<xsl:when test="Vendor/SubType1099='QualifiedDividend'">
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="$amt"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
			</xsl:when>
			<xsl:when test="Vendor/SubType1099='CaptialGainDist'">
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="$amt"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>		
			</xsl:when>
			<xsl:when test="Vendor/SubType1099='NonDividendDist'">
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="$amt"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
				<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>						
			</xsl:when>
		
		</xsl:choose>
		
	</xsl:when>
	<xsl:when test="Vendor/Type1099='INT'">
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="$amt"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		
	</xsl:when>


</xsl:choose>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="24"/></xsl:call-template>$$spaces1$$
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Vendor/Name,$smallcase,$uppercase)"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Vendor/Contact/Address/AddressLine1,$smallcase,$uppercase)"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(Vendor/Contact/Address/City,$smallcase,$uppercase)"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:value-of select="Vendor/Contact/Address/StateCode"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="Vendor/Contact/Address/Zip"/><xsl:with-param name="count" select="9"/></xsl:call-template>
$$spaces1$$mainCounter<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="36"/></xsl:call-template>
<xsl:choose>
	<xsl:when test="Vendor/Type1099='MISC'">
		<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="179"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>$$spaces2$$
</xsl:when>
	<xsl:when test="Vendor/Type1099='DIV'">
		<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="179"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>$$spaces2$$$$spaces2$$
</xsl:when>
	<xsl:when test="Vendor/Type1099='INT'">
		<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="179"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>$$spaces2$$$$spaces2$$
</xsl:when>
</xsl:choose>
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
<xsl:template name="getTypeCode">
<xsl:param name="type"/>
<xsl:choose>
<xsl:when test="$type='1099-MISC'">A</xsl:when>
<xsl:when test="$type='1099-INT'">6</xsl:when>
<xsl:when test="$type='1099-DIV'">1</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template name="getAmountCode">
<xsl:param name="type"/>
<xsl:choose>
<xsl:when test="$type='1099-MISC'">12345678ABCDE</xsl:when>
<xsl:when test="$type='1099-INT'">12345689</xsl:when>
<xsl:when test="$type='1099-DIV'">1236789ABCDE</xsl:when>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
                                                                                                    
