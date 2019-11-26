<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
	
  <xsl:param name="enddate"/>
<xsl:param name="today"/>
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="fein" select="substring(/ReportResponse/Company/FederalEIN,6,4)"/>
<xsl:variable name="sein" select="translate(concat('WH',/ReportResponse/Company/States/CompanyTaxState[State/StateId=10]/StateEIN), $smallcase, $uppercase)"/>
  <xsl:variable name="TotalWages" select="translate(format-number(sum(/ReportResponse/CompanyAccumulations/PayCheckWages/GrossWage),'##########0.00'),'.','')"/>
	<xsl:variable name="TotalIncomeTax" select="translate(format-number(sum(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='HI-SIT']/YTD),'########0.00'),'.','')"/>
	
<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="ReportResponse">
		<ReportTransformed>
			<Name>FilledFormHW-14</Name>
			<Reports>
				<xsl:apply-templates select="Company"/>
			</Reports>
		</ReportTransformed>
	</xsl:template>

<xsl:template match="Company">	
	<Report>
		<TemplatePath>GovtForms\HIForms\</TemplatePath>
		<Template>HW-14.pdf</Template>
		<Fields>
      <xsl:call-template name="eachLetter">
        <xsl:with-param name="startIndex" select="1"/>
        <xsl:with-param name="prefix" select="'fpp-'"/>
        <xsl:with-param name="data" select="$enddate"/>
      </xsl:call-template>
			<xsl:call-template name="eachLetter">
        <xsl:with-param name="startIndex" select="1"/>
        <xsl:with-param name="prefix" select="'fsn-'"/>
        <xsl:with-param name="data" select="$sein"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetter">
        <xsl:with-param name="startIndex" select="1"/>
        <xsl:with-param name="prefix" select="'fein-'"/>
        <xsl:with-param name="data" select="$fein"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetterReverse">
        <xsl:with-param name="startIndex" select="13"/>
        <xsl:with-param name="prefix" select="'tw-'"/>
        <xsl:with-param name="data" select="$TotalWages"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetterReverse">
        <xsl:with-param name="startIndex" select="13"/>
        <xsl:with-param name="prefix" select="'tp-'"/>
        <xsl:with-param name="data" select="$TotalIncomeTax"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetterReverse">
        <xsl:with-param name="startIndex" select="13"/>
        <xsl:with-param name="prefix" select="'ad-'"/>
        <xsl:with-param name="data" select="$TotalIncomeTax"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetterReverse">
        <xsl:with-param name="startIndex" select="13"/>
        <xsl:with-param name="prefix" select="'ut-'"/>
        <xsl:with-param name="data" select="$TotalIncomeTax"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetterReverse">
        <xsl:with-param name="startIndex" select="13"/>
        <xsl:with-param name="prefix" select="'td-'"/>
        <xsl:with-param name="data" select="$TotalIncomeTax"/>
      </xsl:call-template>
      <xsl:call-template name="eachLetterReverse">
        <xsl:with-param name="startIndex" select="13"/>
        <xsl:with-param name="prefix" select="'pa-'"/>
        <xsl:with-param name="data" select="$TotalIncomeTax"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'today'"/>
        <xsl:with-param name="val1" select="$today"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'title'"/>
        <xsl:with-param name="val1" select="translate(/ReportResponse/Host/DesigneeName940941,$smallcase,$uppercase)"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'phone1'"/>
        <xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,1,3)"/>
      </xsl:call-template>
      <xsl:call-template name="FieldTemplate">
        <xsl:with-param name="name1" select="'phone2'"/>
        <xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,4,7)"/>
      </xsl:call-template>
		</Fields>
	</Report>
</xsl:template>	
</xsl:stylesheet>

  