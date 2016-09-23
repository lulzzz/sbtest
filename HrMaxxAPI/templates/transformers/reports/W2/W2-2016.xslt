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
	<xsl:variable name="compDetails" select="translate(concat(/ReportResponse/Company/TaxFilingName,'\n',/ReportResponse/Company/BusinessAddress/AddressLine1,'\n',/ReportResponse/Company/BusinessAddress/City,', ','CA',', ',/ReportResponse/Company/BusinessAddress/Zip,'-',/ReportResponse/Company/BusinessAddress/ZipExtension),$smallcase,$uppercase)"/>
	<xsl:variable name="sein" select="concat('CA',' ', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>
<xsl:output method="xml" indent="yes"/>

<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledFormW2Employee</Name>
		<Reports>
			<xsl:apply-templates select="EmployeeAccumulations/EmployeeAccumulation"/>
			<Report>
				<TemplatePath>GovtForms\W2\</TemplatePath>
				<Template>W2-page2.pdf</Template>
				<Fields>
				</Fields>
			</Report>
		</Reports>
	</ReportTransformed>	
</xsl:template>

<xsl:template match="EmployeeAccumulation">
	<xsl:variable name="ssn" select="concat(substring(Employee/SSN,1,3),'-',substring(Employee/SSN,4,2),'-',substring(Employee/SSN,6,4))"/>
	<xsl:variable name="empDetails" select="translate(concat(Employee/FirstName, ' ', Employee/LastName,'\n',Employee/Contact/Address/AddressLine1,'\n',Employee/Contact/Address/City,', ','CA',', ',Employee/Contact/Address/Zip,'-',Employee/Contact/Address/ZipExtension),$smallcase,$uppercase)"/>
	<xsl:variable name="FITWage" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=1]/TaxableWage,'###0.00')"/>
	<xsl:variable name="FITTax" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=1]/Amount,'###0.00')"/>
	<xsl:variable name="SSWage" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=4]/TaxableWage,'###0.00')"/>
	<xsl:variable name="SSTax" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=4]/Amount,'###0.00')"/>
	<xsl:variable name="MDWage" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=2]/TaxableWage,'###0.00')"/>
	<xsl:variable name="MDTax" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=2]/Amount,'###0.00')"/>
	<xsl:variable name="Tips" select="format-number(sum(Accumulation/Compensations[PayType/Id=3]/Amount),'###0.00')"/>
	<xsl:variable name="SITWage" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=7]/TaxableWage,'###0.00')"/>
	<xsl:variable name="SITTax" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=7]/Amount,'###0.00')"/>
	<xsl:variable name="SDIWage" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=8]/TaxableWage,'###0.00')"/>
	<xsl:variable name="SDITax" select="format-number(Accumulation/Taxes/PayrollTax[Tax/Id=8]/Amount,'###0.00')"/>
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
			<xsl:apply-templates select="Accumulation/Deductions/PayrollDeduction[Deduction/Type/W2_12]">
				<xsl:sort select="Deduction/Type/W2_12" order="descending"/>
			</xsl:apply-templates>
			<xsl:if test="count(Employee/Deductions[EmployeeDeduction/Deduction/Type/W2_13R])>0">
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
<xsl:template match="PayrollDeduction">
	<xsl:if test="position()=1">
		<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'12a'"/><xsl:with-param name="val" select="concat(Deduction/Type/W2_12,' ',format-number(Amount,'###0.00'))"/><xsl:with-param name="iter" select="3"/></xsl:call-template>	
	</xsl:if>
	<xsl:if test="position()=2">
		<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'12b'"/><xsl:with-param name="val" select="concat(Deduction/Type/W2_12,' ',format-number(Amount,'###0.00'))"/><xsl:with-param name="iter" select="3"/></xsl:call-template>	
	</xsl:if>
	<xsl:if test="position()=3">
		<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'12c'"/><xsl:with-param name="val" select="concat(Deduction/Type/W2_12,' ',format-number(Amount,'###0.00'))"/><xsl:with-param name="iter" select="3"/></xsl:call-template>	
	</xsl:if>
	<xsl:if test="position()=4">
		<xsl:call-template name="W2Repeater"><xsl:with-param name="prefix" select="'12d'"/><xsl:with-param name="val" select="concat(Deduction/Type/W2_12,' ',format-number(Amount,'###0.00'))"/><xsl:with-param name="iter" select="3"/></xsl:call-template>	
	</xsl:if>
	
</xsl:template>


</xsl:stylesheet>

  