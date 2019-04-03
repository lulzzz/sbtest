<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:math="http://exslt.org/math" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
  <xsl:param name="selectedYear"/>
  <xsl:param name="todaydate"/>
	<xsl:param name="firstQuarter"/>
	<xsl:param name="secondQuarter"/>
	<xsl:param name="thirdQuarter"/>
	<xsl:param name="fourthQuarter"/>
	<xsl:param name="immigrantsIncluded"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="totalGrossWages" select="ReportResponse/CompanyAccumulations/PayCheckWages/GrossWage"/>
	<xsl:variable name="totalMDWages" select="ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage"/>
	<xsl:variable name="totalFUTAWages" select="ReportResponse/CompanyAccumulations/Taxes/PayCheckTax[Tax/Code='FUTA']/YTDWage"/>
	
	<xsl:variable name="quarterSum" select="$firstQuarter + $secondQuarter + $thirdQuarter + $fourthQuarter"/>

	<xsl:variable name="line3" select="$totalGrossWages"/>
	<xsl:variable name="line4" select="$totalGrossWages - $totalMDWages"/>
	<xsl:variable name="line5" select="$totalGrossWages - $totalFUTAWages - $line4"/>
	<xsl:variable name="line6" select="$line4 + $line5"/>
	<xsl:variable name="line7" select="$line3 - $line6"/>
	<xsl:variable name="line8" select="format-number($line7*0.006,'######.00')"/>
	<xsl:variable name="line11" select="format-number($line7*0.018,'######.00')"/>
	<xsl:variable name="line12" select="$line8 + $line11"/>
	<xsl:variable name="line13" select="format-number(ReportResponse/CompanyAccumulations/PayCheckWages/DepositAmount,'######.00')"/>
<xsl:output method="xml" indent="no"/>
<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledForm940</Name>
		<Reports>
			<Report>
				<TemplatePath>GovtForms\940\</TemplatePath>
				<Template>f940-<xsl:value-of select="$selectedYear"/>.pdf</Template>
				<Fields>
					<xsl:apply-templates select="Company"/>
					<xsl:apply-templates select="CompanyAccumulations"/>
					<xsl:apply-templates select="Company/BusinessAddress"/>				
				</Fields>
			
			</Report>
			<xsl:call-template name="ScheduleA"/>
		</Reports>
	</ReportTransformed>	
</xsl:template>
<xsl:template match="CompanyAccumulations">
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_018(0)'"/>
		<xsl:with-param name="field2" select="'f1_019(0)'"/>
		<xsl:with-param name="val" select="$totalGrossWages"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_020(0)'"/>
		<xsl:with-param name="field2" select="'f1_021(0)'"/>
		<xsl:with-param name="val" select="$line4"/>
	</xsl:call-template>
	<xsl:if test="Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/R940_R='4a']">
		<xsl:call-template name="CheckTemplate">
			<xsl:with-param name="name1" select="'c1_07(0)'"/>
			<xsl:with-param name="val1" select="'On'"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/R940_R='4b']">
		<xsl:call-template name="CheckTemplate">
			<xsl:with-param name="name1" select="'c1_08(0)'"/>
			<xsl:with-param name="val1" select="'On'"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/R940_R='4c']">
		<xsl:call-template name="CheckTemplate">
			<xsl:with-param name="name1" select="'c1_09(0)'"/>
			<xsl:with-param name="val1" select="'On'"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="Deductions/PayCheckDeduction[CompanyDeduction/DeductionType/R940_R='4d']">
		<xsl:call-template name="CheckTemplate">
			<xsl:with-param name="name1" select="'c1_10(0)'"/>
			<xsl:with-param name="val1" select="'On'"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$immigrantsIncluded">
		<xsl:call-template name="CheckTemplate">
			<xsl:with-param name="name1" select="'c1_11(0)'"/>
			<xsl:with-param name="val1" select="'On'"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_033(0)'"/>
		<xsl:with-param name="field2" select="'f1_032(0)'"/>
		<xsl:with-param name="val" select="$line5"/>
	</xsl:call-template>

	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_022(0)'"/>
		<xsl:with-param name="field2" select="'f1_023(0)'"/>
		<xsl:with-param name="val" select="$line6"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_024(0)'"/>
		<xsl:with-param name="field2" select="'f1_025(0)'"/>
		<xsl:with-param name="val" select="$line7"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_026(0)'"/>
		<xsl:with-param name="field2" select="'f1_027(0)'"/>
		<xsl:with-param name="val" select="$line8"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_042(0)'"/>
		<xsl:with-param name="field2" select="'f1_043(0)'"/>
		<xsl:with-param name="val" select="$line11"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_034(0)'"/>
		<xsl:with-param name="field2" select="'f1_035(0)'"/>
		<xsl:with-param name="val" select="$line12"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f1_036(0)'"/>
		<xsl:with-param name="field2" select="'f1_037(0)'"/>
		<xsl:with-param name="val" select="$line13"/>
	</xsl:call-template>
	<xsl:choose>
		<xsl:when test="$line12>$line13">
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="'f1_038(0)'"/>
				<xsl:with-param name="field2" select="'f1_039(0)'"/>
				<xsl:with-param name="val" select="$line12 - $line13"/>
			</xsl:call-template>
			<xsl:call-template name="CheckTemplate">
				<xsl:with-param name="name1" select="'c1_12(0)'"/>
				<xsl:with-param name="val1" select="'Yes'"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$line13>$line12">
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="'f1_040(0)'"/>
				<xsl:with-param name="field2" select="'f1_041(0)'"/>
				<xsl:with-param name="val" select="$line13 - $line12"/>
			</xsl:call-template>
			<xsl:call-template name="CheckTemplate">
				<xsl:with-param name="name1" select="'c1_012(0)'"/>
				<xsl:with-param name="val1" select="'Yes'"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>

	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f2_001(0)'"/>
		<xsl:with-param name="field2" select="'f2_002(0)'"/>
		<xsl:with-param name="val" select="$firstQuarter"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f2_003(0)'"/>
		<xsl:with-param name="field2" select="'f2_004(0)'"/>
		<xsl:with-param name="val" select="$secondQuarter"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f2_005(0)'"/>
		<xsl:with-param name="field2" select="'f2_006(0)'"/>
		<xsl:with-param name="val" select="$thirdQuarter"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f2_007(0)'"/>
		<xsl:with-param name="field2" select="'f2_008(0)'"/>
		<xsl:with-param name="val" select="$fourthQuarter"/>
	</xsl:call-template>
	<xsl:call-template name="DecimalFieldTemplate">
		<xsl:with-param name="field1" select="'f2_009(0)'"/>
		<xsl:with-param name="field2" select="'f2_010(0)'"/>
		<xsl:with-param name="val" select="$quarterSum"/>
	</xsl:call-template>
	<xsl:call-template name="CheckTemplate">
		<xsl:with-param name="name1" select="'c2_01(0)'"/>
		<xsl:with-param name="val1" select="'Yes'"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_011(0)'"/>
		<xsl:with-param name="val1" select="translate(/ReportResponse/Host/DesigneeName940941,$smallcase,$uppercase)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_039(0)'"/>
		<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,1,3)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_040(0)'"/>
		<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,4,3)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_041(0)'"/>
		<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,7,4)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_012(0)'"/>
		<xsl:with-param name="val1" select="substring(/ReportResponse/Host/PIN940941,1,1)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_013(0)'"/>
		<xsl:with-param name="val1" select="substring(/ReportResponse/Host/PIN940941,2,1)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_014(0)'"/>
		<xsl:with-param name="val1" select="substring(/ReportResponse/Host/PIN940941,3,1)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_015(0)'"/>
		<xsl:with-param name="val1" select="substring(/ReportResponse/Host/PIN940941,4,1)"/>
	</xsl:call-template>
	<xsl:call-template name="FieldTemplate">
		<xsl:with-param name="name1" select="'f2_016(0)'"/>
		<xsl:with-param name="val1" select="substring(/ReportResponse/Host/PIN940941,5,1)"/>
	</xsl:call-template>

	<xsl:choose>
		<xsl:when test="/ReportResponse/Company/AllowTaxPayments">
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_025(0)'"/>
				<xsl:with-param name="val1" select="translate(/ReportResponse/Host/FirmName,$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_031(0)'"/>
				<xsl:with-param name="val1" select="translate(/ReportResponse/Host/FirmName,$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_033(0)'"/>
				<xsl:with-param name="val1" select="translate(/ReportResponse/Host/Company/BusinessAddress/AddressLine1,$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_034(0)'"/>
				<xsl:with-param name="val1" select="translate(/ReportResponse/Host/Company/BusinessAddress/City,$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_035(0)'"/>
				<xsl:with-param name="val1" select="translate('ca',$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_028(0)'"/>
				<xsl:with-param name="val1" select="substring($todaydate,1,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_029(0)'"/>
				<xsl:with-param name="val1" select="substring($todaydate,4,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_030(0)'"/>
				<xsl:with-param name="val1" select="substring($todaydate,9,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_042(0)'"/>
				<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,1,3)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_043(0)'"/>
				<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,4,3)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_044(0)'"/>
				<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,7,4)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_032(0)'"/>
				<xsl:with-param name="val1" select="concat(substring(/ReportResponse/Host/Company/FederalEIN,1,2),'-',substring(/ReportResponse/Host/Company/FederalEIN,3,7))"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_036(0)'"/>
				<xsl:with-param name="val1" select="/ReportResponse/Host/Company/BusinessAddress/Zip"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_027(0)'"/>
				<xsl:with-param name="val1" select="/ReportResponse/Host/PTIN"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_017(0)'"/>
				<xsl:with-param name="val1" select="translate(concat(/ReportResponse/Contact/FirstName,' ', /ReportResponse/Contact/LastName),$smallcase,$uppercase)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_019(0)'"/>
				<xsl:with-param name="val1" select="substring($todaydate,1,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_020(0)'"/>
				<xsl:with-param name="val1" select="substring($todaydate,4,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_021(0)'"/>
				<xsl:with-param name="val1" select="substring($todaydate,9,2)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_022(0)'"/>
				<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,1,3)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_023(0)'"/>
				<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,4,3)"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'f2_024(0)'"/>
				<xsl:with-param name="val1" select="substring(/ReportResponse/Contact/Phone,8,4)"/>
			</xsl:call-template>

		</xsl:otherwise>
	</xsl:choose>

</xsl:template>
<xsl:template match="Company">
	<xsl:variable name="fein1" select="translate(FederalEIN,'-','')"/>
		
	
	
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_001(0)'"/><xsl:with-param name="val1" select="substring($fein1,1,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_002(0)'"/><xsl:with-param name="val1" select="substring($fein1,2,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_003(0)'"/><xsl:with-param name="val1" select="substring($fein1,3,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_004(0)'"/><xsl:with-param name="val1" select="substring($fein1,4,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_005(0)'"/><xsl:with-param name="val1" select="substring($fein1,5,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_006(0)'"/><xsl:with-param name="val1" select="substring($fein1,6,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_007(0)'"/><xsl:with-param name="val1" select="substring($fein1,7,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_008(0)'"/><xsl:with-param name="val1" select="substring($fein1,8,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_009(0)'"/><xsl:with-param name="val1" select="substring($fein1,9,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_010(0)'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>				
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_011(0)'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2_037(0)'"/><xsl:with-param name="val1" select="translate(TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f2_038(0)'"/><xsl:with-param name="val1" select="concat(substring(FederalEIN,1,2),'-',substring(FederalEIN,3,7))"/></xsl:call-template>
	
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_016(0)'"/><xsl:with-param name="val1" select="substring(States/CompanyTaxState/State/Abbreviation,1,1)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_017(0)'"/><xsl:with-param name="val1" select="substring(States/CompanyTaxState/State/Abbreviation,2,1)"/></xsl:call-template>
	
	<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="'c1_013(0)'"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
	
	
	
</xsl:template>
<xsl:template name="ScheduleA">
	<xsl:variable name="fein1" select="translate(/ReportResponse/Company/FederalEIN,'-','')"/>
	<Report>
		<TemplatePath>GovtForms\940\</TemplatePath>
		<Template>f940sa-<xsl:value-of select="$selectedYear"/>.pdf</Template>
			<Fields>
				
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_001(0)'"/><xsl:with-param name="val1" select="substring($fein1,1,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_002(0)'"/><xsl:with-param name="val1" select="substring($fein1,2,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_003(0)'"/><xsl:with-param name="val1" select="substring($fein1,3,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_004(0)'"/><xsl:with-param name="val1" select="substring($fein1,4,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_005(0)'"/><xsl:with-param name="val1" select="substring($fein1,5,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_006(0)'"/><xsl:with-param name="val1" select="substring($fein1,6,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_007(0)'"/><xsl:with-param name="val1" select="substring($fein1,7,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_008(0)'"/><xsl:with-param name="val1" select="substring($fein1,8,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_009(0)'"/><xsl:with-param name="val1" select="substring($fein1,9,1)"/></xsl:call-template>
				<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_010(0)'"/><xsl:with-param name="val1" select="translate(/ReportResponse/Company/TaxFilingName,$smallcase,$uppercase)"/></xsl:call-template>				
				<xsl:call-template name="CheckTemplate"><xsl:with-param name="name1" select="concat('f1-',translate(/ReportResponse/Company/States/CompanyTaxState[State/StateId=1]/State/Abbreviation, $uppercase, $smallcase),'(1)')"/><xsl:with-param name="val1" select="'On'"/></xsl:call-template>
				<xsl:call-template name="DecimalFieldTemplate">
					<xsl:with-param name="field1" select="'f1_1'"/>
					<xsl:with-param name="field2" select="'f1_1f'"/>
					<xsl:with-param name="val" select="$line7"/>
				</xsl:call-template>
				<xsl:call-template name="DecimalFieldTemplate">
					<xsl:with-param name="field1" select="'f1_2'"/>
					<xsl:with-param name="field2" select="'f1_2f'"/>
					<xsl:with-param name="val" select="$line11"/>
				</xsl:call-template>
				<xsl:call-template name="DecimalFieldTemplate">
					<xsl:with-param name="field1" select="'f1_T'"/>
					<xsl:with-param name="field2" select="'f1_Tf'"/>
					<xsl:with-param name="val" select="$line11"/>
				</xsl:call-template>
			</Fields>
			
		</Report>	
</xsl:template>
<xsl:template match="BusinessAddress">
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_012(0)'"/><xsl:with-param name="val1" select="translate(AddressLine1,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_013(0)'"/><xsl:with-param name="val1" select="translate(City,$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_014(0)'"/><xsl:with-param name="val1" select="translate('CA',$smallcase,$uppercase)"/></xsl:call-template>
	<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'f1_015(0)'"/><xsl:with-param name="val1" select="concat(Zip, '-', ZipExtension)"/></xsl:call-template>	
	
</xsl:template>

	
</xsl:stylesheet>

  