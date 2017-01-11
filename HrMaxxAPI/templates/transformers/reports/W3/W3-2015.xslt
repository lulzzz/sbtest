<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
	
  <xsl:param name="todaydate"/>
	<xsl:param name="c"/>
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>


	<xsl:variable name="e" select="concat(substring(/ReportResponse/Company/FederalEIN,1,2),'-',substring(/ReportResponse/Company/FederalEIN,3,7))"/>
	<xsl:variable name="f" select="translate(/ReportResponse/Company/TaxFilingName,$smallcase,$uppercase)"/>
	<xsl:variable name="g" select="translate(concat(/ReportResponse/Company/BusinessAddress/AddressLine1,'\n',/ReportResponse/Company/BusinessAddress/City,', ','CA',', ',/ReportResponse/Company/BusinessAddress/Zip,'-',/ReportResponse/Company/BusinessAddress/ZipExtension),$smallcase,$uppercase)"/>
	<xsl:variable name="line15a" select="concat(substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>
	<xsl:variable name="line15" select="'CA'"/>
	
	<xsl:output method="xml" indent="yes"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledFormW3</Name>
		<Reports>
			<xsl:apply-templates select="CompanyAccumulation"/>
		</Reports>
	</ReportTransformed>	
</xsl:template>

<xsl:template match="CompanyAccumulation">

	<xsl:variable name="FITWage" select="format-number(Taxes/PayrollTax[Tax/Code='FIT']/TaxableWage,'###0.00')"/>
	<xsl:variable name="FITTax" select="format-number(Taxes/PayrollTax[Tax/Code='FIT']/Amount,'###0.00')"/>
	<xsl:variable name="SSWage" select="format-number(Taxes/PayrollTax[Tax/Code='SS_Employee']/TaxableWage,'###0.00')"/>
	<xsl:variable name="SSTax" select="format-number(Taxes/PayrollTax[Tax/Code='SS_Employee']/Amount,'###0.00')"/>
	<xsl:variable name="MDWage" select="format-number(Taxes/PayrollTax[Tax/Code='MD_Employee']/TaxableWage,'###0.00')"/>
	<xsl:variable name="MDTax" select="format-number(Taxes/PayrollTax[Tax/Code='MD_Employee']/Amount,'###0.00')"/>
	<xsl:variable name="Tips" select="format-number(sum(Compensations[PayType/Id=3]/Amount),'###0.00')"/>
	<xsl:variable name="SITWage" select="format-number(Taxes/PayrollTax[Tax/Code='SIT']/TaxableWage,'###0.00')"/>
	<xsl:variable name="SITTax" select="format-number(Taxes/PayrollTax[Tax/Code='SIT']/Amount,'###0.00')"/>
	<xsl:variable name="SDIWage" select="format-number(Taxes/PayrollTax[Tax/Code='SDI']/TaxableWage,'###0.00')"/>
	<xsl:variable name="SDITax" select="format-number(Taxes/PayrollTax[Tax/Code='SDI']/Amount,'###0.00')"/>
	
	<xsl:variable name="w212" select="format-number(sum(Deductions/PayrollDeduction[Deduction/Type/W2_12]/Amount),'###0.00')"/>
	
	<Report>
		<TemplatePath>GovtForms\W3\</TemplatePath>
		<Template>W3-<xsl:value-of select="$selectedYear"/>.pdf</Template>
		<Fields>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'c'"/><xsl:with-param name="val1" select="$c"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'e'"/><xsl:with-param name="val1" select="$e"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f'"/><xsl:with-param name="val1" select="$f"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'g'"/><xsl:with-param name="val1" select="$g"/></xsl:call-template>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'1'"/><xsl:with-param name="val1" select="$FITWage"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'2'"/><xsl:with-param name="val1" select="$FITTax"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'3'"/><xsl:with-param name="val1" select="$SSWage"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'4'"/><xsl:with-param name="val1" select="$SSTax"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'5'"/><xsl:with-param name="val1" select="$MDWage"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'6'"/><xsl:with-param name="val1" select="$MDTax"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'7'"/><xsl:with-param name="val1" select="$Tips"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'12'"/><xsl:with-param name="val1" select="$w212"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'15'"/><xsl:with-param name="val1" select="$line15"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'15a'"/><xsl:with-param name="val1" select="$line15a"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'16'"/><xsl:with-param name="val1" select="$SITWage"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'17'"/><xsl:with-param name="val1" select="$SITTax"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'18'"/><xsl:with-param name="val1" select="$SDIWage"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'19'"/><xsl:with-param name="val1" select="$SDITax"/></xsl:call-template>
			
		</Fields>
	
	</Report>
</xsl:template>	

</xsl:stylesheet>

  