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
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(cpa/company[@efiler=0]/contact/vendor[@amount>0])"/><xsl:with-param name="count" select="8"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'JAY SHEN'"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'5624252005'"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="'JSHEN@CALEMP.COM'"/><xsl:with-param name="count" select="50"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="91"/></xsl:call-template>mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="10"/></xsl:call-template>I
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="232"/></xsl:call-template><xsl:text>$$n</xsl:text>
<xsl:apply-templates select="cpa/company[@efiler=0 and contact/vendor[@amount>0]]"/>
F<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(cpa/company[@efiler=0 and contact/vendor[@type1099='1099-MISC' and @amount>0]])+count(cpa/company[@efiler=0 and contact/vendor[@type1099='1099-DIV' and @amount>0]])+count(cpa/company[@efiler=0 and contact/vendor[@type1099='1099-INT' and @amount>0]])"/><xsl:with-param name="count" select="8"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="21"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="19"/></xsl:call-template>
<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(cpa/company[@efiler=0]/contact/vendor[@amount>0])"/><xsl:with-param name="count" select="8"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="442"/></xsl:call-template>
mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="243"/></xsl:call-template>
<xsl:text>$$n</xsl:text>
</xsl:template>
  
  
<xsl:template match="company">
<xsl:if test="count(contact/vendor[@type1099='1099-MISC' and @amount>0])>0">
	<xsl:apply-templates select="." mode="type">
		<xsl:with-param name="vType" select="'1099-MISC'"/>
	</xsl:apply-templates>
C<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(contact/vendor[@amount>0 and @type1099='1099-MISC'])"/><xsl:with-param name="count" select="8"/></xsl:call-template>$$spaces5$$$$spaces1$$
<xsl:variable name="sumRents" select="sum(contact/vendor[@type1099='1099-MISC' and @subtype1099='Rents']/@amount)"/>
<xsl:variable name="sumOtherIncome" select="sum(contact/vendor[@type1099='1099-MISC' and @subtype1099='Other Income']/@amount)"/>
<xsl:variable name="sumNonEmp" select="sum(contact/vendor[@type1099='1099-MISC' and @subtype1099='Non-Employee Comp']/@amount)"/>

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
<xsl:if test="count(contact/vendor[@type1099='1099-DIV' and @amount>0])>0">
	<xsl:apply-templates select="." mode="type">
		<xsl:with-param name="vType" select="'1099-DIV'"/>
	</xsl:apply-templates>
C<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(contact/vendor[@amount>0 and @type1099='1099-DIV'])"/><xsl:with-param name="count" select="8"/></xsl:call-template>$$spaces5$$$$spaces1$$
<xsl:variable name="sumODiv" select="sum(contact/vendor[@type1099='1099-DIV' and @subtype1099='Ordinary Dividend']/@amount)"/>
<xsl:variable name="sumQDiv" select="sum(contact/vendor[@type1099='1099-DIV' and @subtype1099='Qualified Dividend']/@amount)"/>
<xsl:variable name="sumCGD" select="sum(contact/vendor[@type1099='1099-DIV' and @subtype1099='Capital Gain Dist']/@amount)"/>
<xsl:variable name="sumNDD" select="sum(contact/vendor[@type1099='1099-DIV' and @subtype1099='Non Dividend Dist']/@amount)"/>

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
<xsl:if test="count(contact/vendor[@type1099='1099-INT' and @amount>0])>0">
	<xsl:apply-templates select="." mode="type">
		<xsl:with-param name="vType" select="'1099-INT'"/>
	</xsl:apply-templates>
C<xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(contact/vendor[@amount>0 and @type1099='1099-INT'])"/><xsl:with-param name="count" select="8"/></xsl:call-template>$$spaces5$$$$spaces1$$
<xsl:variable name="sumINT" select="sum(contact/vendor[@type1099='1099-INT' and @subtype1099='Interest Income']/@amount)"/>
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
<xsl:template match="company" mode="type">
<xsl:param name="vType"/>
A<xsl:value-of select="$selectedYear"/>$$spaces5$$$$spaces1$$<xsl:value-of select="translate(@fein,'-','')"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(substring(@taxfilingname,1,4),$smallcase,$uppercase)"/><xsl:with-param name="count" select="4"/></xsl:call-template>$$spaces1$$
<xsl:call-template name="getTypeCode"><xsl:with-param name="type" select="$vType"/></xsl:call-template>$$spaces1$$
<xsl:variable name="amCode">
<xsl:call-template name="getAmountCode"><xsl:with-param name="type" select="$vType"/></xsl:call-template>
</xsl:variable>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="$amCode"/><xsl:with-param name="count" select="14"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="10"/></xsl:call-template>$$spaces1$$
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(@taxfilingname,$smallcase,$uppercase)"/><xsl:with-param name="count" select="80"/></xsl:call-template>0
<xsl:variable name="mailingAddress" select="translate(substring(contact/@addressline1,1,40),$smallcase,$uppercase)"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="$mailingAddress"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(contact/@city,$smallcase,$uppercase)"/><xsl:with-param name="count" select="40"/></xsl:call-template>CA
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(concat('',contact/@zip,contact/@zipextension),$smallcase,$uppercase)"/><xsl:with-param name="count" select="9"/></xsl:call-template>
<xsl:variable name="phone" select="substring(concat('',translate(contact/@Phone1,'-','')),1,15)"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="$phone"/><xsl:with-param name="count" select="15"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="260"/></xsl:call-template>
mainCounter
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="243"/></xsl:call-template>
<xsl:text>$$n</xsl:text>
<xsl:apply-templates select="contact/vendor[@amount>0 and @type1099=$vType]"/>
</xsl:template>



<xsl:template match="vendor">
<xsl:variable name="amt" select="concat(floor(@amount),format-number((@amount - floor(@amount))*100,'00'))"/>
B<xsl:value-of select="$selectedYear"/>$$spaces1$$<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(substring(@contactlastname,1,4),$smallcase,$uppercase)"/><xsl:with-param name="count" select="4"/></xsl:call-template>
<xsl:choose>
<xsl:when test="@individualssn!=''">
	<xsl:choose><xsl:when test="starts-with(@individualssn,'9')">3</xsl:when><xsl:otherwise>2</xsl:otherwise></xsl:choose>
	<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(@individualssn,'-','')"/><xsl:with-param name="count" select="9"/></xsl:call-template></xsl:when>
<xsl:otherwise>
	<xsl:choose>
		<xsl:when test="@businessfin!=''">1<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(@businessfin,'-','')"/><xsl:with-param name="count" select="9"/></xsl:call-template></xsl:when>
		<xsl:otherwise><xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="10"/></xsl:call-template></xsl:otherwise>
	</xsl:choose>
	
</xsl:otherwise>
</xsl:choose>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="@accountnumber"/><xsl:with-param name="count" select="20"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="4"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="10"/></xsl:call-template>
<xsl:choose>
	<xsl:when test="@type1099='1099-MISC'">
		<xsl:choose>
			<xsl:when test="@subtype1099='Non-Employee Comp'">
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
			<xsl:when test="@subtype1099='Other Income'">
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
			<xsl:when test="@subtype1099='Rents'">
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
	<xsl:when test="@type1099='1099-DIV'">
		<xsl:choose>
			<xsl:when test="@subtype1099='Ordinary Dividend'">
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
			<xsl:when test="@subtype1099='Qualified Dividend'">
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
			<xsl:when test="@subtype1099='Capital Gain Dist'">
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
			<xsl:when test="@subtype1099='Non Dividend Dist'">
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
	<xsl:when test="@type1099='1099-INT'">
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
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(@vendorcustomername,$smallcase,$uppercase)"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="' '"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(@address,$smallcase,$uppercase)"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(@city,$smallcase,$uppercase)"/><xsl:with-param name="count" select="40"/></xsl:call-template>
<xsl:value-of select="@state"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="@zip"/><xsl:with-param name="count" select="9"/></xsl:call-template>
$$spaces1$$mainCounter<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="36"/></xsl:call-template>
<xsl:choose>
	<xsl:when test="@type1099='1099-MISC'">
		<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="179"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>$$spaces2$$
</xsl:when>
	<xsl:when test="@type1099='1099-DIV'">
		<xsl:call-template name="padRight"><xsl:with-param name="data" select="''"/><xsl:with-param name="count" select="179"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>
		<xsl:call-template name="padLeft"><xsl:with-param name="data" select="'0'"/><xsl:with-param name="count" select="12"/></xsl:call-template>$$spaces2$$$$spaces2$$
</xsl:when>
	<xsl:when test="@type1099='1099-INT'">
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
                                                                                                    
