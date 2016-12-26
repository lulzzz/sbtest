<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
	<xsl:param name="today"/>
	<xsl:param name="time"/>
	<xsl:param name="postingDate"/>
	<xsl:output method="text" indent="no"/>
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="mainHost" select="/ACHResponse/Hosts/ExtractHost[Host/FirmName='GIIG']"/>

	<xsl:template match="/">
101$$spaces1$$<xsl:value-of select="$mainHost/HostBank/RoutingNumber"/>$$spaces1$$<xsl:value-of select="$mainHost/HostBank/RoutingNumber"/><xsl:value-of select="$today"/><xsl:value-of select="$time"/>A094101CALIFORNIA BANK &amp; TRUST<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate($mainHost/HostCompany/TaxFilingName, $smallcase, $uppercase)"/><xsl:with-param name="count" select="23"/></xsl:call-template>$$spaces5$$$$spaces2$$$$spaces1$$<xsl:text>$$n</xsl:text>
	<xsl:apply-templates select="ACHResponse/Hosts/ExtractHost[count(ACHTransactions/ACHTransaction)>0]" >
	</xsl:apply-templates>
<xsl:variable name="rowstype5" select="count(ACHResponse/Hosts/ExtractHost[count(ACHTransactions/ACHTransaction[TransactionType='PPD'])>0]) + count(ACHResponse/Hosts/ExtractHost[count(ACHTransactions/ACHTransaction[TransactionType='CCD'])>0])"/>
<xsl:variable name="rowstype6" select="count(ACHResponse/Hosts/ExtractHost/ACHTransactions/ACHTransaction[TransactionType='PPD']/EmployeeBankAccounts/EmployeeBankAccount) + count(ACHResponse/Hosts/ExtractHost/ACHTransactions/ACHTransaction[TransactionType='CCD']/CompanyBankAccount)"/>
<xsl:variable name="totalrows" select="2 + $rowstype5*2 + $rowstype6"/>
9<xsl:value-of select="format-number(count(ACHResponse/Hosts/ExtractHost[count(ACHTransactions/ACHTransaction[TransactionType='PPD'])>0]) + count(ACHResponse/Hosts/ExtractHost[count(ACHTransactions/ACHTransaction[TransactionType='CCD'])>0]),'000000')"/><xsl:value-of select="format-number($totalrows div 10,'000000')"/><xsl:value-of select="format-number($rowstype6,'00000000')"/><xsl:value-of select="format-number(sum(ACHResponse/Hosts/ExtractHost/ACHTransactions/ACHTransaction[TransactionType='PPD']/EmployeeBankAccounts/EmployeeBankAccount/BankAccount/RoutingNumber1) + sum(ACHResponse/Hosts/ExtractHost/ACHTransactions/ACHTransaction[TransactionType='CCD']/CompanyBankAccount/BankAccount/RoutingNumber1) + sum(ACHResponse/Hosts/ExtractHost[count(ACHTransactions/ACHTransaction)>0]/HostBank/RoutingNumber1),'0000000000')"/><xsl:value-of select="format-number(sum(ACHResponse/Hosts/ExtractHost/ACHTransactions/ACHTransaction[TransactionType='CCD']/Amount),'000000000000')"/><xsl:value-of select="format-number(sum(ACHResponse/Hosts/ExtractHost/ACHTransactions/ACHTransaction[TransactionType='PPD']/Amount),'000000000000')"/>$$spaces20$$$$spaces10$$$$spaces5$$$$spaces2$$$$spaces2$$
<xsl:if test="$totalrows mod 10 > 0">
<xsl:call-template name="final">
<xsl:with-param name="times" select="10 - ($totalrows mod 10)"/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="ExtractHost">
	<xsl:variable name ="pos" select="position()"/>
	<xsl:if test="ACHTransactions/ACHTransaction[TransactionType='PPD']">
<xsl:variable name="posppd" select="count(preceding-sibling::ACHTransactions/ACHTransaction[TransactionType='PPD']) + count(preceding-sibling::ACHTransactions/ACHTransaction[TransactionType='CCD']) + 1"/>
5220<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(HostCompany/TaxFilingName, $smallcase, $uppercase)"/><xsl:with-param name="count" select="16"/></xsl:call-template>$$spaces20$$1<xsl:value-of select="Host/BankCustomerId"/>PPDPAYROLL$$spaces2$$$$spaces1$$<xsl:value-of select="$today"/><xsl:value-of select="$postingDate"/>$$spaces2$$$$spaces1$$1<xsl:value-of select="substring(HostBank/RoutingNumber,1,8)"/><xsl:call-template name="padLeft"><xsl:with-param name="data" select="$posppd"/><xsl:with-param name="count" select="7"/></xsl:call-template><xsl:text>$$n</xsl:text>
<xsl:apply-templates select="ACHTransactions/ACHTransaction[TransactionType='PPD']">
</xsl:apply-templates>
8220<xsl:call-template name="padLeft">
		<xsl:with-param name="data" select="count(ACHTransactions/ACHTransaction[TransactionType='PPD']/EmployeeBankAccounts/EmployeeBankAccount)"/>
		<xsl:with-param name="count" select="6"/>
	</xsl:call-template><xsl:value-of select="format-number(sum(ACHTransactions/ACHTransaction[TransactionType='PPD']/EmployeeBankAccounts/EmployeeBankAccount/BankAccount/RoutingNumber1),'0000000000')"/><xsl:value-of select="translate(format-number(sum(ACHTransactions/ACHTransaction[TransactionType='PPD']/Amount),'0000000000.00'),'.','')"/>0000000000001<xsl:value-of select="Host/BankCustomerId"/>$$spaces20$$$$spaces5$$<xsl:value-of select="HostBank/RoutingNumber1"></xsl:value-of>0000001<xsl:text>$$n</xsl:text>
	</xsl:if>
	<xsl:if test="ACHTransactions/ACHTransaction[TransactionType='CCD']">
<xsl:variable name="posccd" select="count(preceding-sibling::ACHTransactions/ACHTransaction[TransactionType='PPD']) + count(preceding-sibling::ACHTransactions/ACHTransaction[TransactionType='CCD']) + 1 + count(ACHTransactions[ACHTransaction[TransactionType='PPD']])"/>
5225<xsl:call-template name="padRight"><xsl:with-param name="data" select="translate(HostCompany/TaxFilingName, $smallcase, $uppercase)"/><xsl:with-param name="count" select="16"/></xsl:call-template>$$spaces20$$1<xsl:value-of select="Host/BankCustomerId"/>CCDINVOICE$$spaces2$$$$spaces1$$<xsl:value-of select="$today"/><xsl:value-of select="$postingDate"/>$$spaces2$$$$spaces1$$1<xsl:value-of select="substring(HostBank/RoutingNumber,1,8)"/><xsl:call-template name="padLeft"><xsl:with-param name="data" select="$posccd"/><xsl:with-param name="count" select="7"/></xsl:call-template><xsl:text>$$n</xsl:text>
<xsl:apply-templates select="ACHTransactions/ACHTransaction[TransactionType='CCD']">
</xsl:apply-templates>
8225<xsl:call-template name="padLeft">
		<xsl:with-param name="data" select="count(ACHTransactions/ACHTransaction[TransactionType='CCD']/CompanyBankAccount)"/>
		<xsl:with-param name="count" select="6"/>
	</xsl:call-template><xsl:value-of select="format-number(sum(ACHTransactions/ACHTransaction[TransactionType='CCD']/CompanyBankAccount/RoutingNumber1),'0000000000')"/><xsl:value-of select="translate(format-number(sum(ACHTransactions/ACHTransaction[TransactionType='CCD']/Amount),'0000000000.00'),'.','')"/>0000000000001<xsl:value-of select="Host/BankCustomerId"/>$$spaces20$$$$spaces5$$<xsl:value-of select="HostBank/RoutingNumber1"/><xsl:choose><xsl:when test="ACHTransactions/ACHTransaction[TransactionType='PPD']">0000002</xsl:when><xsl:otherwise>0000001</xsl:otherwise></xsl:choose><xsl:text>$$n</xsl:text>
	</xsl:if>
</xsl:template>
<xsl:template match="ACHTransaction">

<xsl:choose>
	<xsl:when test="TransactionType='PPD'">
		<xsl:apply-templates select="EmployeeBankAccounts/EmployeeBankAccount">
		</xsl:apply-templates>
	</xsl:when>
	<xsl:when test="TransactionType='CCD'">
<xsl:variable name="counter" select="count(preceding-sibling::ACHTransaction[TransactionType='CCD']/CompanyBankAccount) + 1"/>
6<xsl:choose>
	<xsl:when test="../../HostBank/AccountType='Checking'">27</xsl:when>
	<xsl:when test="../../HostBank/AccountType='Savings'">37</xsl:when>
</xsl:choose><xsl:value-of select="CompanyBankAccount/RoutingNumber"/><xsl:call-template name="padRight">
		<xsl:with-param name="data" select="CompanyBankAccount/AccountNumber"/>
		<xsl:with-param name="count" select="17"/>
	</xsl:call-template><xsl:value-of select="translate(format-number(Amount,'00000000.00'),'.','')"/>$$spaces10$$$$spaces5$$<xsl:call-template name="padRight">
		<xsl:with-param name="data" select="Name"/>
		<xsl:with-param name="count" select="22"/>
	</xsl:call-template>$$spaces2$$0<xsl:value-of select="../../HostBank/RoutingNumber1"/><xsl:call-template name="padLeft">
		<xsl:with-param name="data" select="position()"/>
		<xsl:with-param name="count" select="7"/>
	</xsl:call-template><xsl:text>$$n</xsl:text>
	</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="EmployeeBankAccount">
<xsl:variable name="counter" select="count(../../preceding-sibling::ACHTransaction[TransactionType='PPD']/EmployeeBankAccounts/EmployeeBankAccount) + position()"/>
6<xsl:choose>
<xsl:when test="BankAccount/AccountType='Checking'">22</xsl:when>
<xsl:when test="BankAccount/AccountType='Savings'">32</xsl:when>
</xsl:choose>
<xsl:value-of select="BankAccount/RoutingNumber"/><xsl:call-template name="padRight">
<xsl:with-param name="data" select="BankAccount/AccountNumber"/>
<xsl:with-param name="count" select="17"/>
</xsl:call-template><xsl:value-of select="translate(format-number((../../Amount)*Percentage div 100,'00000000.00'),'.','')"/>$$spaces10$$$$spaces5$$<xsl:call-template name="padRight">
<xsl:with-param name="data" select="../../Name"/>
<xsl:with-param name="count" select="22"/>
</xsl:call-template>$$spaces2$$0<xsl:value-of select="../../../../HostBank/RoutingNumber1"/><xsl:call-template name="padLeft">
<xsl:with-param name="data" select="$counter"/>
<xsl:with-param name="count" select="7"/>
</xsl:call-template><xsl:text>$$n</xsl:text>
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
<xsl:template name="final">
		<xsl:param name="times"/>
		<xsl:param name="count"/>
<xsl:if test="$times>0">
<xsl:text>$$n</xsl:text>
<xsl:value-of select="substring(concat('9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999',''),1,94)"/>
<xsl:call-template name="final"><xsl:with-param name="times" select="$times - 1"/></xsl:call-template>
</xsl:if>
	</xsl:template>
</xsl:stylesheet>
