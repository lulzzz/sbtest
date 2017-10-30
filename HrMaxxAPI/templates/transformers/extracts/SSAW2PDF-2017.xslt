<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../reports/Utils.xslt" />
<xsl:param name="selectedYear"/>
	
  <xsl:param name="todaydate"/>
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	
<xsl:output method="xml" indent="yes"/>

<xsl:template match="ExtractResponse">
	<ReportTransformed>
		<Name>FilledFormW2EmployeeBatch</Name>
		<Reports>
			<xsl:apply-templates select="Hosts/ExtractHost/EmployeeAccumulationList/Accumulation"/>
			<Report>
				<TemplatePath>GovtForms\W2\</TemplatePath>
				<Template>W2-page2.pdf</Template>
				<Fields>
				</Fields>
			</Report>
		</Reports>
	</ReportTransformed>	
</xsl:template>

<xsl:template match="Accumulation">
	<xsl:variable name="fein" select="concat(substring(/../../HostCompany/FederalEIN,1,2),'-',substring(../../HostCompany/FederalEIN,3,7))"/>
	<xsl:variable name="compDetails" select="translate(concat(../../HostCompany/TaxFilingName,'\n',../../HostCompany/BusinessAddress/AddressLine1,'\n',../../HostCompany/BusinessAddress/City,', ','CA',', ',../../HostCompany/BusinessAddress/Zip,'-',../../HostCompany/BusinessAddress/ZipExtension),$smallcase,$uppercase)"/>
	<xsl:variable name="sein" select="concat('CA',' ', substring(../../HostCompany/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring(../../HostCompany/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring(../../HostCompany/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>

	<xsl:variable name="ssn" select="concat(substring(SSNVal,1,3),'-',substring(SSNVal,4,2),'-',substring(SSNVal,6,4))"/>
	<xsl:variable name="empDetails" select="translate(concat(FirstName, ' ', LastName,'\n',Contact/Address/AddressLine1,'\n',Contact/Address/AddressLine2),$smallcase,$uppercase)"/>
	<xsl:variable name="FITWage" select="format-number(Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage,'###0.00')"/>
	<xsl:variable name="FITTax" select="format-number(Taxes/PayCheckTax[Tax/Code='FIT']/YTD,'###0.00')"/>
	<xsl:variable name="SSWage" select="format-number(Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage,'###0.00')"/>
	<xsl:variable name="SSTax" select="format-number(Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTD,'###0.00')"/>
	<xsl:variable name="MDWage" select="format-number(Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage,'###0.00')"/>
	<xsl:variable name="MDTax" select="format-number(Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTD,'###0.00')"/>
	<xsl:variable name="Tips" select="format-number(sum(Compensations/PayCheckCompensation[PayTypeId=3]/YTD),'###0.00')"/>
	<xsl:variable name="SITWage" select="format-number(Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage,'###0.00')"/>
	<xsl:variable name="SITTax" select="format-number(Taxes/PayCheckTax[Tax/Code='SIT']/YTD,'###0.00')"/>
	<xsl:variable name="SDIWage" select="format-number(Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage,'###0.00')"/>
	<xsl:variable name="SDITax" select="format-number(Taxes/PayCheckTax[Tax/Code='SDI']/YTD,'###0.00')"/>
	<Report>
		<TemplatePath>GovtForms\W2\</TemplatePath>
		<Template>W2-<xsl:value-of select="$selectedYear"/>.pdf</Template>
		<Fields>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'year1'"/><xsl:with-param name="val1" select="$selectedYear"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'year11'"/><xsl:with-param name="val1" select="$selectedYear"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'year111'"/><xsl:with-param name="val1" select="$selectedYear"/></xsl:call-template>
			
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'b'"/><xsl:with-param name="val" select="$fein"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'c'"/><xsl:with-param name="val" select="$compDetails"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'d'"/><xsl:with-param name="val" select="$ssn"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'e'"/><xsl:with-param name="val" select="$empDetails"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'1'"/><xsl:with-param name="val" select="$FITWage"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'2'"/><xsl:with-param name="val" select="$FITTax"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'3'"/><xsl:with-param name="val" select="$SSWage"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'4'"/><xsl:with-param name="val" select="$SSTax"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'5'"/><xsl:with-param name="val" select="$MDWage"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'6'"/><xsl:with-param name="val" select="$MDTax"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'7'"/><xsl:with-param name="val" select="$Tips"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:apply-templates select="Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/W2_12]">
				<xsl:sort select="CompanyDeduction/DeductionType/W2_12" order="descending"/>
			</xsl:apply-templates>
			<xsl:if test="count(Deductions[CompanyDeduction/DeductionType/W2_13R])>0">
				<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'13b_1'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
				<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'13b_2'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
				<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'13b_3'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
			</xsl:if>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'15'"/><xsl:with-param name="val" select="$sein"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'16'"/><xsl:with-param name="val" select="$SITWage"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'17'"/><xsl:with-param name="val" select="$SITTax"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'18'"/><xsl:with-param name="val" select="$SDIWage"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'19'"/><xsl:with-param name="val" select="$SDITax"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'20'"/><xsl:with-param name="val" select="'CASDI'"/><xsl:with-param name="iter" select="3"/></xsl:call-template>
			
		</Fields>
	
	</Report>
</xsl:template>	
<xsl:template name="W2Repeater">
	<xsl:param name="prefix"/>
	<xsl:param name="val"/>
	<xsl:param name="iter"/>
	
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="concat($prefix,'_',$iter)"/><xsl:with-param name="val1" select="$val"/></xsl:call-template>
	<xsl:if test="$iter>1">
		<xsl:call-template name="W2Repeater">
			<xsl:with-param name="prefix" select="$prefix"/>
			<xsl:with-param name="val" select="$val"/>
			<xsl:with-param name="iter" select="$iter - 1"/>
		</xsl:call-template>
	</xsl:if>

</xsl:template>
<xsl:template match="PayCheckDeduction">
	<xsl:if test="position()=1">
		<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'12a'"/><xsl:with-param name="val" select="concat(CompanyDeduction/DeductionType/W2_12,' ',format-number(YTD,'###0.00'))"/><xsl:with-param name="iter" select="3"/></xsl:call-template>	
	</xsl:if>
	<xsl:if test="position()=2">
		<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'12b'"/><xsl:with-param name="val" select="concat(CompanyDeduction/DeductionType/W2_12,' ',format-number(YTD,'###0.00'))"/><xsl:with-param name="iter" select="3"/></xsl:call-template>	
	</xsl:if>
	<xsl:if test="position()=3">
		<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'12c'"/><xsl:with-param name="val" select="concat(CompanyDeduction/DeductionType/W2_12,' ',format-number(YTD,'###0.00'))"/><xsl:with-param name="iter" select="3"/></xsl:call-template>	
	</xsl:if>
	<xsl:if test="position()=4">
		<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'12d'"/><xsl:with-param name="val" select="concat(CompanyDeduction/DeductionType/W2_12,' ',format-number(YTD,'###0.00'))"/><xsl:with-param name="iter" select="3"/></xsl:call-template>	
	</xsl:if>
	
</xsl:template>


</xsl:stylesheet>

  