<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="storeId"/>
	<xsl:param name="storeKey"/>
	<xsl:param name="merchantId"/>
	<xsl:param name="locationId"/>
	<xsl:param name="startdate"/>
	<xsl:param name="enddate"/>
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="/">
		<reportRequest xmlns="http://www.selectpayment.com/ReportRequest.xsd">

			<credentials>
				<storeID><xsl:value-of select="$storeId"/></storeID>
				<storeKey><xsl:value-of select="$storeKey"/></storeKey>
			</credentials>
			<eventReport>
				<merchants>
					<merchant merchantID="{$merchantId}">
						<locations>
							<location><xsl:value-of select="$locationId"/></location>
						</locations>
					</merchant>
				</merchants>
				<dateRange>
					<start><xsl:value-of select="$startdate"/>T09:00:00</start>
					<end><xsl:value-of select="$enddate"/>T09:00:00</end>
				</dateRange>
				<events>
					<event>Declined</event>
					<event>Approved</event>
					<event>Processing_Error</event>
					<event>Voided</event>
					<event>Captured</event>
					<event>Refunded</event>
					<event>Reversed</event>
					<event>Processed</event>
					<event>Cleared</event>
					<event>Collected</event>
					<event>Collection_Failed</event>
					<event>Originated</event>
					<event>Settled</event>
					<event>Represented</event>
					<event>Held_For_Approval</event>
					<event>Suspended</event>
					<event>Sent_To_Collection</event>
					<event>Research_Complete</event>
					<event>Research_Failed</event>
					<event>Disputed</event>
					<event>Returned_NSF</event>
					<event>Returned_Bad_Account</event>
					<event>Resolved</event>
				</events>
			</eventReport>

		</reportRequest>
	</xsl:template>

</xsl:stylesheet>

