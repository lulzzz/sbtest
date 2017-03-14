<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
	
  <xsl:param name="todaydate"/>
  <xsl:param name="quarter"/>
  <xsl:param name="quarterEndDate"/>
  <xsl:param name="dueDate"/>
  <xsl:param name="dueDate2"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:variable name="fein" select="concat(substring(/ReportResponse/Company/FederalEIN,1,2),'-',substring(/ReportResponse/Company/FederalEIN,3,7))"/>
	<xsl:variable name="address" select="translate(concat(/ReportResponse/Company/TaxFilingName,'\n',/ReportResponse/Company/BusinessAddress/AddressLine1,'\n',/ReportResponse/Company/BusinessAddress/City,', ','CA',', ',/ReportResponse/Company/BusinessAddress/Zip,'-',/ReportResponse/Company/BusinessAddress/ZipExtension),$smallcase,$uppercase)"/>
	<xsl:variable name="sein" select="concat(substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>

	<xsl:variable name="TotalGrossPay" select="format-number(/ReportResponse/CompanyAccumulations/PayCheckWages/GrossWage,'###0.00')"/>
	<xsl:variable name="SUIRate">
		<xsl:choose>
			<xsl:when test="/ReportResponse/Company/Contract/InvoiceSetup/InvoiceType='PEOASOCoCheck'">
				<xsl:value-of select="/ReportResponse/Host/Company/CompanyTaxRates/CompanyTaxRate[TaxId=10 and TaxYear=$selectedYear]/Rate"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/ReportResponse/Company/CompanyTaxRates/CompanyTaxRate[TaxId=10 and TaxYear=$selectedYear]/Rate"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ETTRate">
		<xsl:choose>
			<xsl:when test="/ReportResponse/Company/Contract/InvoiceSetup/InvoiceType='PEOASOCoCheck'">
				<xsl:value-of select="/ReportResponse/Host/Company/CompanyTaxRates/CompanyTaxRate[TaxId=9 and TaxYear=$selectedYear]/Rate"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/ReportResponse/Company/CompanyTaxRates/CompanyTaxRate[TaxId=9 and TaxYear=$selectedYear]/Rate"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="SUIWage" select="format-number(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SUI']/YTDWage,'###0.00')"/>
	<xsl:variable name="UIContribution" select="format-number($SUIWage*$SUIRate div 100,'###0.00')"/>
	
	<xsl:variable name="ETTWage" select="format-number(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='ETT']/YTDWage,'###0.00')"/>
	<xsl:variable name="ETTContribution" select="format-number($ETTWage*$ETTRate div 100,'###0.00')"/>
	<xsl:variable name="SDIRate" select="format-number(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SDI']/Tax/Rate,'###0.00')"/>
	<xsl:variable name="SDIWage" select="format-number(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage,'###0.00')"/>
	<xsl:variable name="SDIContribution" select="format-number($SDIWage*$SDIRate div 100,'###0.00')"/>
	<xsl:variable name="SITTax" select="format-number(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SIT']/YTD,'###0.00')"/>
	<xsl:variable name="SUITax" select="format-number(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SUI']/YTD,'###0.00')"/>
	<xsl:variable name="SDITax" select="format-number(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SDI']/YTD,'###0.00')"/>
	<xsl:variable name="ETTTax" select="format-number(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='ETT']/YTD,'###0.00')"/>
	<xsl:variable name="box18" select="format-number($UIContribution + $ETTContribution + $SDIContribution + $SITTax,'###0.00')"/>
	<xsl:variable name="TotalStateTax" select="format-number($SITTax + $SUITax + $SDITax + $ETTTax,'###0.00')"/>
	<xsl:variable name="Total" select="format-number($box18 - $TotalStateTax,'###0.00')"/>
	
<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="ReportResponse">
		<ReportTransformed>
			<Name>FilledFormDE9</Name>
			<Reports>
				<xsl:apply-templates select="Company"/>
			</Reports>
		</ReportTransformed>
	</xsl:template>

<xsl:template match="Company">	
	<Report>
		<TemplatePath>GovtForms\CAForms\</TemplatePath>
		<Template>DE9.pdf</Template>
		<Fields>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'1'"/><xsl:with-param name="val1" select="$quarterEndDate"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'2'"/><xsl:with-param name="val1" select="$dueDate"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'3'"/><xsl:with-param name="val1" select="$dueDate2"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'year'"/><xsl:with-param name="val1" select="$selectedYear"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'Quarter'"/><xsl:with-param name="val1" select="$quarter"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'4'"/><xsl:with-param name="val1" select="translate($sein,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'5'"/><xsl:with-param name="val1" select="$address"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'6'"/><xsl:with-param name="val1" select="$fein"/></xsl:call-template>
			
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'9'"/><xsl:with-param name="val1" select="$TotalGrossPay"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'10'"/><xsl:with-param name="val1" select="format-number($SUIRate,'###0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'11'"/><xsl:with-param name="val1" select="$SUIWage"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'12'"/><xsl:with-param name="val1" select="$UIContribution"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'13'"/><xsl:with-param name="val1" select="format-number($ETTRate,'###0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'14'"/><xsl:with-param name="val1" select="$ETTContribution"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'F1'"/><xsl:with-param name="val1" select="format-number($SDIRate,'###0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'15'"/><xsl:with-param name="val1" select="format-number($SDIWage,'###0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'16'"/><xsl:with-param name="val1" select="$SDIContribution"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'17'"/><xsl:with-param name="val1" select="$SITTax"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'18'"/><xsl:with-param name="val1" select="format-number($box18,'###0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'19'"/><xsl:with-param name="val1" select="format-number($TotalStateTax,'###0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'20'"/><xsl:with-param name="val1" select="format-number($Total,'###0.00')"/></xsl:call-template>
			

			
			
		</Fields>
	</Report>
</xsl:template>	
</xsl:stylesheet>

  