<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:math="http://exslt.org/math" exclude-result-prefixes="msxsl"
    
>
	<xsl:import href="../reports/Utils.xslt" />
	<xsl:param name="selectedYear"/>
	<xsl:param name="todaydate"/>
	
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:output method="xml" indent="no"/>
	<xsl:template match="ReportResponse">
		<ReportTransformed>
			<Name>MonthlyQuarterlyAnnualTaxSummary-<xsl:value-of select="$selectedYear"/></Name>
			<Reports>
				<Report>
					<TemplatePath>OtherForms\</TemplatePath>
					<Template>MonthlyQuarterAnnualTaxSummary.pdf</Template>
					<Fields>
						<xsl:call-template name="FieldTemplate">
							<xsl:with-param name="name1" select="'year'"/>
							<xsl:with-param name="val1" select="$selectedYear"/>
						</xsl:call-template>
						<xsl:call-template name="FieldTemplate">
							<xsl:with-param name="name1" select="'compname'"/>
							<xsl:with-param name="val1" select="/ReportResponse/Company/TaxFilingName"/>
						</xsl:call-template>
						<xsl:call-template name="FieldTemplate">
							<xsl:with-param name="name1" select="'ein'"/>
							<xsl:with-param name="val1" select="concat(substring(/ReportResponse/Company/FederalEIN,1,2),'-',substring(/ReportResponse/Company/FederalEIN,3,7))"/>
						</xsl:call-template>
						<xsl:call-template name="FieldTemplate">
							<xsl:with-param name="name1" select="'state'"/>
							<xsl:with-param name="val1" select="concat(substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 1, 3), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 4, 4), '-', substring(/ReportResponse/Company/States[CompanyTaxState/State/StateId=1]/CompanyTaxState/StateEIN, 8, 1))"/>
						</xsl:call-template>
						<xsl:call-template name="FieldTemplate">
							<xsl:with-param name="name1" select="'date'"/>
							<xsl:with-param name="val1" select="$todaydate"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="'uirate'"/>
							<xsl:with-param name="val1" select="/ReportResponse/Company/CompanyTaxRates/CompanyTaxRate[TaxId=10 and TaxYear=$selectedYear]/Rate"/>
						</xsl:call-template>
						<xsl:apply-templates select="EmployeeAccumulationList/Accumulation[Month!=0]" mode="month">
							<xsl:sort select="EmployeeAccumulationList/Accumulation/Month" order="ascending"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="EmployeeAccumulationList/Accumulation[Quarter!=0]" mode="quarter">
							<xsl:sort select="EmployeeAccumulationList/Accumulation/Quarter" order="ascending"/>
						</xsl:apply-templates>

						<xsl:variable name="grossWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/PayCheckWages/GrossWage)"/>
						<xsl:variable name="futaWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='FUTA']/YTDWage)"/>
						<xsl:variable name="futaTax" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='FUTA']/YTD)"/>
						<xsl:variable name="fitWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage)"/>
						<xsl:variable name="fitTax" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='FIT']/YTD)"/>
						<xsl:variable name="ssWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage)"/>
						<xsl:variable name="ssTax" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='SS_Employee' or Tax/Code='SS_Employer']/YTD)"/>
						<xsl:variable name="mdWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage)"/>
						<xsl:variable name="mdTax" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='MD_Employee' or Tax/Code='MD_Employer']/YTD)"/>
						<xsl:variable name="tipWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Compensations/PayCheckCompensation[PayTypeId=3]/YTD)"/>
						<xsl:variable name="SSRate" select="format-number(EmployeeAccumulationList/Accumulation[Quarter=1]/Taxes/PayCheckTax[Tax/Code='SS_Employee']/Tax/Rate,'###0.00')"/>
						<xsl:variable name="tipTax" select="format-number($tipWage * $SSRate div 100,'###0.00')"/>

						<xsl:variable name ="year941" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/IRS941)"/>
						<xsl:variable name ="yearSL"  select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/CaliforniaTaxes)"/>


						<xsl:variable name="uiWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='SUI']/YTDWage)"/>
						<xsl:variable name="uiTax" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='SUI']/YTD)"/>
						<xsl:variable name="ettWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='ETT']/YTDWage)"/>
						<xsl:variable name="ettTax" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='ETT']/YTD)"/>
						<xsl:variable name="sdiWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage)"/>
						<xsl:variable name="sdiTax" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='SDI']/YTD)"/>
						<xsl:variable name="sitWage" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage)"/>
						<xsl:variable name="sitTax" select="sum(EmployeeAccumulationList/Accumulation[Quarter!=0]/Taxes/PayCheckTax[Tax/Code='SIT']/YTD)"/>
						
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t','tw')"/>
							<xsl:with-param name="val1" select="$grossWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t','EW')"/>
							<xsl:with-param name="val1" select="0"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t','ExW')"/>
							<xsl:with-param name="val1" select="$grossWage - $futaWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t','TxW')"/>
							<xsl:with-param name="val1" select="$futaWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t','fl')"/>
							<xsl:with-param name="val1" select="$futaTax"/>
						</xsl:call-template>

						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t', 'fitwage')"/>
							<xsl:with-param name="val1" select="$fitWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t', 'fit')"/>
							<xsl:with-param name="val1" select="$fitTax"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t', 'sswage')"/>
							<xsl:with-param name="val1" select="$ssWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t', 'ss')"/>
							<xsl:with-param name="val1" select="$ssTax"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t', 'stw')"/>
							<xsl:with-param name="val1" select="$tipWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t', 'stt')"/>
							<xsl:with-param name="val1" select="$tipTax"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t', 'medwage')"/>
							<xsl:with-param name="val1" select="$fitWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f1-t', 'med')"/>
							<xsl:with-param name="val1" select="$fitTax"/>
						</xsl:call-template>

						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f3-t', 't')"/>
							<xsl:with-param name="val1" select="$year941"/>
						</xsl:call-template>


						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f4-t', 'sw')"/>
							<xsl:with-param name="val1" select="$grossWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f4-t', 'uiwage')"/>
							<xsl:with-param name="val1" select="$uiWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f4-t', 'ui')"/>
							<xsl:with-param name="val1" select="$uiTax"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f4-t', 'ett')"/>
							<xsl:with-param name="val1" select="$ettTax"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f4-t', 'sdiwage')"/>
							<xsl:with-param name="val1" select="$sdiWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f4-t', 'sdi')"/>
							<xsl:with-param name="val1" select="$sdiTax"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f4-t', 'pitwage')"/>
							<xsl:with-param name="val1" select="$sitWage"/>
						</xsl:call-template>
						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f4-t', 'pit')"/>
							<xsl:with-param name="val1" select="$sitTax"/>
						</xsl:call-template>

						<xsl:call-template name="Amount">
							<xsl:with-param name="name1" select="concat('f5-t', 't')"/>
							<xsl:with-param name="val1" select="$yearSL"/>
						</xsl:call-template>
					
						
						
					</Fields>

				</Report>
				
			</Reports>
		</ReportTransformed>
	</xsl:template>
	<xsl:template match="Accumulation" mode="month">
		<xsl:variable name="grossWage" select="PayCheckWages/GrossWage"/>
		<xsl:variable name="futaWage" select="Taxes/PayCheckTax[Tax/Code='FUTA']/YTDWage"/>
		<xsl:variable name="futaTax" select="Taxes/PayCheckTax[Tax/Code='FUTA']/YTD"/>
		<xsl:variable name="fitWage" select="Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage"/>
		<xsl:variable name="fitTax" select="Taxes/PayCheckTax[Tax/Code='FIT']/YTD"/>
		<xsl:variable name="ssWage" select="Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage"/>
		<xsl:variable name="ssTax" select="sum(Taxes/PayCheckTax[Tax/Code='SS_Employee' or Tax/Code='SS_Employer']/YTD)"/>
		<xsl:variable name="mdWage" select="Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage"/>
		<xsl:variable name="mdTax" select="sum(Taxes/PayCheckTax[Tax/Code='MD_Employee' or Tax/Code='MD_Employer']/YTD)"/>
		<xsl:variable name="tipWage" select="sum(Compensations/PayCheckCompensation[PayTypeId=3]/YTD)"/>
		<xsl:variable name="SSRate" select="format-number(Taxes/PayCheckTax[Tax/Code='SS_Employee']/Tax/Rate,'###0.00')"/>
		<xsl:variable name="tipTax" select="format-number($tipWage * $SSRate div 100,'###0.00')"/>


		<xsl:variable name="uiWage" select="Taxes/PayCheckTax[Tax/Code='SUI']/YTDWage"/>
		<xsl:variable name="uiTax" select="Taxes/PayCheckTax[Tax/Code='SUI']/YTD"/>
		<xsl:variable name="ettWage" select="Taxes/PayCheckTax[Tax/Code='ETT']/YTDWage"/>
		<xsl:variable name="ettTax" select="Taxes/PayCheckTax[Tax/Code='ETT']/YTD"/>
		<xsl:variable name="sdiWage" select="Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage"/>
		<xsl:variable name="sdiTax" select="sum(Taxes/PayCheckTax[Tax/Code='SDI']/YTD)"/>
		<xsl:variable name="sitWage" select="Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage"/>
		<xsl:variable name="sitTax" select="sum(Taxes/PayCheckTax[Tax/Code='SIT']/YTD)"/>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'tw')"/>
			<xsl:with-param name="val1" select="$grossWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'EW')"/>
			<xsl:with-param name="val1" select="0"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'ExW')"/>
			<xsl:with-param name="val1" select="$grossWage - $futaWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'TxW')"/>
			<xsl:with-param name="val1" select="$futaWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'fl')"/>
			<xsl:with-param name="val1" select="$futaTax"/>
		</xsl:call-template>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'fitwage')"/>
			<xsl:with-param name="val1" select="$fitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'fit')"/>
			<xsl:with-param name="val1" select="$fitTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'sswage')"/>
			<xsl:with-param name="val1" select="$ssWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'ss')"/>
			<xsl:with-param name="val1" select="$ssTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'stw')"/>
			<xsl:with-param name="val1" select="$tipWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'stt')"/>
			<xsl:with-param name="val1" select="$tipTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'medwage')"/>
			<xsl:with-param name="val1" select="$fitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-m', Month, 'med')"/>
			<xsl:with-param name="val1" select="$fitTax"/>
		</xsl:call-template>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-m', Month, 'sw')"/>
			<xsl:with-param name="val1" select="$grossWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-m', Month, 'uiwage')"/>
			<xsl:with-param name="val1" select="$uiWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-m', Month, 'ui')"/>
			<xsl:with-param name="val1" select="$uiTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-m', Month, 'ett')"/>
			<xsl:with-param name="val1" select="$ettTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-m', Month, 'sdiwage')"/>
			<xsl:with-param name="val1" select="$sdiWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-m', Month, 'sdi')"/>
			<xsl:with-param name="val1" select="$sdiTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-m', Month, 'pitwage')"/>
			<xsl:with-param name="val1" select="$sitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-m', Month, 'pit')"/>
			<xsl:with-param name="val1" select="$sitTax"/>
		</xsl:call-template>

		
	</xsl:template>
	<xsl:template match="Accumulation" mode="quarter">
		<xsl:variable name="grossWage" select="PayCheckWages/GrossWage"/>
		<xsl:variable name="futaWage" select="Taxes/PayCheckTax[Tax/Code='FUTA']/YTDWage"/>
		<xsl:variable name="futaTax" select="Taxes/PayCheckTax[Tax/Code='FUTA']/YTD"/>
		<xsl:variable name="fitWage" select="Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage"/>
		<xsl:variable name="fitTax" select="Taxes/PayCheckTax[Tax/Code='FIT']/YTD"/>
		<xsl:variable name="ssWage" select="Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage"/>
		<xsl:variable name="ssTax" select="sum(Taxes/PayCheckTax[Tax/Code='SS_Employee' or Tax/Code='SS_Employer']/YTD)"/>
		<xsl:variable name="mdWage" select="Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage"/>
		<xsl:variable name="mdTax" select="sum(Taxes/PayCheckTax[Tax/Code='MD_Employee' or Tax/Code='MD_Employer']/YTD)"/>
		<xsl:variable name="tipWage" select="sum(Compensations/PayCheckCompensation[PayTypeId=3]/YTD)"/>
		<xsl:variable name="SSRate" select="format-number(Taxes/PayCheckTax[Tax/Code='SS_Employee']/Tax/Rate,'###0.00')"/>
		<xsl:variable name="tipTax" select="format-number($tipWage * $SSRate div 100,'###0.00')"/>


		<xsl:variable name="uiWage" select="Taxes/PayCheckTax[Tax/Code='SUI']/YTDWage"/>
		<xsl:variable name="uiTax" select="Taxes/PayCheckTax[Tax/Code='SUI']/YTD"/>
		<xsl:variable name="ettWage" select="Taxes/PayCheckTax[Tax/Code='ETT']/YTDWage"/>
		<xsl:variable name="ettTax" select="Taxes/PayCheckTax[Tax/Code='ETT']/YTD"/>
		<xsl:variable name="sdiWage" select="Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage"/>
		<xsl:variable name="sdiTax" select="sum(Taxes/PayCheckTax[Tax/Code='SDI']/YTD)"/>
		<xsl:variable name="sitWage" select="Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage"/>
		<xsl:variable name="sitTax" select="sum(Taxes/PayCheckTax[Tax/Code='SIT']/YTD)"/>
		<xsl:variable name="fmonth" select="Quarter*3 - 2"/>
		<xsl:variable name="smonth" select="Quarter*3 - 1"/>
		<xsl:variable name="tmonth" select="Quarter*3"/>

		<xsl:variable name="firstMonth" select="MonthlyAccumulations/MonthlyAccumulation[Month=$fmonth]/IRS941"/>
		<xsl:variable name="secondMonth" select="MonthlyAccumulations/MonthlyAccumulation[Month=$smonth]/IRS941"/>
		<xsl:variable name="thirdMonth"  select="MonthlyAccumulations/MonthlyAccumulation[Month=$tmonth]/IRS941"/>
		<xsl:variable name="quarter941" select="IRS941"/>

		<xsl:variable name="firstMonthS" select="MonthlyAccumulations/MonthlyAccumulation[Month=$fmonth]/EDD"/>
		<xsl:variable name="secondMonthS" select="MonthlyAccumulations/MonthlyAccumulation[Month=$smonth]/EDD"/>
		<xsl:variable name="thirdMonthS" select="MonthlyAccumulations/MonthlyAccumulation[Month=$tmonth]/EDD"/>
		<xsl:variable name="quarterSL" select="CaliforniaTaxes"/>
		
		
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'tw')"/>
			<xsl:with-param name="val1" select="$grossWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'EW')"/>
			<xsl:with-param name="val1" select="0"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'ExW')"/>
			<xsl:with-param name="val1" select="$grossWage - $futaWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'TxW')"/>
			<xsl:with-param name="val1" select="$futaWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'fl')"/>
			<xsl:with-param name="val1" select="$futaTax"/>
		</xsl:call-template>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'fitwage')"/>
			<xsl:with-param name="val1" select="$fitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'fit')"/>
			<xsl:with-param name="val1" select="$fitTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'sswage')"/>
			<xsl:with-param name="val1" select="$ssWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'ss')"/>
			<xsl:with-param name="val1" select="$ssTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'stw')"/>
			<xsl:with-param name="val1" select="$tipWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'stt')"/>
			<xsl:with-param name="val1" select="$tipTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'medwage')"/>
			<xsl:with-param name="val1" select="$fitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-q', Quarter, 'med')"/>
			<xsl:with-param name="val1" select="$fitTax"/>
		</xsl:call-template>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f3-q', Quarter, 'm1')"/>
			<xsl:with-param name="val1" select="$firstMonth"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f3-q', Quarter, 'm2')"/>
			<xsl:with-param name="val1" select="$secondMonth"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f3-q', Quarter, 'm3')"/>
			<xsl:with-param name="val1" select="$thirdMonth"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f3-q', Quarter, 't')"/>
			<xsl:with-param name="val1" select="$quarter941"/>
		</xsl:call-template>


		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'sw')"/>
			<xsl:with-param name="val1" select="$grossWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'uiwage')"/>
			<xsl:with-param name="val1" select="$uiWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'ui')"/>
			<xsl:with-param name="val1" select="$uiTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'ett')"/>
			<xsl:with-param name="val1" select="$ettTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'sdiwage')"/>
			<xsl:with-param name="val1" select="$sdiWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'sdi')"/>
			<xsl:with-param name="val1" select="$sdiTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'pitwage')"/>
			<xsl:with-param name="val1" select="$sitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'pit')"/>
			<xsl:with-param name="val1" select="$sitTax"/>
		</xsl:call-template>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f5-q', Quarter, 'm1')"/>
			<xsl:with-param name="val1" select="$firstMonthS"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f5-q', Quarter, 'm2')"/>
			<xsl:with-param name="val1" select="$secondMonthS"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f5-q', Quarter, 'm3')"/>
			<xsl:with-param name="val1" select="$thirdMonthS"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f5-q', Quarter, 't')"/>
			<xsl:with-param name="val1" select="$quarterSL"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="CompanyAccumulation">
		<xsl:variable name="futaWage" select="Taxes/PayrollTax[Tax/Code='FUTA']/TaxableWage"/>
		<xsl:variable name="futaTax" select="Taxes/PayrollTax[Tax/Code='FUTA']/Amount"/>
		<xsl:variable name="fitWage" select="Taxes/PayrollTax[Tax/Code='FIT']/TaxableWage"/>
		<xsl:variable name="fitTax" select="Taxes/PayrollTax[Tax/Code='FIT']/Amount"/>
		<xsl:variable name="ssWage" select="Taxes/PayrollTax[Tax/Code='SS_Employee']/TaxableWage"/>
		<xsl:variable name="ssTax" select="sum(Taxes/PayrollTax[Tax/Code='SS_Employee' or Tax/Code='SS_Employer']/Amount)"/>
		<xsl:variable name="mdWage" select="Taxes/PayrollTax[Tax/Code='MD_Employee']/TaxableWage"/>
		<xsl:variable name="mdTax" select="sum(Taxes/PayrollTax[Tax/Code='MD_Employee' or Tax/Code='MD_Employer']/Amount)"/>
		<xsl:variable name="tipWage" select="sum(Compensations/PayrollPayType[PayType/Id=3]/Amount)"/>
		<xsl:variable name="SSRate" select="format-number(Taxes/PayrollTax[Tax/Code='SS_Employee']/Tax/Rate,'###0.00')"/>
		<xsl:variable name="tipTax" select="format-number($tipWage * $SSRate div 100,'###0.00')"/>
		<xsl:variable name="year941" select="sum(Taxes/PayrollTax[Tax/Id &lt; 6]/Amount)"/>
		<xsl:variable name="yearSL" select="sum(Taxes/PayrollTax[Tax/Id>6 and Tax/Id &lt; 11]/Amount)"/>

		<xsl:variable name="sitWage" select="Taxes/PayrollTax[Tax/Code='SIT']/TaxableWage"/>
		<xsl:variable name="sitTax" select="Taxes/PayrollTax[Tax/Code='SIT']/Amount"/>
		<xsl:variable name="sdiWage" select="Taxes/PayrollTax[Tax/Code='SDI']/TaxableWage"/>
		<xsl:variable name="sdiTax" select="Taxes/PayrollTax[Tax/Code='SDI']/Amount"/>
		<xsl:variable name="ettWage" select="Taxes/PayrollTax[Tax/Code='ETT']/TaxableWage"/>
		<xsl:variable name="ettTax" select="sum(Taxes/PayrollTax[Tax/Code='ETT']/Amount)"/>
		<xsl:variable name="uiWage" select="Taxes/PayrollTax[Tax/Code='SUI']/TaxableWage"/>
		<xsl:variable name="uiTax" select="sum(Taxes/PayrollTax[Tax/Code='SUI']/Amount)"/>
		
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t','tw')"/>
			<xsl:with-param name="val1" select="GrossWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t','EW')"/>
			<xsl:with-param name="val1" select="0"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t','ExW')"/>
			<xsl:with-param name="val1" select="GrossWage - $futaWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t','TxW')"/>
			<xsl:with-param name="val1" select="$futaWage"/>
		</xsl:call-template>
		<xsl:call-template name="FieldTemplate">
			<xsl:with-param name="name1" select="concat('f1-t','fl')"/>
			<xsl:with-param name="val1" select="$futaTax"/>
		</xsl:call-template>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 'fitwage')"/>
			<xsl:with-param name="val1" select="$fitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 'fit')"/>
			<xsl:with-param name="val1" select="$fitTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 'sswage')"/>
			<xsl:with-param name="val1" select="$ssWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 'ss')"/>
			<xsl:with-param name="val1" select="$ssTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 'stw')"/>
			<xsl:with-param name="val1" select="$tipWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 'stt')"/>
			<xsl:with-param name="val1" select="$tipTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 'medwage')"/>
			<xsl:with-param name="val1" select="$fitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 'med')"/>
			<xsl:with-param name="val1" select="$fitTax"/>
		</xsl:call-template>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f1-t', 't')"/>
			<xsl:with-param name="val1" select="$year941"/>
		</xsl:call-template>


		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-t', 'sw')"/>
			<xsl:with-param name="val1" select="GrossWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-t', 'uiwage')"/>
			<xsl:with-param name="val1" select="$uiWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-t', 'ui')"/>
			<xsl:with-param name="val1" select="$uiTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-t', 'ett')"/>
			<xsl:with-param name="val1" select="$ettTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-t', 'sdiwage')"/>
			<xsl:with-param name="val1" select="$sdiWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-t', 'sdi')"/>
			<xsl:with-param name="val1" select="$sdiTax"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-t', 'pitwage')"/>
			<xsl:with-param name="val1" select="$sitWage"/>
		</xsl:call-template>
		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f4-t', 'pit')"/>
			<xsl:with-param name="val1" select="$sitTax"/>
		</xsl:call-template>

		<xsl:call-template name="Amount">
			<xsl:with-param name="name1" select="concat('f5-t', 't')"/>
			<xsl:with-param name="val1" select="$yearSL"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>