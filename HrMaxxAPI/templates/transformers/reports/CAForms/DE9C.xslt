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
	
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:variable name="employeeCount" select="count(/ReportResponse/EmployeeAccumulationList/Accumulation)"/>
	<xsl:variable name="pages" select="ceiling($employeeCount div 7)"/>
	<xsl:variable name="sein" select="concat(substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>
	<xsl:variable name="count1" select ="/ReportResponse/CompanyAccumulations/PayCheckWages/Twelve1"/>
	<xsl:variable name="count2" select ="/ReportResponse/CompanyAccumulations/PayCheckWages/Twelve2"/>
	<xsl:variable name="count3" select ="/ReportResponse/CompanyAccumulations/PayCheckWages/Twelve3"/>
<xsl:output method="xml" indent="yes"/>
	<xsl:template match="ReportResponse">
		<ReportTransformed>
			<Name>FilledFormDE9C</Name>
			<Reports>
				<xsl:apply-templates select="Company"/>
			</Reports>
		</ReportTransformed>
	</xsl:template>
<xsl:template match="Company">	
	
	<xsl:call-template name="DE6Page">
		<xsl:with-param name="currPage" select="'1'"/>
		<xsl:with-param name="totalPages" select="$pages"/>
		<xsl:with-param name="comp" select="."/>
	
	</xsl:call-template>
</xsl:template>	
<xsl:template name="DE6Page">
	<xsl:param name="currPage"/>
	<xsl:param name="totalPages"/>
	<xsl:param name="comp"/>
	
	<Report>
		<TemplatePath>GovtForms\CAForms\</TemplatePath>
		<Template>DE9C.pdf</Template>
		<Fields>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'1'"/><xsl:with-param name="val1" select="$currPage"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'2'"/><xsl:with-param name="val1" select="$totalPages"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'3'"/><xsl:with-param name="val1" select="$quarterEndDate"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'4'"/><xsl:with-param name="val1" select="$dueDate"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'5'"/><xsl:with-param name="val1" select="substring($selectedYear,3,2)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'6'"/><xsl:with-param name="val1" select="$quarter"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="$quarter=1">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'4a'"/><xsl:with-param name="val1" select="concat('4/30/',$selectedYear)"/></xsl:call-template>
				</xsl:when>
				<xsl:when test="$quarter=2">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'4a'"/><xsl:with-param name="val1" select="concat('7/31/',$selectedYear)"/></xsl:call-template>
				</xsl:when>
				<xsl:when test="$quarter=3">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'4a'"/><xsl:with-param name="val1" select="concat('10/30/',$selectedYear)"/></xsl:call-template>
				</xsl:when>
				<xsl:when test="$quarter=4">
					<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'4a'"/><xsl:with-param name="val1" select="concat('1/31/',$selectedYear+1)"/></xsl:call-template>
				</xsl:when>				
			</xsl:choose>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'7'"/><xsl:with-param name="val1" select="translate($sein,'-','')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'8'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'9'"/>
				<xsl:with-param name="val1" select="translate(BusinessAddress/AddressLine1,$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'10'"/>
				<xsl:with-param name="val1" select="translate('',$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'10a'"/>
				<xsl:with-param name="val1" select="translate(BusinessAddress/AddressLine2,$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'11'"/><xsl:with-param name="val1" select="$count1"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'12'"/><xsl:with-param name="val1" select="$count2"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'13'"/><xsl:with-param name="val1" select="$count3"/></xsl:call-template>
			<xsl:variable name="start" select="7*($currPage - 1)"/>
			<xsl:variable name="end">
				<xsl:choose>
					<xsl:when test="$employeeCount>($start+7)"><xsl:value-of select="$start+8"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$employeeCount+1"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:apply-templates select="../EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]">
				<xsl:with-param name="currPage" select="$currPage"/>
			</xsl:apply-templates>
			<xsl:variable name="pageSubjectWages" select="sum(../EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]/PayCheckWages/GrossWage) - sum(../EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]/Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=9]/Amount)"/>
			<xsl:variable name="pagePITWages" select="sum(../EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]/Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage)"/>
			<xsl:variable name="pagePIT" select="sum(../EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]/Taxes/PayCheckTax[Tax/Code='SIT']/YTD)"/>
			<xsl:variable name="totalSubjectWages" select="../CompanyAccumulations/PayCheckWages/GrossWage - sum(../CompanyAccumulations/Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=9]/YTD)"/>
			<xsl:variable name="totalPITWages" select="../CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage"/>
			<xsl:variable name="totalPIT" select="../CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SIT']/YTD"/>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'67'"/><xsl:with-param name="val1" select="format-number($pageSubjectWages,'#####0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'68'"/><xsl:with-param name="val1" select="format-number($pagePITWages,'#####0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'69'"/><xsl:with-param name="val1" select="format-number($pagePIT,'#####0.00')"/></xsl:call-template>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'70'"/><xsl:with-param name="val1" select="format-number($totalSubjectWages,'#####0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'71'"/><xsl:with-param name="val1" select="format-number($totalPITWages,'#####0.00')"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'72'"/><xsl:with-param name="val1" select="format-number($totalPIT,'#####0.00')"/></xsl:call-template>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'73'"/><xsl:with-param name="val1" select="'Preparer'"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'74'"/><xsl:with-param name="val1" select="substring(../Contact/Phone,1,3)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'75'"/><xsl:with-param name="val1" select="concat(substring(../Contact/Phone,4,3), ' ', substring(../Contact/Phone,7,4))"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'76'"/><xsl:with-param name="val1" select="$todaydate"/></xsl:call-template>
			
		</Fields>
	</Report>
	<xsl:if test="$totalPages>$currPage">
		<xsl:call-template name="DE6Page">
			<xsl:with-param name="currPage" select="$currPage+1"/>
			<xsl:with-param name="totalPages" select="$totalPages"/>
			<xsl:with-param name="comp" select="$comp"/>		
		</xsl:call-template>
	</xsl:if>
	
</xsl:template>
	<xsl:template match="Accumulation">
	<xsl:param name="currPage"/>
	<xsl:variable name="starter" select="7*(position() - 1) + 18"/>
	<xsl:variable name="subjectWages" select="format-number(PayCheckWages/GrossWage - sum(Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/Id=9]/YTD),'#,##0.00')"/>
	<xsl:variable name="PITWages" select="format-number(Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage,'#,##0.00')"/>
	<xsl:variable name="PIT" select="format-number(Taxes/PayCheckTax[Tax/Code='SIT']/YTD,'#,##0.00')"/>
	<xsl:variable name="ssn" select="concat(substring(SSNVal,1,3),'-',substring(SSNVal,4,2),'-',substring(SSNVal,6,4))"/>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$starter"/><xsl:with-param name="val1" select="$ssn"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$starter+1"/><xsl:with-param name="val1" select="FirstName"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$starter+2"/><xsl:with-param name="val1" select="MiddleInitial"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$starter+3"/><xsl:with-param name="val1" select="LastName"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$starter+4"/><xsl:with-param name="val1" select="$subjectWages"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$starter+5"/><xsl:with-param name="val1" select="$PITWages"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$starter+6"/><xsl:with-param name="val1" select="$PIT"/></xsl:call-template>
	
</xsl:template>

</xsl:stylesheet>

  