<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
	<xsl:param name="endQuarterMonth"/>
  <xsl:param name="quarter"/>
  <xsl:param name="todaydate"/>
  <xsl:param name="month1"/>
	<xsl:param name="month2"/>
	<xsl:param name="month3"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:variable name="fein1" select="translate(/ReportResponse/Company/FederalEIN,'-','')"/>
	<xsl:variable name="ssConst" select="(/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='SS_Employee']/Tax/Rate + /ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='SS_Employer']/Tax/Rate) div 100"/>
	<xsl:variable name="mdConst" select="(/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='MD_Employee']/Tax/Rate + /ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='MD_Employer']/Tax/Rate) div 100"/>
	<xsl:variable name="totalTips" select="/ReportResponse/CompanyAccumulation/Compensations[PayType/Id=3]/Amount"/>
	<xsl:variable name="totalFITWages" select="/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='FIT']/TaxableWage"/>
	<xsl:variable name="totalSSWages" select="/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='SS_Employee']/TaxableWage"/>

	<xsl:variable name="totalMDWages" select="/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='MD_Employee']/TaxableWage"/>
	<xsl:variable name="totalFITTax" select="/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='FIT']/Amount"/>
	<xsl:variable name="totalSSTax" select="(/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='SS_Employee']/Amount + /ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='SS_Employer']/Amount)"/>
	<xsl:variable name="totalMDTax" select="(/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='MD_Employee']/Amount + /ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Code='MD_Employer']/Amount)"/>

	<xsl:variable name="line5d" select="format-number($totalSSWages*$ssConst,'######0.00') + format-number($totalTips*$ssConst,'######0.00') + format-number($totalMDWages*$mdConst,'######0.00')"/>
	<xsl:variable name="line6" select="format-number($totalFITTax + $line5d,'######0.00')"/>
	<xsl:variable name="line7" select="format-number($totalSSTax + $totalMDTax - $line5d,'######0.00')"/>
	<xsl:variable name="line10" select="format-number(($line6 + $line7),'######0.00')"/>
	<xsl:variable name="line11" select="format-number(($totalFITTax + $totalSSTax + $totalMDTax),'######0.00')"/>
	<xsl:variable name="line13" select="$line11"/>


	<xsl:output method="xml" indent="no"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledForm941</Name>
		<Reports>
			<Report>
				<TemplatePath>GovtForms\941\</TemplatePath>
				<Template>f941-<xsl:value-of select="$selectedYear"/>-part1.pdf</Template>
				<Fields>
					<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="concat('c1-',$quarter)"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
					<xsl:apply-templates select="Company"/>
					<xsl:apply-templates select="CompanyAccumulation"/>
					<xsl:apply-templates select="Company/BusinessAddress"/>
				</Fields>

			</Report>
			<xsl:if test="/ReportResponse/Company/DepositSchedule='SemiWeekly'">
				<xsl:call-template name="ScheduleB"/>
			</xsl:if>
			<Report>
				<TemplatePath>GovtForms\941\</TemplatePath>
				<Template>f941-<xsl:value-of select="$selectedYear"/>-part2.pdf</Template>
				<Fields>
				</Fields>
			</Report>
		</Reports>
	</ReportTransformed>
</xsl:template>
<xsl:template match="Company">
	
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-1'"/><xsl:with-param name="val1" select="substring($fein1,1,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-2'"/><xsl:with-param name="val1" select="substring($fein1,2,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-3'"/><xsl:with-param name="val1" select="substring($fein1,3,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-4'"/><xsl:with-param name="val1" select="substring($fein1,4,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-5'"/><xsl:with-param name="val1" select="substring($fein1,5,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-6'"/><xsl:with-param name="val1" select="substring($fein1,6,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-7'"/><xsl:with-param name="val1" select="substring($fein1,7,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-8'"/><xsl:with-param name="val1" select="substring($fein1,8,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-9'"/><xsl:with-param name="val1" select="substring($fein1,9,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-10'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-11'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-1'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-2'"/><xsl:with-param name="val1" select="concat(substring(FederalEIN, 1,2),'-',substring(FederalEIN,3,7))"/></xsl:call-template>
	
	<xsl:choose>
		<xsl:when test="AllowTaxPayments">
			<xsl:apply-templates select="../Host"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-25'"/><xsl:with-param name="val1" select="translate(concat(../CompanyContact/FirstName,' ',../CompanyContact/LastName),$smallcase,$uppercase)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-26'"/><xsl:with-param name="val1" select="substring($todaydate,1,2)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-27'"/><xsl:with-param name="val1" select="substring($todaydate,4,2)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-28'"/><xsl:with-param name="val1" select="substring($todaydate,9,2)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-29'"/><xsl:with-param name="val1" select="substring(../CompanyContact/Phone,1,3)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-30'"/><xsl:with-param name="val1" select="substring(../CompanContact/Phone,4,3)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-31'"/><xsl:with-param name="val1" select="substring(../CompanyContact/Phone,7,4)"/></xsl:call-template>
			
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="$line10 &lt; 2500">
			<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'c2-1'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
		</xsl:when>
		
			<xsl:when test="DepositSchedule='Monthly'">
				<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'c2-2'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
				<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2-5'"/><xsl:with-param name="field2" select="'f2-6'"/><xsl:with-param name="val" select="$month1"/></xsl:call-template>				
				<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2-7'"/><xsl:with-param name="field2" select="'f2-8'"/><xsl:with-param name="val" select="$month2"/></xsl:call-template>				
				<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2-9'"/><xsl:with-param name="field2" select="'f2-10'"/><xsl:with-param name="val" select="$month3"/></xsl:call-template>				
				<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2-11'"/><xsl:with-param name="field2" select="'f2-12'"/><xsl:with-param name="val" select="($month1 + $month2 + $month3)"/></xsl:call-template>				
			</xsl:when>
			<xsl:when test="DepositSchedule='SemiWeekly'">
				<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'c2-3'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
				
			</xsl:when>
		
	</xsl:choose>
	
	
</xsl:template>

<xsl:template match="CompanyAccumulation">
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-17'"/>
		<xsl:with-param name="field2" select="'f1-18'"/>
		<xsl:with-param name="val" select="$totalFITWages"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-19'"/>
		<xsl:with-param name="field2" select="'f1-20'"/>
		<xsl:with-param name="val" select="$totalFITTax"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-21'"/>
		<xsl:with-param name="field2" select="'f1-22'"/>
		<xsl:with-param name="val" select="$totalSSWages"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-23'"/>
		<xsl:with-param name="field2" select="'f1-24'"/>
		<xsl:with-param name="val" select="$totalSSWages * $ssConst"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-25'"/>
		<xsl:with-param name="field2" select="'f1-26'"/>
		<xsl:with-param name="val" select="$totalTips"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-27'"/>
		<xsl:with-param name="field2" select="'f1-28'"/>
		<xsl:with-param name="val" select="$totalTips * $ssConst"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-29'"/>
		<xsl:with-param name="field2" select="'f1-30'"/>
		<xsl:with-param name="val" select="$totalMDWages"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-31'"/>
		<xsl:with-param name="field2" select="'f1-32'"/>
		<xsl:with-param name="val" select="$totalMDWages * $mdConst"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-33'"/>
		<xsl:with-param name="field2" select="'f1-34'"/>
		<xsl:with-param name="val" select="$line5d"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-35'"/>
		<xsl:with-param name="field2" select="'f1-36'"/>
		<xsl:with-param name="val" select="$line6"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-37'"/>
		<xsl:with-param name="field2" select="'f1-38'"/>
		<xsl:with-param name="val" select="$line7"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-53'"/>
		<xsl:with-param name="field2" select="'f1-54'"/>
		<xsl:with-param name="val" select="$line10"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1-59'"/>
		<xsl:with-param name="field2" select="'f1-60'"/>
		<xsl:with-param name="val" select="$line11"/>
	</xsl:call-template>
	<xsl:choose>
		<xsl:when test="$line10>$line13">
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="'f1-61'"/>
				<xsl:with-param name="field2" select="'f1-62'"/>
				<xsl:with-param name="val" select="$line10 - $line13"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$line13>$line10">
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="'f1-63'"/>
				<xsl:with-param name="field2" select="'f1-64'"/>
				<xsl:with-param name="val" select="$line13 - $line10"/>
			</xsl:call-template>
			<xsl:call-template name="CheckTemplate">
				<xsl:with-param name="name1" select="'c1-7'"/>
				<xsl:with-param name="val1" select="'On'"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>

</xsl:template>
<xsl:template match="Host">
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-32'"/>
		<xsl:with-param name="val1" select="translate(FirmName,$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-33'"/>
		<xsl:with-param name="val1" select="translate(Company/BusinessAddress/AddressLine1,$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-34'"/>
		<xsl:with-param name="val1" select="translate(Company/BusinessAddress/City,$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-34-1'"/>
		<xsl:with-param name="val1" select="translate('CA',$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-35'"/>
		<xsl:with-param name="val1" select="substring($todaydate,1,2)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-36'"/>
		<xsl:with-param name="val1" select="substring($todaydate,4,2)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-37'"/>
		<xsl:with-param name="val1" select="substring($todaydate,9,2)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-38'"/>
		<xsl:with-param name="val1" select="substring(../Contact/Phone,1,3)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-39'"/>
		<xsl:with-param name="val1" select="substring(../Contact/Phone,4,3)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-40'"/>
		<xsl:with-param name="val1" select="substring(../Contact/Phone,7,4)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-41'"/>
		<xsl:with-param name="val1" select="concat(substring(Company/FederalEIN, 1, 2), '-', substring(Company/FederalEIN, 3,7))"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-42'"/>
		<xsl:with-param name="val1" select="Company/BusinessAddress/Zip"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-43'"/>
		<xsl:with-param name="val1" select="PTIN"/>
	</xsl:call-template>
</xsl:template>
<xsl:template name="ScheduleB">
		<Report>
			<TemplatePath>GovtForms\941\</TemplatePath>
			<Template>f941sb-<xsl:value-of select="$selectedYear"/>.pdf</Template>
			<Fields>
				<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="concat('c1-',$quarter)"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-1'"/><xsl:with-param name="val1" select="substring($fein1,1,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-2'"/><xsl:with-param name="val1" select="substring($fein1,2,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-3'"/><xsl:with-param name="val1" select="substring($fein1,3,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-4'"/><xsl:with-param name="val1" select="substring($fein1,4,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-5'"/><xsl:with-param name="val1" select="substring($fein1,5,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-6'"/><xsl:with-param name="val1" select="substring($fein1,6,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-7'"/><xsl:with-param name="val1" select="substring($fein1,7,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-8'"/><xsl:with-param name="val1" select="substring($fein1,8,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-9'"/><xsl:with-param name="val1" select="substring($fein1,9,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-10'"/><xsl:with-param name="val1" select="translate(/ReportResponse/Company/TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>				
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-10a'"/><xsl:with-param name="val1" select="substring($selectedYear,1,1)"/></xsl:call-template>				
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-10b'"/><xsl:with-param name="val1" select="substring($selectedYear,2,1)"/></xsl:call-template>				
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-10c'"/><xsl:with-param name="val1" select="substring($selectedYear,3,1)"/></xsl:call-template>				
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-10d'"/><xsl:with-param name="val1" select="substring($selectedYear,4,1)"/></xsl:call-template>				
				<xsl:call-template name="dailyTemplate"><xsl:with-param name="month" select="1"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate"><xsl:with-param name="month" select="2"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate"><xsl:with-param name="month" select="3"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="DecimalFieldTemplate">
					<xsl:with-param name="field1" select="'f1-203'"/>
					<xsl:with-param name="field2" select="'f1-204'"/>
					<xsl:with-param name="val" select="$month1 + $month2 + $month3"/>
			</xsl:call-template>
			</Fields>
			
		</Report>	
</xsl:template>
<xsl:template match="BusinessAddress">
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-12'"/><xsl:with-param name="val1" select="translate(AddressLine1,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-13'"/><xsl:with-param name="val1" select="translate(City,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-14'"/><xsl:with-param name="val1" select="translate('CA',$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-15'"/><xsl:with-param name="val1" select="concat(Zip, '-',ZipExtension)"/></xsl:call-template>	
	
</xsl:template>
</xsl:stylesheet>

  