<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
	
  <xsl:param name="todaydate"/>
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:variable name="fein" select="concat(substring(/ReportResponse/Company/FederalEIN,1,2),'-',substring(/ReportResponse/Company/FederalEIN,3,7))"/>
	<xsl:variable name="compDetails" select="translate(concat(/ReportResponse/Company/BusinessAddress/AddressLine1,'\n',/ReportResponse/Company/BusinessAddress/City,', ',/ReportResponse/Company/BusinessAddress/StateCode,', ',/ReportResponse/Company/BusinessAddress/Zip,'-',/ReportResponse/Company/BusinessAddress/ZipExtension),$smallcase,$uppercase)"/>
	<xsl:variable name="sein" select="concat(/ReportResponse/Company/BusinessAddress/StateCode,' ', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>
<xsl:output method="xml" indent="no"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledForm1099</Name>
		<Reports>
      <xsl:apply-templates select="VendorList/CompanyVendor/Vendor">
        <xsl:sort select="Name" data-type="text"/>
      </xsl:apply-templates>
			<xsl:apply-templates select="Company"/>
		</Reports>
	</ReportTransformed>
</xsl:template>

<xsl:template match="Company">
	
	<Report>
		<TemplatePath>GovtForms\1099\</TemplatePath>
		<Template>f1096-<xsl:value-of select="$selectedYear"/>.pdf</Template>
		<Fields>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compName'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:apply-templates select="BusinessAddress"/>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compFein'"/><xsl:with-param name="val1" select="$fein"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'numForms'"/><xsl:with-param name="val1" select="count(../VendorList/CompanyVendor)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'totalAmt'"/><xsl:with-param name="val1" select="format-number(sum(../VendorList/CompanyVendor/Amount),'#,##0.00')"/></xsl:call-template>
			<xsl:variable name="mscCount" select="count(../VendorList/CompanyVendor[Vendor/Type1099='MISC'])"/>
			<xsl:variable name="intCount" select="count(../VendorList/CompanyVendor[Vendor/Type1099='INT'])"/>
			<xsl:variable name="divCount" select="count(../VendorList/CompanyVendor[VendorType1099='DIV'])"/>
			<xsl:if test="$mscCount>0"><xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'chkMisc'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template></xsl:if>
			<xsl:if test="$intCount>0"><xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'chkInt'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template></xsl:if>
			<xsl:if test="$divCount>0"><xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'chkDiv'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template></xsl:if>
		</Fields>
	</Report>
	
	
</xsl:template>
<xsl:template match="BusinessAddress">
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compAddress'"/><xsl:with-param name="val1" select="translate(AddressLine1,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compAddress1'"/><xsl:with-param name="val1" select="translate(concat(City,', ',StateCode),$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'contactName'"/><xsl:with-param name="val1" select="translate(concat(../../CompanyContact/FirstName,' ',../../CompanyContact/LastName),$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:if test="../../CompanyContact/Phone"><xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'phone'"/><xsl:with-param name="val1" select="concat('(',substring(../../CompanyContact/Phone,1,3),') ',substring(../../CompanyContact/Phone,4,3),'-',substring(../../CompanyContact/Phone,7,11))"/></xsl:call-template></xsl:if>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'email'"/><xsl:with-param name="val1" select="translate(../../CompanyContact/Email,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:if test="../../CompanyContact/Fax"><xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'fax'"/><xsl:with-param name="val1" select="concat('(',substring(../../CompanyContact/Fax,1,3),') ',substring(../../CompanyContact/Fax,4,3),'-',substring(../../CompanyContact/Fax,7,11))"/></xsl:call-template></xsl:if>				
</xsl:template>

<xsl:template match="Vendor">
	<Report>
		<TemplatePath>GovtForms\1099\</TemplatePath>
		<xsl:choose>
			<xsl:when test="Type1099='MISC'">
				<Template>f1099msc-<xsl:value-of select="$selectedYear"/>.pdf</Template>					
			</xsl:when>
			<xsl:when test="Type1099='INT'">
				<Template>f1099int-<xsl:value-of select="$selectedYear"/>.pdf</Template>											
			</xsl:when>
			<xsl:otherwise>
				<Template>f1099div-<xsl:value-of select="$selectedYear"/>.pdf</Template>									
			</xsl:otherwise>
		</xsl:choose>
		<Fields>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compName'"/><xsl:with-param name="val1" select="translate(/ReportResponse/Company/TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compAddress'"/><xsl:with-param name="val1" select="translate($compDetails,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compFein'"/><xsl:with-param name="val1" select="translate($fein,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="IndividualSSN=''">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'vendorEin'"/><xsl:with-param name="val1" select="concat(substring(BusinessFIN,1,2),'-',substring(BusinessFIN,3,7))"/></xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'vendorEin'"/><xsl:with-param name="val1" select="concat(substring(IndividualSSN,1,3),'-',substring(IndividualSSN,4,2),'-',substring(IndividualSSN,6,4))"/></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'vendorName'"/><xsl:with-param name="val1" select="translate(Name,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'vendorAddress'"/><xsl:with-param name="val1" select="translate(Contact/Address/AddressLine1,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'vendorCity'"/><xsl:with-param name="val1" select="translate(concat(Contact/Address/City,', ',Contact/Address/StateCode,', ',Contact/Address/Zip),$smallcase,$uppercase)"/></xsl:call-template>
			
			<xsl:choose>
				<xsl:when test="Type1099='MISC'">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'compSein'"/><xsl:with-param name="val1" select="$sein"/></xsl:call-template>		
					<xsl:choose>
						<xsl:when test="SubType1099='NonEmployeeComp'">
							<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'nonEmpComp'"/><xsl:with-param name="val1" select="format-number(../Amount,'#,##0.00')"/></xsl:call-template>
						</xsl:when>
						<xsl:when test="SubType1099='OtherIncome'">
							<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'otherIncome'"/><xsl:with-param name="val1" select="format-number(../Amount,'#,##0.00')"/></xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'rents'"/><xsl:with-param name="val1" select="format-number(../Amount,'#,##0.00')"/></xsl:call-template>
						</xsl:otherwise>	
					</xsl:choose>
				</xsl:when>
				<xsl:when test="Type1099='INT'">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'interestIncome'"/><xsl:with-param name="val1" select="format-number(../Amount,'#,##0.00')"/></xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="SubType1099='OrdinaryDividend'">
							<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ordDividend'"/><xsl:with-param name="val1" select="format-number(../Amount,'#,##0.00')"/></xsl:call-template>
						</xsl:when>
						<xsl:when test="SubType1099='QualifiedDividend'">
							<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'qualifiedDividend'"/><xsl:with-param name="val1" select="format-number(../Amount,'#,##0.00')"/></xsl:call-template>
						</xsl:when>
						<xsl:when test="SubType1099='CaptialGainDist'">
							<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'capitalGain'"/><xsl:with-param name="val1" select="format-number(../Amount,'#,##0.00')"/></xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'nonDividedDividend'"/><xsl:with-param name="val1" select="format-number(../Amount,'#,##0.00')"/></xsl:call-template>
						</xsl:otherwise>	
					</xsl:choose>
				</xsl:otherwise>
			
			</xsl:choose>

		</Fields>
	</Report>
</xsl:template>

</xsl:stylesheet>

  