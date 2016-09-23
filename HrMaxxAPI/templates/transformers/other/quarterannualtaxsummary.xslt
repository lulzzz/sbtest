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
			<Name>QuarterAnnualTaxSummary-<xsl:value-of select="$selectedYear"/></Name>
			<Reports>
				<Report>
					<TemplatePath>OtherForms\</TemplatePath>
					<Template>QuarterAnnualTaxSummary.pdf</Template>
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
						<xsl:apply-templates select="Cubes[CompanyPayrollCube/Quarter]"/>
						<xsl:apply-templates select="CompanyAccumulation"/>
						
					</Fields>

				</Report>
				
			</Reports>
		</ReportTransformed>
	</xsl:template>
	<xsl:template match="CompanyPayrollCube">
		<xsl:variable name="grossWage" select="Accumulation/GrossWage"/>
		<xsl:variable name="futaWage" select="Accumulation/Taxes/PayrollTax[Tax/Id=6]/TaxableWage"/>
		<xsl:variable name="futaTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=6]/Amount"/>
		<xsl:variable name="fitWage" select="Accumulation/Taxes/PayrollTax[Tax/Id=1]/TaxableWage"/>
		<xsl:variable name="fitTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=1]/Amount"/>
		<xsl:variable name="ssWage" select="Accumulation/Taxes/PayrollTax[Tax/Id=4]/TaxableWage"/>
		<xsl:variable name="ssTax" select="sum(Accumulation/Taxes/PayrollTax[Tax/Id=4 or Tax/Id=5]/Amount)"/>
		<xsl:variable name="mdWage" select="Accumulation/Taxes/PayrollTax[Tax/Id=2]/TaxableWage"/>
		<xsl:variable name="mdTax" select="sum(Accumulation/Taxes/PayrollTax[Tax/Id=2 or Tax/Id=3]/Amount)"/>
		<xsl:variable name="tipWage" select="sum(Accumulation/Compensations/PayrollPayType[PayType/Id=3]/Amount)"/>
		<xsl:variable name="SSRate" select="format-number(/ReportResponse/CompanyAccumulation/Taxes/PayrollTax[Tax/Id=4]/Tax/Rate,'###0.00')"/>
		<xsl:variable name="tipTax" select="format-number($tipWage * $SSRate div 100,'###0.00')"/>
		<xsl:variable name="fmonth" select="Quarter*3 - 2"/>
		<xsl:variable name="smonth" select="Quarter*3 - 1"/>
		<xsl:variable name="tmonth" select="Quarter*3"/>
		<xsl:variable name="firstMonth" select="sum(/ReportResponse/Cubes/CompanyPayrollCube[Month=$fmonth]/Accumulation/Taxes/PayrollTax[Tax/Id &lt; 6]/Amount)"/>
		<xsl:variable name="secondMonth" select="sum(/ReportResponse/Cubes/CompanyPayrollCube[Month=$smonth]/Accumulation/Taxes/PayrollTax[Tax/Id &lt; 6]/Amount)"/>
		<xsl:variable name="thirdMonth" select="sum(/ReportResponse/Cubes/CompanyPayrollCube[Month=$tmonth]/Accumulation/Taxes/PayrollTax[Tax/Id &lt; 6]/Amount)"/>
		<xsl:variable name="quarter941" select="sum(Accumulation/Taxes/PayrollTax[Tax/Id &lt; 6]/Amount)"/>

		<xsl:variable name="firstMonthS" select="sum(/ReportResponse/Cubes/CompanyPayrollCube[Month=$fmonth]/Accumulation/Taxes/PayrollTax[Tax/Id>6 and Tax/Id &lt; 11]/Amount)"/>
		<xsl:variable name="secondMonthS" select="sum(/ReportResponse/Cubes/CompanyPayrollCube[Month=$smonth]/Accumulation/Taxes/PayrollTax[Tax/Id>6 and Tax/Id &lt; 11]/Amount)"/>
		<xsl:variable name="thirdMonthS" select="sum(/ReportResponse/Cubes/CompanyPayrollCube[Month=$tmonth]/Accumulation/Taxes/PayrollTax[Tax/Id>6 and Tax/Id &lt; 11]/Amount)"/>
		<xsl:variable name="quarterSL" select="sum(Accumulation/Taxes/PayrollTax[Tax/Id>6 and Tax/Id &lt; 11]/Amount)"/>

		<xsl:variable name="uiWage" select="Accumulation/Taxes/PayrollTax[Tax/Id=10]/TaxableWage"/>
		<xsl:variable name="uiTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=10]/Amount"/>
		<xsl:variable name="ettWage" select="Accumulation/Taxes/PayrollTax[Tax/Id=9]/TaxableWage"/>
		<xsl:variable name="ettTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=9]/Amount"/>
		<xsl:variable name="sdiWage" select="Accumulation/Taxes/PayrollTax[Tax/Id=8]/TaxableWage"/>
		<xsl:variable name="sdiTax" select="sum(Accumulation/Taxes/PayrollTax[Tax/Id=8]/Amount)"/>
		<xsl:variable name="sitWage" select="Accumulation/Taxes/PayrollTax[Tax/Id=7]/TaxableWage"/>
		<xsl:variable name="sitTax" select="sum(Accumulation/Taxes/PayrollTax[Tax/Id=7]/Amount)"/>
		
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
			<xsl:with-param name="name1" select="concat('f4-q', Quarter, 'pitWage')"/>
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
		<xsl:variable name="futaWage" select="Taxes/PayrollTax[Tax/Id=6]/TaxableWage"/>
		<xsl:variable name="futaTax" select="Taxes/PayrollTax[Tax/Id=6]/Amount"/>
		<xsl:variable name="fitWage" select="Taxes/PayrollTax[Tax/Id=1]/TaxableWage"/>
		<xsl:variable name="fitTax" select="Taxes/PayrollTax[Tax/Id=1]/Amount"/>
		<xsl:variable name="ssWage" select="Taxes/PayrollTax[Tax/Id=4]/TaxableWage"/>
		<xsl:variable name="ssTax" select="sum(Taxes/PayrollTax[Tax/Id=4 or Tax/Id=5]/Amount)"/>
		<xsl:variable name="mdWage" select="Taxes/PayrollTax[Tax/Id=2]/TaxableWage"/>
		<xsl:variable name="mdTax" select="sum(Taxes/PayrollTax[Tax/Id=2 or Tax/Id=3]/Amount)"/>
		<xsl:variable name="tipWage" select="sum(Compensations/PayrollPayType[PayType/Id=3]/Amount)"/>
		<xsl:variable name="SSRate" select="format-number(Taxes/PayrollTax[Tax/Id=4]/Tax/Rate,'###0.00')"/>
		<xsl:variable name="tipTax" select="format-number($tipWage * $SSRate div 100,'###0.00')"/>
		<xsl:variable name="year941" select="sum(Taxes/PayrollTax[Tax/Id &lt; 6]/Amount)"/>
		<xsl:variable name="yearSL" select="sum(Taxes/PayrollTax[Tax/Id>6 and Tax/Id &lt; 11]/Amount)"/>

		<xsl:variable name="sitWage" select="Taxes/PayrollTax[Tax/Id=7]/TaxableWage"/>
		<xsl:variable name="sitTax" select="Taxes/PayrollTax[Tax/Id=7]/Amount"/>
		<xsl:variable name="sdiWage" select="Taxes/PayrollTax[Tax/Id=8]/TaxableWage"/>
		<xsl:variable name="sdiTax" select="Taxes/PayrollTax[Tax/Id=8]/Amount"/>
		<xsl:variable name="ettWage" select="Taxes/PayrollTax[Tax/Id=9]/TaxableWage"/>
		<xsl:variable name="ettTax" select="sum(Taxes/PayrollTax[Tax/Id=9]/Amount)"/>
		<xsl:variable name="uiWage" select="Taxes/PayrollTax[Tax/Id=10]/TaxableWage"/>
		<xsl:variable name="uiTax" select="sum(Taxes/PayrollTax[Tax/Id=10]/Amount)"/>
		
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
			<xsl:with-param name="name1" select="concat('f4-t', 'pitWage')"/>
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