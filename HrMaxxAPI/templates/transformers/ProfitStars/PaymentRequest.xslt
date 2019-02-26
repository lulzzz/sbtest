<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="storeId"/>
	<xsl:param name="storeKey"/>
	<xsl:param name="merchantId"/>
	<xsl:param name="locationId"/>
	<xsl:param name="fundprefix"/>
	<xsl:param name="refundprefix"/>
	<xsl:param name="payprefix"/>
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
	<requests xmlns="http://www.selectpayment.com/RTGRequest.xsd">
		<credentials>
			<storeID><xsl:value-of select="$storeId"/></storeID>
			<storeKey><xsl:value-of select="$storeKey"/></storeKey>
		</credentials>
		<xsl:apply-templates select="/ArrayOfProfitStarsPayment/ProfitStarsPayment[Type='Fund']" mode="fund"/>
		<xsl:apply-templates select="/ArrayOfProfitStarsPayment/ProfitStarsPayment[Type='Refund']" mode="refund"/>
		<xsl:apply-templates select="/ArrayOfProfitStarsPayment/ProfitStarsPayment[Type='Pay']" mode="pay"/>
	</requests>
</xsl:template>
<xsl:template match="ProfitStarsPayment" mode="fund">
	<sale requestID="{requestID}" merchantID="{$merchantId}" locationID="{$locationId}" transID="{transactionID}" >
		<check origin="Signature_Original">
			<amount><xsl:value-of select="Amount"/></amount>
			<bankBillTo>
				<bankInfo accountType="{AccountType}">
					<account><xsl:value-of select="AccountNumber"/></account>
					<rtn><xsl:value-of select="RoutingNumber"/></rtn>
				</bankInfo>
			</bankBillTo>
		</check>
	</sale>
</xsl:template>
	<xsl:template match="ProfitStarsPayment"  mode="refund">
	<credit requestID="{requestID}" merchantID="{$merchantId}" locationID="{$locationId}" transID="{requestID}" >
		<check origin="Signature_Original">
			<amount><xsl:value-of select="Amount"/></amount>
			<bankBillTo>
				<bankInfo accountType="{AccountType}">
					<account><xsl:value-of select="AccountNumber"/></account>
					<rtn><xsl:value-of select="RoutingNumber"/></rtn>
				</bankInfo>
			</bankBillTo>
		</check>
	</credit>
</xsl:template>
<xsl:template match="ProfitStarsPayment"  mode="pay">
	<credit requestID="{requestID}" merchantID="{$merchantId}" locationID="{$locationId}" transID="{requestID}" >
		<check origin="Signature_Original">
			<amount><xsl:value-of select="Amount"/></amount>
			<bankBillTo>
				<bankInfo accountType="{AccountType}">
					<account><xsl:value-of select="AccountNumber"/></account>
					<rtn><xsl:value-of select="RoutingNumber"/></rtn>
				</bankInfo>
			</bankBillTo>
		</check>
	</credit>
</xsl:template>
</xsl:stylesheet>