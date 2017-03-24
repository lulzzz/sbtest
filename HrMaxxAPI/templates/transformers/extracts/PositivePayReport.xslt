<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
	
  <xsl:output method="text" indent="no"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="/">
<xsl:apply-templates select="ExtractResponse/Hosts/ExtractHost[count(Journals/Journal)>0]" >	
</xsl:apply-templates>
    
  </xsl:template>
<xsl:template match="ExtractHost">
<xsl:variable name="total" select="translate(format-number(sum(Journals/Journal/Amount), '0000000000.00'),'.','')"/>
<xsl:apply-templates select="Journals/Journal">
	<xsl:sort select="CheckNumber" data-type="number"/>
</xsl:apply-templates>
T<xsl:value-of select="$total"/><xsl:call-template name="padLeft"><xsl:with-param name="data" select="count(Journals/Journal)"/><xsl:with-param name="count" select="9"/></xsl:call-template>
</xsl:template>  
<xsl:template match="Journal">
<xsl:variable name="mainaccount" select="MainAccountId"/>
<xsl:variable name="accountNumber" select="../../Accounts/Account[Id=$mainaccount]/BankAccount/AccountNumber"/>
<xsl:variable name="amount" select="translate(format-number(Amount, '0000000000.00'),'.','')"/>
<xsl:variable name="checkNumber" select="CheckNumber"/>
<xsl:variable name="issueDate" select="msxsl:format-date(TransactionDate, 'yyyyMMdd')"/>
<xsl:call-template name="padRight"><xsl:with-param name="data" select="$accountNumber"/><xsl:with-param name="count" select="10"/></xsl:call-template><xsl:value-of select="$amount"/>$$spaces5$$<xsl:call-template name="padRight"><xsl:with-param name="data" select="$checkNumber"/><xsl:with-param name="count" select="13"/></xsl:call-template>$$spaces5$$$$spaces2$$<xsl:value-of select="$issueDate"/><xsl:choose>
	<xsl:when test="IsVoid='true'">$$spaces5$$$$spaces2$$$$spaces1$$V</xsl:when>
</xsl:choose><xsl:text>$$n</xsl:text>
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
		<xsl:value-of select="substring(concat('                                                                                                    ',$data),$start,$count)"/>
	</xsl:template>
</xsl:stylesheet>
