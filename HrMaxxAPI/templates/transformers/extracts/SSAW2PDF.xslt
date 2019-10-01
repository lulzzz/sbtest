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
			<xsl:apply-templates select="Companies/ExtractCompany"/>
			
		</Reports>
	</ReportTransformed>	
</xsl:template>
	<xsl:template match="ExtractCompany">
		<xsl:variable name="comphostid" select="Company/HostId"/>
		<xsl:variable name="host" select ="/ExtractResponse/Hosts[ExtractHost/Host/Id=$comphostid]/ExtractHost"/>
		<xsl:variable name="compstate" select="Company/BusinessAddress/StateId"/>
		<Report>
			<TemplatePath></TemplatePath>
			<Template>W2Employee<xsl:value-of select="translate(Company/TaxFilingName,$smallcase,$uppercase)"/></Template>
			<ReportType>Html</ReportType>
			<HtmlData>
				<html>
					<body>
						<div align="center">
							<h3>
								<xsl:value-of select="translate(Company/TaxFilingName,$smallcase,$uppercase)"/>
							</h3>
							<br/>
							<h4>
								<xsl:value-of select="translate(Company/BusinessAddress/AddressLine1,$smallcase,$uppercase)"/>
							</h4>
							<h4>
								<xsl:value-of select="translate(concat(Company/BusinessAddress/City,', ',$host/States[CompanyTaxState/State/StateId=$compstate]/CompanyTaxState/State/Abbreviation,', ', Company/BusinessAddress/Zip),$smallcase,$uppercase)"/>
							</h4>
							<br/>
							<br/>
							<h5>
								W2 Employee Forms: <xsl:value-of select="count(EmployeeAccumulationList/Accumulation)"/>
							</h5>
						</div>
					</body>
				</html>

			</HtmlData>

		</Report>
		<xsl:apply-templates select="EmployeeAccumulationList/Accumulation">
			<xsl:sort select="FirstName"/>
		</xsl:apply-templates>
	</xsl:template>
	
<xsl:template match="Accumulation">
	<xsl:variable name="comphostid" select="../../Company/HostId"/>
	<xsl:variable name="hostcompanyid" select="../../HostCompanyId"/>
	
	<xsl:variable name="host" select="/ExtractResponse/Hosts/ExtractHost[HostCompany/Id=$hostcompanyid]"/>
	<xsl:variable name="hostcompany" select="$host/HostCompany"/>
	<xsl:variable name="fein" select="concat(substring($hostcompany/FederalEIN,1,2),'-',substring($hostcompany/FederalEIN,3,7))"/>
	<xsl:variable name="compDetails" select="translate(concat($hostcompany/TaxFilingName,'\n',$hostcompany/BusinessAddress/AddressLine1,'\n',$hostcompany/BusinessAddress/City,', ',$hostcompany/BusinessAddress/StateCode,', ',$hostcompany/BusinessAddress/Zip,'-',$hostcompany/BusinessAddress/ZipExtension),$smallcase,$uppercase)"/>
	<xsl:variable name="sein" select="concat($hostcompany/BusinessAddress/StateCode,' ', substring($host/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring($host/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring($host/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>

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

  