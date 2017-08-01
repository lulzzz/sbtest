<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
<xsl:param name="todaydate"/>
	
	
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:variable name="fein1" select="translate(/ReportResponse/Company/FederalEIN,'-','')"/>
	<xsl:variable name="ssConst" select="(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SS_Employee']/Tax/Rate + /ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SS_Employer']/Tax/Rate) div 100"/>
	<xsl:variable name="mdConst" select="(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='MD_Employee']/Tax/Rate + /ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='MD_Employer']/Tax/Rate) div 100"/>
	<xsl:variable name="totalTips" select="sum(/ReportResponse/CompanyAccumulations/Compensations/PayCheckCompensation[PayTypeId=3]/YTD)"/>
	<xsl:variable name="totalFITWages" select="/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage"/>
	<xsl:variable name="totalSSWages" select="/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage"/>

	<xsl:variable name="totalMDWages" select="/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage"/>
	<xsl:variable name="totalFITTax" select="/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='FIT']/YTD"/>
	<xsl:variable name="totalSSTax" select="(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTD + /ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='SS_Employer']/YTD)"/>
	<xsl:variable name="totalMDTax" select="(/ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTD + /ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='MD_Employer']/YTD)"/>

	<xsl:variable name="line4a" select="format-number($totalSSWages * $ssConst,'###0.00')"/>
	<xsl:variable name="line4b" select="format-number($totalTips * $ssConst,'###0.00')"/>
	<xsl:variable name="line4c" select="format-number($totalMDWages * $mdConst,'###0.00')"/>
	<xsl:variable name="line4d" select="format-number($line4a+$line4b+$line4c,'###0.00')"/>
	
	<xsl:variable name="line5" select="$totalFITTax + $line4d"/>	
	<xsl:variable name="line6" select="$totalSSTax + $totalMDTax - $line4d"/>	
	<xsl:variable name="line7" select="($line5 + $line6)"/>
	<xsl:variable name="line8" select="($totalFITTax + $totalSSTax + $totalMDTax)"/>
	<xsl:variable name="line10" select="$line8"/>

	<xsl:variable name="month1" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=1]/IRS941"/>
	<xsl:variable name="month2" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=2]/IRS941"/>
	<xsl:variable name="month3" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=3]/IRS941"/>
	<xsl:variable name="month4" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=4]/IRS941"/>
	<xsl:variable name="month5" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=5]/IRS941"/>
	<xsl:variable name="month6" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=6]/IRS941"/>
	<xsl:variable name="month7" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=7]/IRS941"/>
	<xsl:variable name="month8" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=8]/IRS941"/>
	<xsl:variable name="month9" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=9]/IRS941"/>
	<xsl:variable name="month10" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=10]/IRS941"/>
	<xsl:variable name="month11" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=11]/IRS941"/>
	<xsl:variable name="month12" select="/ReportResponse/CompanyAccumulations/MonthlyAccumulations/MonthlyAccumulation[Month=12]/IRS941"/>
	
	<xsl:variable name="summonths" select="$month1 + $month2 + $month3 + $month4 + $month5 + $month6 + $month7 + $month8 + $month9 + $month10 + $month11 + $month12"/>
<xsl:output method="xml" indent="no"/>
	<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledForm944</Name>
		<Reports>
			<Report>
				<TemplatePath>GovtForms\944\</TemplatePath>
				<Template>f944-<xsl:value-of select="$selectedYear"/>-part1.pdf</Template>
				<Fields>
					<xsl:apply-templates select="Company"/>
					<xsl:apply-templates select="CompanyAccumulations"/>
					<xsl:apply-templates select="Company/BusinessAddress"/>
				</Fields>
			</Report>
			<xsl:if test="/ReportResponse/Company/DepositSchedule='SemiWeekly'">
				<xsl:call-template name="ScheduleA"/>
			</xsl:if>
			<Report>
				<TemplatePath>GovtForms\944\</TemplatePath>
				<Template>f944-<xsl:value-of select="$selectedYear"/>-part2.pdf</Template>
				<Fields>
				</Fields>
			</Report>
		</Reports>
	</ReportTransformed>
</xsl:template>

<xsl:template match="Company">
	
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_1'"/><xsl:with-param name="val1" select="substring($fein1,1,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_2'"/><xsl:with-param name="val1" select="substring($fein1,2,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_3'"/><xsl:with-param name="val1" select="substring($fein1,3,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_4'"/><xsl:with-param name="val1" select="substring($fein1,4,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_5'"/><xsl:with-param name="val1" select="substring($fein1,5,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_6'"/><xsl:with-param name="val1" select="substring($fein1,6,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_7'"/><xsl:with-param name="val1" select="substring($fein1,7,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_8'"/><xsl:with-param name="val1" select="substring($fein1,8,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_9'"/><xsl:with-param name="val1" select="substring($fein1,9,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_11'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_12'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2_01(0)'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2-02(0)'"/>
		<xsl:with-param name="val1" select="concat(substring(FederalEIN, 1,2),'-',substring(FederalEIN,3,7))"/>
	</xsl:call-template>
	<xsl:choose>
		<xsl:when test="AllowTaxPayments">
			<xsl:apply-templates select="../Host"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2-44'"/>
				<xsl:with-param name="val1" select="translate(concat(../CompanyContact/FirstName,' ',../CompanyContact/LastName),$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2-45'"/>
				<xsl:with-param name="val1" select="substring($todaydate,1,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2-46'"/>
				<xsl:with-param name="val1" select="substring($todaydate,4,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2-47'"/>
				<xsl:with-param name="val1" select="substring($todaydate,9,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2-48'"/>
				<xsl:with-param name="val1" select="substring(../CompanyContact/Phone,1,3)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2-49'"/>
				<xsl:with-param name="val1" select="substring(../CompanContact/Phone,4,3)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2-50'"/>
				<xsl:with-param name="val1" select="substring(../CompanyContact/Phone,7,4)"/>
			</xsl:call-template>

		</xsl:otherwise>
	</xsl:choose>

	<xsl:choose>
		<xsl:when test="$line7 &lt; 2500">
			<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'c2_1'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'c2_2'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_03'"/><xsl:with-param name="field2" select="'f2_04'"/><xsl:with-param name="val" select="$month1"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_11'"/><xsl:with-param name="field2" select="'f2_12'"/><xsl:with-param name="val" select="$month2"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_19'"/><xsl:with-param name="field2" select="'f2_20'"/><xsl:with-param name="val" select="$month3"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_05'"/><xsl:with-param name="field2" select="'f2_06'"/><xsl:with-param name="val" select="$month4"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_13'"/><xsl:with-param name="field2" select="'f2_14'"/><xsl:with-param name="val" select="$month5"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_21'"/><xsl:with-param name="field2" select="'f2_22'"/><xsl:with-param name="val" select="$month6"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_07'"/><xsl:with-param name="field2" select="'f2_08'"/><xsl:with-param name="val" select="$month7"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_15'"/><xsl:with-param name="field2" select="'f2_16'"/><xsl:with-param name="val" select="$month8"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_23'"/><xsl:with-param name="field2" select="'f2_24'"/><xsl:with-param name="val" select="$month9"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_09'"/><xsl:with-param name="field2" select="'f2_10'"/><xsl:with-param name="val" select="$month10"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_17'"/><xsl:with-param name="field2" select="'f2_18'"/><xsl:with-param name="val" select="$month11"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_25'"/><xsl:with-param name="field2" select="'f2_26'"/><xsl:with-param name="val" select="$month12"/></xsl:call-template>				
			<xsl:call-template name="DecimalFieldTemplate"><xsl:with-param name="field1" select="'f2_27'"/><xsl:with-param name="field2" select="'f2_28'"/><xsl:with-param name="val" select="$summonths"/></xsl:call-template>				
			
		</xsl:otherwise>
			
		
	</xsl:choose>
	
	
</xsl:template>
	<xsl:template match="Host">
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-51'"/>
			<xsl:with-param name="val1" select="translate(FirmName,$smallcase,$uppercase)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-54'"/>
			<xsl:with-param name="val1" select="translate(FirmName,$smallcase,$uppercase)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-56'"/>
			<xsl:with-param name="val1" select="translate(Company/BusinessAddress/AddressLine1,$smallcase,$uppercase)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-57'"/>
			<xsl:with-param name="val1" select="translate(Company/BusinessAddress/City,$smallcase,$uppercase)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-58'"/>
			<xsl:with-param name="val1" select="translate('CA',$smallcase,$uppercase)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-62'"/>
			<xsl:with-param name="val1" select="substring($todaydate,1,2)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-63'"/>
			<xsl:with-param name="val1" select="substring($todaydate,4,2)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-64'"/>
			<xsl:with-param name="val1" select="substring($todaydate,9,2)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-35'"/>
			<xsl:with-param name="val1" select="substring(../Contact/Phone,1,3)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-36'"/>
			<xsl:with-param name="val1" select="substring(../Contact/Phone,4,3)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-37'"/>
			<xsl:with-param name="val1" select="substring(../Contact/Phone,7,4)"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-55'"/>
			<xsl:with-param name="val1" select="concat(substring(Company/FederalEIN, 1, 2), '-', substring(Company/FederalEIN, 3,7))"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-65'"/>
			<xsl:with-param name="val1" select="Company/BusinessAddress/Zip"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="'f2-53'"/>
			<xsl:with-param name="val1" select="PTIN"/>
		</xsl:call-template>
	</xsl:template>
<xsl:template match="CompanyAccumulations">
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_17'"/>
		<xsl:with-param name="field2" select="'f1_18'"/>
		<xsl:with-param name="val" select="$totalFITWages"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_19'"/>
		<xsl:with-param name="field2" select="'f1_20'"/>
		<xsl:with-param name="val" select="$totalFITTax"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_21'"/>
		<xsl:with-param name="field2" select="'f1_22'"/>
		<xsl:with-param name="val" select="$totalSSWages"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_23'"/>
		<xsl:with-param name="field2" select="'f1_24'"/>
		<xsl:with-param name="val" select="$line4a"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_25'"/>
		<xsl:with-param name="field2" select="'f1_26'"/>
		<xsl:with-param name="val" select="$totalTips"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_27'"/>
		<xsl:with-param name="field2" select="'f1_28'"/>
		<xsl:with-param name="val" select="$line4b"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_29'"/>
		<xsl:with-param name="field2" select="'f1_30'"/>
		<xsl:with-param name="val" select="$totalMDWages"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_31'"/>
		<xsl:with-param name="field2" select="'f1_32'"/>
		<xsl:with-param name="val" select="$line4c"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_33'"/>
		<xsl:with-param name="field2" select="'f1_34'"/>
		<xsl:with-param name="val" select="$line4d"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_35'"/>
		<xsl:with-param name="field2" select="'f1_36'"/>
		<xsl:with-param name="val" select="$line5"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_37'"/>
		<xsl:with-param name="field2" select="'f1_38'"/>
		<xsl:with-param name="val" select="$line6"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_49'"/>
		<xsl:with-param name="field2" select="'f1_50'"/>
		<xsl:with-param name="val" select="$line7"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_55'"/>
		<xsl:with-param name="field2" select="'f1_56'"/>
		<xsl:with-param name="val" select="$line10"/>
	</xsl:call-template>

	<xsl:choose>
		<xsl:when test="$line7>$line10">
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="'f1_57'"/>
				<xsl:with-param name="field2" select="'f1_58'"/>
				<xsl:with-param name="val" select="$line7 - $line10"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$line10>$line7">
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="'f1_59'"/>
				<xsl:with-param name="field2" select="'f1_60'"/>
				<xsl:with-param name="val" select="$line10 - $line7"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>		
</xsl:template>
<xsl:template name="ScheduleA">
	
	<Report>
			<TemplatePath>GovtForms\944\</TemplatePath>
			<Template>f945Aa.pdf</Template>
			<Fields>
				
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-1'"/><xsl:with-param name="val1" select="translate(/ReportResponse/Company/TaxFilingName,@smallcase,$uppercase)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-2'"/><xsl:with-param name="val1" select="substring($fein1,1,2)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1-3'"/><xsl:with-param name="val1" select="substring($fein1,3,7)"/></xsl:call-template>
				
							
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="4"/><xsl:with-param name="month" select="1"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="67"/><xsl:with-param name="month" select="2"/><xsl:with-param name="day" select="29"/><xsl:with-param name="daysinmonth" select="29"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="126"/><xsl:with-param name="month" select="3"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="189"/><xsl:with-param name="month" select="4"/><xsl:with-param name="day" select="30"/><xsl:with-param name="daysinmonth" select="30"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="250"/><xsl:with-param name="month" select="5"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="313"/><xsl:with-param name="month" select="6"/><xsl:with-param name="day" select="30"/><xsl:with-param name="daysinmonth" select="30"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="1"/><xsl:with-param name="month" select="7"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="64"/><xsl:with-param name="month" select="8"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="127"/><xsl:with-param name="month" select="9"/><xsl:with-param name="day" select="30"/><xsl:with-param name="daysinmonth" select="30"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="188"/><xsl:with-param name="month" select="10"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="251"/><xsl:with-param name="month" select="11"/><xsl:with-param name="day" select="30"/><xsl:with-param name="daysinmonth" select="30"/></xsl:call-template>
				<xsl:call-template name="dailyTemplate944"><xsl:with-param name="starter" select="312"/><xsl:with-param name="month" select="12"/><xsl:with-param name="day" select="31"/><xsl:with-param name="daysinmonth" select="31"/></xsl:call-template>
				
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2-376'"/><xsl:with-param name="val1" select="format-number(sum(/hrmaxx/trt/cpa/company/months/@*),'####0.00')"/></xsl:call-template>
				
			</Fields>
			
		</Report>	
</xsl:template>
<xsl:template match="BusinessAddress">
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_13'"/><xsl:with-param name="val1" select="translate(AddressLine1,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_14'"/><xsl:with-param name="val1" select="translate(City,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_15'"/><xsl:with-param name="val1" select="translate('CA',$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_16'"/><xsl:with-param name="val1" select="concat(Zip, '-',ZipExtension)"/></xsl:call-template>	
	
</xsl:template>

	
</xsl:stylesheet>

  