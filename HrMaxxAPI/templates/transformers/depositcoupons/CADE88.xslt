<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
	<xsl:import href="../reports/Utils.xslt" />
	<xsl:param name="type"/>
	<xsl:param name="month"/>
	<xsl:param name="total"/>
	<xsl:param name="enddatestr"/>
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:variable name="compDetails" select="translate(concat(/ReportResponse/Company/TaxFilingName, ', ' ,/ReportResponse/Company/BusinessAddress/AddressLine1,' ',/ReportResponse/Company/BusinessAddress/City,', ',/ReportResponse/Company/BusinessAddress/StateCode,', ',/ReportResponse/Company/BusinessAddress/Zip),$smallcase,$uppercase)"/>

	<xsl:output method="xml" indent="no"/>
	<xsl:template match="ReportResponse">
		<ReportTransformed>
			<Name>FilledFormDE88</Name>
			<Reports>
				<xsl:apply-templates select="Company"/>

			</Reports>
		</ReportTransformed>
	</xsl:template>

	<xsl:template match="Company">
		
		<xsl:variable name="fein1" select="/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN"/>
		<xsl:variable name="sit1" select="sum(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code = 'SIT']/YTD)"/>
		<xsl:variable name="sdi1" select="sum(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code = 'SDI']/YTD)"/>
		<xsl:variable name="ett1" select="sum(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code = 'ETT']/YTD)"/>
		<xsl:variable name="ui1" select="sum(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code = 'SUI']/YTD)"/>
		
		<xsl:variable name="sit" select="translate(format-number($sit1,'0000000.00'),'.','')"/>
		<xsl:variable name="sdi" select="translate(format-number($sdi1,'0000000.00'),'.','')"/>
		<xsl:variable name="ett" select="translate(format-number($ett1,'0000000.00'),'.','')"/>
		<xsl:variable name="ui" select="translate(format-number($ui1,'0000000.00'),'.','')"/>
		
		<xsl:variable name="monthstr" select="format-number($month,'00')"/>
		
		<Report>
			<TemplatePath>GovtForms\DepositCoupons\</TemplatePath>
			<Template>de88all.pdf</Template>
			<Fields>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'a-1'"/>
					<xsl:with-param name="val1" select="substring($fein1,1,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'a-2'"/>
					<xsl:with-param name="val1" select="substring($fein1,2,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'a-3'"/>
					<xsl:with-param name="val1" select="substring($fein1,3,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'a-4'"/>
					<xsl:with-param name="val1" select="substring($fein1,4,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'a-5'"/>
					<xsl:with-param name="val1" select="substring($fein1,5,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'a-6'"/>
					<xsl:with-param name="val1" select="substring($fein1,6,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'a-7'"/>
					<xsl:with-param name="val1" select="substring($fein1,7,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'a-8'"/>
					<xsl:with-param name="val1" select="substring($fein1,8,1)"/>
				</xsl:call-template>
				
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'EmployerName'"/>
					<xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/>
				</xsl:call-template>

				<xsl:choose>
					<xsl:when test="$type=2">
						<xsl:if test="DepositSchedule='SemiWeekly'">
							<xsl:call-template name="CheckTemplate">
								<xsl:with-param name="name1" select="'sw'"/>
								<xsl:with-param name="val1" select="'On'"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="DepositSchedule='Monthly'">
							<xsl:call-template name="CheckTemplate">
								<xsl:with-param name="name1" select="'m'"/>
								<xsl:with-param name="val1" select="'On'"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="DepositSchedule='quarterly'">
							<xsl:call-template name="CheckTemplate">
								<xsl:with-param name="name1" select="'q'"/>
								<xsl:with-param name="val1" select="'On'"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="CheckTemplate">
							<xsl:with-param name="name1" select="'q'"/>
							<xsl:with-param name="val1" select="'On'"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'s-1'"/>
					<xsl:with-param name="val1" select="substring($enddatestr,1,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'s-2'"/>
					<xsl:with-param name="val1" select="substring($enddatestr,2,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'s-3'"/>
					<xsl:with-param name="val1" select="substring($enddatestr,3,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'s-4'"/>
					<xsl:with-param name="val1" select="substring($enddatestr,4,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'s-5'"/>
					<xsl:with-param name="val1" select="substring($enddatestr,5,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'s-6'"/>
					<xsl:with-param name="val1" select="substring($enddatestr,6,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'pq1'"/>
					<xsl:with-param name="val1" select="substring($enddatestr,5,1)"/>
				</xsl:call-template>
				<xsl:call-template name="FieldTemplate">
					<xsl:with-param name="name1" select="'pq2'"/>
					<xsl:with-param name="val1" select="substring($enddatestr,6,1)"/>
				</xsl:call-template>
				<xsl:if test="$month &lt; 4">
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'pq3'"/>
						<xsl:with-param name="val1" select="1"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$month>3 and $month &lt; 7">
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'pq3'"/>
						<xsl:with-param name="val1" select="2"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$month>6 and $month &lt; 10">
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'pq3'"/>
						<xsl:with-param name="val1" select="3"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$month>9">
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'pq3'"/>
						<xsl:with-param name="val1" select="4"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$type=1 or $type=2">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui1'"/><xsl:with-param name="val1" select="substring($ui,1,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui2'"/><xsl:with-param name="val1" select="substring($ui,2,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui3'"/><xsl:with-param name="val1" select="substring($ui,3,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui4'"/><xsl:with-param name="val1" select="substring($ui,4,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui5'"/><xsl:with-param name="val1" select="substring($ui,5,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui6'"/><xsl:with-param name="val1" select="substring($ui,6,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui7'"/><xsl:with-param name="val1" select="substring($ui,7,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui8'"/><xsl:with-param name="val1" select="substring($ui,8,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ui9'"/><xsl:with-param name="val1" select="substring($ui,9,1)"/></xsl:call-template>
					
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett1'"/><xsl:with-param name="val1" select="substring($ett,1,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett2'"/><xsl:with-param name="val1" select="substring($ett,2,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett3'"/><xsl:with-param name="val1" select="substring($ett,3,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett4'"/><xsl:with-param name="val1" select="substring($ett,4,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett5'"/><xsl:with-param name="val1" select="substring($ett,5,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett6'"/><xsl:with-param name="val1" select="substring($ett,6,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett7'"/><xsl:with-param name="val1" select="substring($ett,7,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett8'"/><xsl:with-param name="val1" select="substring($ett,8,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ett9'"/><xsl:with-param name="val1" select="substring($ett,9,1)"/></xsl:call-template>
					
				</xsl:if>
				<xsl:if test="$type=1 or $type=3">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi1'"/><xsl:with-param name="val1" select="substring($sdi,1,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi2'"/><xsl:with-param name="val1" select="substring($sdi,2,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi3'"/><xsl:with-param name="val1" select="substring($sdi,3,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi4'"/><xsl:with-param name="val1" select="substring($sdi,4,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi5'"/><xsl:with-param name="val1" select="substring($sdi,5,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi6'"/><xsl:with-param name="val1" select="substring($sdi,6,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi7'"/><xsl:with-param name="val1" select="substring($sdi,7,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi8'"/><xsl:with-param name="val1" select="substring($sdi,8,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'sdi9'"/><xsl:with-param name="val1" select="substring($sdi,9,1)"/></xsl:call-template>
					
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp1'"/><xsl:with-param name="val1" select="substring($sit,1,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp2'"/><xsl:with-param name="val1" select="substring($sit,2,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp3'"/><xsl:with-param name="val1" select="substring($sit,3,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp4'"/><xsl:with-param name="val1" select="substring($sit,4,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp5'"/><xsl:with-param name="val1" select="substring($sit,5,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp6'"/><xsl:with-param name="val1" select="substring($sit,6,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp7'"/><xsl:with-param name="val1" select="substring($sit,7,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp8'"/><xsl:with-param name="val1" select="substring($sit,8,1)"/></xsl:call-template>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'cp9'"/><xsl:with-param name="val1" select="substring($sit,9,1)"/></xsl:call-template>
					
				</xsl:if>

				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp1'"/><xsl:with-param name="val1" select="substring($total,1,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp2'"/><xsl:with-param name="val1" select="substring($total,2,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp3'"/><xsl:with-param name="val1" select="substring($total,3,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp4'"/><xsl:with-param name="val1" select="substring($total,4,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp5'"/><xsl:with-param name="val1" select="substring($total,5,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp6'"/><xsl:with-param name="val1" select="substring($total,6,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp7'"/><xsl:with-param name="val1" select="substring($total,7,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp8'"/><xsl:with-param name="val1" select="substring($total,8,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp9'"/><xsl:with-param name="val1" select="substring($total,9,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'tp10'"/><xsl:with-param name="val1" select="substring($total,10,1)"/></xsl:call-template>
					

			
			</Fields>
		</Report>
	</xsl:template>

</xsl:stylesheet>