<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
<xsl:param name="quarterEndDate"/>
  <xsl:param name="enddate"/>
<xsl:param name="today"/>
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="fein" select="/ReportResponse/Company/FederalEIN"/>
<xsl:variable name="accountnumber" select="/ReportResponse/Company/States/CompanyTaxState[State/StateId=25]/StateUIAccount"/>
<xsl:variable name="sein" select="translate(/ReportResponse/Company/States/CompanyTaxState[State/StateId=25]/StateEIN, $smallcase, $uppercase)"/>
  <xsl:variable name="TotalWages" select="format-number(sum(/ReportResponse/CompanyAccumulations/PayCheckWages/GrossWage),'##########0.00')"/>
  <xsl:variable name="TotalUIWages" select="format-number(sum(/ReportResponse/CompanyAccumulations/ApplicableWages),'##########0.00')"/>
  <xsl:variable name="TotalUITax" select="format-number(sum(/ReportResponse/CompanyAccumulations/ApplicableAmounts),'##########0.00')"/>
  <xsl:variable name="TotalEWages" select="format-number($TotalWages - $TotalUIWages,'##########0.00')"/>
	<xsl:variable name="WagesPage1" select="format-number(sum(/ReportResponse/EmployeeAccumulationList/Accumulation[position()>0 and position() &lt; 13]/ApplicableWages),'########0.00')"/>
  <xsl:variable name="GrossPage1" select="format-number(sum(/ReportResponse/EmployeeAccumulationList/Accumulation[position()>0 and position() &lt; 13]/PayCheckWages/GrossWage),'########0.00')"/>
  <xsl:variable name="WagesEPage1" select="format-number($GrossPage1 - WagesPage1,'########0.00')"/>
<xsl:variable name="OtherPageWages" select="format-number(sum(/ReportResponse/EmployeeAccumulationList/Accumulation[position()>12]/ApplicableWages),'########0.00')"/>

<xsl:variable name="employeeCount" select="count(/ReportResponse/EmployeeAccumulationList/Accumulation)"/>


<xsl:variable name="count1" select ="/ReportResponse/CompanyAccumulations/PayCheckWages/Twelve1"/>
<xsl:variable name="count2" select ="/ReportResponse/CompanyAccumulations/PayCheckWages/Twelve2"/>
<xsl:variable name="count3" select ="/ReportResponse/CompanyAccumulations/PayCheckWages/Twelve3"/>
<xsl:variable name="SUIRate">
  <xsl:choose>
    <xsl:when test="/ReportResponse/Company/FileUnderHost='true'">
      <xsl:value-of select="/ReportResponse/Host/Company/CompanyTaxRates/CompanyTaxRate[TaxId=18 and TaxYear=$selectedYear]/Rate"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="/ReportResponse/Company/CompanyTaxRates/CompanyTaxRate[TaxId=18 and TaxYear=$selectedYear]/Rate"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="ReportResponse">
		<ReportTransformed>
			<Name>FilledFormMT-UI-5</Name>
			<Reports>
				<xsl:apply-templates select="Company"/>
			</Reports>
		</ReportTransformed>
	</xsl:template>

<xsl:template match="Company">
  <Report>
		<TemplatePath>GovtForms\MTForms\</TemplatePath>
		<Template>UI-5.pdf</Template>
		<Fields>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'1'"/>
        <xsl:with-param name="val1" select="$fein"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'2'"/>
        <xsl:with-param name="val1" select="$accountnumber"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'3'"/>
        <xsl:with-param name="val1" select="$quarterEndDate"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'rate'"/>
        <xsl:with-param name="val1" select="format-number($SUIRate, '##.00')"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'rate1'"/>
        <xsl:with-param name="val1" select="format-number(/ReportResponse/Company/Contract/InvoiceSetup/SUIManagement, '##.00')"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'rat2'"/>
        <xsl:with-param name="val1" select="format-number(($SUIRate + /ReportResponse/Company/Contract/InvoiceSetup/SUIManagement), '##.00')"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'73'"/>
        <xsl:with-param name="val1" select="'Preparer'"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'74'"/>
        <xsl:with-param name="val1" select="substring(../Contact/Phone,1,3)"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'75'"/>
        <xsl:with-param name="val1" select="concat(substring(../Contact/Phone,4,3), ' ', substring(../Contact/Phone,7,4))"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'76'"/>
        <xsl:with-param name="val1" select="$today"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'t1'"/>
        <xsl:with-param name="val1" select="$count1"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'t2'"/>
        <xsl:with-param name="val1" select="$count2"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'t3'"/>
        <xsl:with-param name="val1" select="$count3"/>
      </xsl:call-template>
    
      <xsl:call-template name="DecimalFieldTemplate">
        <xsl:with-param name="field1" select="'pagewages-1'"/>
        <xsl:with-param name="field2" select="'pagewages-2'"/>
        <xsl:with-param name="val" select="$GrossPage1"/>
      </xsl:call-template>
      <xsl:call-template name="DecimalFieldTemplate">
        <xsl:with-param name="field1" select="'excesswages-1'"/>
        <xsl:with-param name="field2" select="'excesswages-2'"/>
        <xsl:with-param name="val" select="$WagesEPage1"/>
      </xsl:call-template>
      <xsl:call-template name="DecimalFieldTemplate">
        <xsl:with-param name="field1" select="'totalwages-1'"/>
        <xsl:with-param name="field2" select="'totalwages-2'"/>
        <xsl:with-param name="val" select="$TotalWages"/>
      </xsl:call-template>
      <xsl:call-template name="DecimalFieldTemplate">
        <xsl:with-param name="field1" select="'totalewages-1'"/>
        <xsl:with-param name="field2" select="'totalewages-2'"/>
        <xsl:with-param name="val" select="$TotalEWages"/>
      </xsl:call-template>
      <xsl:call-template name="DecimalFieldTemplate">
        <xsl:with-param name="field1" select="'uiwages-1'"/>
        <xsl:with-param name="field2" select="'uiwages-2'"/>
        <xsl:with-param name="val" select="$TotalUIWages"/>
      </xsl:call-template>
      <xsl:call-template name="DecimalFieldTemplate">
        <xsl:with-param name="field1" select="'uitax-1'"/>
        <xsl:with-param name="field2" select="'uitax-2'"/>
        <xsl:with-param name="val" select="$TotalUITax"/>
      </xsl:call-template>
      <xsl:variable name="start" select="0"/>
      <xsl:variable name="end">
        <xsl:choose>
          <xsl:when test="$employeeCount>12">
            <xsl:value-of select="$start+13"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$employeeCount+1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="/ReportResponse/EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]">
        <xsl:with-param name="currPage" select="'0'"/>
      </xsl:apply-templates>
    </Fields>
    
	</Report>
  <xsl:if test="$employeeCount > 12">
    <xsl:variable name="pages" select="ceiling($employeeCount div 14)"/>
    <xsl:call-template name="MTUIPage">
      <xsl:with-param name="currPage" select="1"/>
      <xsl:with-param name="totalPages" select="$pages"/>
      <xsl:with-param name="comp" select="."/>

    </xsl:call-template>
  </xsl:if>
  
</xsl:template>	
<xsl:template name="MTUIPage">
	<xsl:param name="currPage"/>
	<xsl:param name="totalPages"/>
	<xsl:param name="comp"/>
  <xsl:variable name="start" select="12*($currPage - 1)"/>
  <xsl:variable name="end">
    <xsl:choose>
      <xsl:when test="$employeeCount>($start+12)">
        <xsl:value-of select="$start+13"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$employeeCount+1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="GrossPage" select="format-number(sum(../EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]/PayCheckWages/GrossWage),'########0.00')"/>
  <xsl:variable name="WagesPage" select="format-number(sum(../EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]/ApplicableWages),'########0.00')"/>
  <xsl:variable name="WagesEPage" select="format-number($GrossPage - $WagesPage,'########0.00')"/>
	<Report>
		<TemplatePath>GovtForms\MTForms\</TemplatePath>
		<Template>UI-5.pdf</Template>

		<Fields>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'1'"/>
        <xsl:with-param name="val1" select="$fein"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'2'"/>
        <xsl:with-param name="val1" select="$accountnumber"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'3'"/>
        <xsl:with-param name="val1" select="$quarterEndDate"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'pagewages'"/>
        <xsl:with-param name="val1" select="$WagesPage"/>
      </xsl:call-template>
      <xsl:call-template name="DecimalFieldTemplate">
        <xsl:with-param name="field1" select="'pagewages-1'"/>
        <xsl:with-param name="field2" select="'pagewages-2'"/>
        <xsl:with-param name="val" select="$GrossPage"/>
      </xsl:call-template>
      <xsl:call-template name="DecimalFieldTemplate">
        <xsl:with-param name="field1" select="'excesswages-1'"/>
        <xsl:with-param name="field2" select="'excesswages-2'"/>
        <xsl:with-param name="val" select="$WagesEPage"/>
      </xsl:call-template>
      
			<xsl:apply-templates select="../EmployeeAccumulationList/Accumulation[position()>$start and position() &lt; $end]">
				<xsl:with-param name="currPage" select="$currPage"/>
			</xsl:apply-templates>
			
		</Fields>
	</Report>
	<xsl:if test="$totalPages>$currPage">
		<xsl:call-template name="MTUIPage">
			<xsl:with-param name="currPage" select="$currPage+1"/>
			<xsl:with-param name="totalPages" select="$totalPages"/>
			<xsl:with-param name="comp" select="$comp"/>		
		</xsl:call-template>
	</xsl:if>
	
</xsl:template>
<xsl:template match="Accumulation">
  <xsl:param name="currPage"/>
  <xsl:variable name="pos">
    <xsl:choose>
      <xsl:when test="$currPage=0">
        <xsl:value-of select="position()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="position() - 12 - ($currPage - 1)*12"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="ssn" select="concat(substring(SSNVal,1,3),'-',substring(SSNVal,4,2),'-',substring(SSNVal,6,4))"/>
  <xsl:call-template name="FieldTemplate">
    <xsl:with-param name="name1" select="concat('ssa-',$pos)"/>
    <xsl:with-param name="val1" select="$ssn"/>
  </xsl:call-template>
  <xsl:call-template name="FieldTemplate">
    <xsl:with-param name="name1" select="concat('name-',$pos)"/>
    <xsl:with-param name="val1" select="concat(LastName, ', ', FirstName)"/>
  </xsl:call-template>
  
  <xsl:call-template name="DecimalFieldTemplate">
    <xsl:with-param name="field1" select="concat('wages-', $pos)"/>
    <xsl:with-param name="field2" select="concat('wages-', $pos, '-1')"/>
    <xsl:with-param name="val" select="PayCheckWages/GrossWage"/>
  </xsl:call-template>
  <xsl:call-template name="DecimalFieldTemplate">
    <xsl:with-param name="field1" select="concat('ewages-', $pos)"/>
    <xsl:with-param name="field2" select="concat('ewages-', $pos, '-1')"/>
    <xsl:with-param name="val" select="PayCheckWages/GrossWage - ApplicableWages"/>
  </xsl:call-template>
 
</xsl:template>
</xsl:stylesheet>

  