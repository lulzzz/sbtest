<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../reports/Utils.xslt" />
  <xsl:param name="type"/>
	<xsl:param name="month"/>
	<xsl:param name="total"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:variable name="compDetails" select="translate(concat(/ReportResponse/Company/TaxFilingName, ', ' ,/ReportResponse/Company/BusinessAddress/AddressLine1,' ',/ReportResponse/Company/BusinessAddress/City,', ','CA',', ',/ReportResponse/Company/BusinessAddress/Zip),$smallcase,$uppercase)"/>
	
<xsl:output method="xml" indent="no"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledForm8109B</Name>
		<Reports>
			<xsl:apply-templates select="Company"/>
			
		</Reports>
	</ReportTransformed>
</xsl:template>

<xsl:template match="Company">
	<xsl:variable name="fein1" select="FederalEIN"/>
	<xsl:variable name="f940" select="sum(../PayChecks/PayCheck/Taxes/PayrollTax[Tax/Id = 6]/Amount)"/>
	<xsl:variable name="f941" select="sum(../PayChecks/PayCheck/Taxes/PayrollTax[Tax/Id &lt; 6]/Amount)"/>
	<Report>
		<TemplatePath>GovtForms\DepositCoupons\</TemplatePath>
		<Template>f8109.pdf</Template>
		<Fields>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1'"/><xsl:with-param name="val1" select="substring($fein1,1,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2'"/><xsl:with-param name="val1" select="substring($fein1,2,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f3'"/><xsl:with-param name="val1" select="substring($fein1,3,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f4'"/><xsl:with-param name="val1" select="substring($fein1,4,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f5'"/><xsl:with-param name="val1" select="substring($fein1,5,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f6'"/><xsl:with-param name="val1" select="substring($fein1,6,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f7'"/><xsl:with-param name="val1" select="substring($fein1,7,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f8'"/><xsl:with-param name="val1" select="substring($fein1,8,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f9'"/><xsl:with-param name="val1" select="substring($fein1,9,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'n1'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'a1'"/><xsl:with-param name="val1" select="translate(BusinessAddress/AddressLine1,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'c1'"/><xsl:with-param name="val1" select="translate(BusinessAddress/City,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'s1'"/><xsl:with-param name="val1" select="translate('CA',$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'z1'"/><xsl:with-param name="val1" select="concat(BusinessAddress/Zip,'-',BusinessAddress/ZipExtension)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ph1'"/><xsl:with-param name="val1" select="substring(../CompanyContact/Phone, 1,3)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ph2'"/><xsl:with-param name="val1" select="substring(../CompanyContact/Phone,4,7)"/></xsl:call-template>
		
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d1'"/><xsl:with-param name="val1" select="substring($total,1,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d2'"/><xsl:with-param name="val1" select="substring($total,2,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d3'"/><xsl:with-param name="val1" select="substring($total,3,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d4'"/><xsl:with-param name="val1" select="substring($total,4,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d5'"/><xsl:with-param name="val1" select="substring($total,5,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d6'"/><xsl:with-param name="val1" select="substring($total,6,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d7'"/><xsl:with-param name="val1" select="substring($total,7,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d8'"/><xsl:with-param name="val1" select="substring($total,8,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d9'"/><xsl:with-param name="val1" select="substring($total,9,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d10'"/><xsl:with-param name="val1" select="substring($total,10,1)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'d11'"/><xsl:with-param name="val1" select="substring($total,11,1)"/></xsl:call-template>
			
			<Field>
				<Name>
					
						<xsl:value-of select="635.4"/>
					
				</Name>
				<Type>Bullet</Type>
				<Value>
					<xsl:if test="$type=1">
						<xsl:value-of select="(792 - 134.9)"/>
					</xsl:if>
					<xsl:if test="$type=2">
						<xsl:if test="$month &lt; 4">
							<xsl:value-of select="(792 - 67)"/>
						</xsl:if>
						<xsl:if test="$month>3 and $month &lt; 7">
							<xsl:value-of select="(792 - 89.5)"/>
						</xsl:if>
						<xsl:if test="$month>6 and $month &lt; 10">
							<xsl:value-of select="(792 - 112)"/>
						</xsl:if>
						<xsl:if test="$month>9">
							<xsl:value-of select="(792 - 134.9)"/>
						</xsl:if>
					</xsl:if>
					
				</Value>
			</Field>
			<Field>
				<Name>
					<xsl:value-of select="542"/>
				</Name>
				<Type>Bullet</Type>
				<Value>
					<xsl:if test="$type=1">
						<xsl:value-of select="(792 - 180.2)"/>
					</xsl:if>
					<xsl:if test="$type=2">
						<xsl:value-of select="(792 - 67)"/>
					</xsl:if>

				</Value>
			</Field>
		</Fields>
	</Report>
</xsl:template>

</xsl:stylesheet>