<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
	<xsl:param name="identifier"/>
  <xsl:param name="endQuarterMonth"/>
  <xsl:param name="selectedYear"/>
	<xsl:param name="quarter"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="/">
<xsl:apply-templates select="ExtractHost" >
</xsl:apply-templates>
    
  </xsl:template>
  <xsl:template match="ExtractHost">
		<xsl:variable name="TotalGrossPay" select="format-number(PayCheckAccumulations/PayCheckWages/GrossWage,'###0.00')"/>
		
		
		<xsl:variable name="SUIRate">
			<xsl:value-of select="format-number(HostCompany/CompanyTaxRates/CompanyTaxRate[TaxId=10 and TaxYear=$selectedYear]/Rate div 100, '#0.00000')"/>
		</xsl:variable>
		<xsl:variable name="ETTRate">
			<xsl:value-of select="format-number(HostCompany/CompanyTaxRates/CompanyTaxRate[TaxId=9 and TaxYear=$selectedYear]/Rate div 100, '#0.00000')"/>
		</xsl:variable>
		<xsl:variable name="SUIWage" select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTDWage,'###0.00')"/>
		<xsl:variable name="UIContribution" select="format-number($SUIWage*$SUIRate,'###0.00')"/>

		<xsl:variable name="ETTWage" select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='ETT']/YTDWage,'###0.00')"/>
		<xsl:variable name="ETTContribution" select="format-number($ETTWage*$ETTRate,'###0.00')"/>
		<xsl:variable name="SDIRate" select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/Tax/Rate,'###0.00')"/>
		<xsl:variable name="SDIWage" select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage,'###0.00')"/>
		<xsl:variable name="SDIContribution" select="format-number($SDIWage*$SDIRate div 100,'###0.00')"/>
		<xsl:variable name="SITTax" select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SIT']/YTD,'###0.00')"/>
		<xsl:variable name="SUITax" select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTD,'###0.00')"/>
		<xsl:variable name="SDITax" select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/YTD,'###0.00')"/>
		<xsl:variable name="ETTTax" select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='ETT']/YTD,'###0.00')"/>
		<xsl:variable name="box18" select="format-number($UIContribution + $ETTContribution + $SDIContribution + $SITTax,'###0.00')"/>
		<xsl:variable name="TotalStateTax" select="format-number($SITTax + $SUITax + $SDITax + $ETTTax,'###0.00')"/>
		<xsl:variable name="Total" select="format-number($box18 - $TotalStateTax,'###0.00')"/>
		<ReturnDataState xsi:schemaLocation="http://www.irs.gov/efile/ReturnDataState.xsd" xmlns="http://www.irs.gov/efile" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<ContentLocation>
				<xsl:value-of select="concat($identifier,'-',HostCompany/Id)"/>
			</ContentLocation>
			<ReturnHeaderState>
				<ReturnQuarter>
					<xsl:value-of select="$quarter"/>
				</ReturnQuarter>
				<Taxyear>
					<xsl:value-of select="$selectedYear"/>
				</Taxyear>
				
				<ReturnType>StateAnnual</ReturnType>
				<StateEIN>
					<TypeStateEIN>WithholdingAccountNo</TypeStateEIN>
					<StateEINValue>
						<xsl:value-of select="translate(States/CompanyTaxState[State/StateId=1]/StateEIN,'-','')"/>
					</StateEINValue>
				</StateEIN>
				<StateCode>CA</StateCode>
				</ReturnHeaderState>
				<StateGeneralInformation>
					<BusinessAddress>
						<BusinessName>
							<BusinessNameLine1>
								<xsl:value-of select="translate(translate(HostCompany/TaxFilingName,'.',''),',','')"/>
							</BusinessNameLine1>
						</BusinessName>
						<Address>
							<USAddress>
								<AddressLine1><xsl:value-of select="HostCompany/BusinessAddress/AddressLine1"/></AddressLine1>
								<City>
									<xsl:value-of select="HostCompany/BusinessAddress/City"/>
								</City>
								<State>
									<xsl:value-of select="'CA'"/>
								</State>
								<ZIPCode>
									<xsl:value-of select="HostCompany/BusinessAddress/Zip"/>
								</ZIPCode>
							</USAddress>
						</Address>
					</BusinessAddress>
				</StateGeneralInformation>
				<StateAnnual>
				<TotalWagesYear>
					<xsl:value-of select="PayCheckAccumulation/PayCheckWages/GrossWage"/>
				</TotalWagesYear>
				<TotalIncomeTaxWithheld>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SIT']/YTD"/>
				</TotalIncomeTaxWithheld>
				<UITaxableWagesYear>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTDWage"/>
				</UITaxableWagesYear>
				<UITaxRate>
					<xsl:value-of select="$SUIRate"/>
				</UITaxRate>
				<UITaxesYear>
					<xsl:value-of select="$UIContribution"/>
				</UITaxesYear>
				<EmploymentTrainingTaxRate>
					<xsl:value-of select="$ETTRate"/>
				</EmploymentTrainingTaxRate>
				<EmploymentTrainingTaxesYear>
					<xsl:value-of select="$ETTContribution"/>
				</EmploymentTrainingTaxesYear>
				<DITaxableWagesYear>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage"/>
				</DITaxableWagesYear>
				<DITaxRate>
					<xsl:value-of select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/Tax/Rate div 100, '#0.00000')"/>
				</DITaxRate>
				<DITaxesYear>
					<xsl:value-of select="$SDIContribution"/>
				</DITaxesYear>
					<TotalContributionsYear>
						<xsl:value-of select="$box18"/>
					</TotalContributionsYear>
				<TotalCreditsYear>
					<xsl:value-of select="$TotalStateTax"/>
				</TotalCreditsYear>
				
			</StateAnnual>
		</ReturnDataState>

  </xsl:template>
  
</xsl:stylesheet>
